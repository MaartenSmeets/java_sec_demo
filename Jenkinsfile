pipeline {
    agent any

    tools {
        jdk 'jdk-11'
        maven 'mvn-3.6.3'
    }

    stages {
        stage('Build') {
            steps {
                withMaven(maven: 'mvn-3.6.3') {
                    sh "mvn package"
                }
            }
        }

        stage('Run Tests') {
            parallel {
                stage('OWASP Dependency-Check Vulnerabilities') {
                    steps {
                        withMaven(maven: 'mvn-3.6.3') {
                            sh 'mvn dependency-check:check'
                        }
                        dependencyCheckPublisher pattern: 'target/dependency-check-report.xml'
                    }
                }

                stage('PMD SpotBugs') {
                    steps {
                        withMaven(maven: 'mvn-3.6.3') {
                            sh 'mvn pmd:pmd pmd:cpd spotbugs:spotbugs'
                        }

                        recordIssues enabledForFailure: true, tool: spotBugs()
                        recordIssues enabledForFailure: true, tool: cpd(pattern: '**/target/cpd.xml')
                        recordIssues enabledForFailure: true, tool: pmdParser(pattern: '**/target/pmd.xml')
                    }
                }
            }
        }


        stage('Create and push container') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    withMaven(maven: 'mvn-3.6.3') {
                        sh "mvn jib:build"
                    }
                }
            }
        }

        stage('Anchore analyse') {
            steps {
                writeFile file: 'anchore_images', text: 'docker.io/maartensmeets/spring-boot-demo'
                anchore name: 'anchore_images'
            }
        }

        stage('Ready to proceed?') {
            steps {
                input("Ready to proceed?")
            }
        }

        stage('ZAP') {
            steps {
                withMaven(maven: 'mvn-3.6.3') {
                    sh 'mvn zap:analyze'
                    publishHTML(target: [
                            allowMissing         : false,
                            alwaysLinkToLastBuild: false,
                            keepAll              : true,
                            reportDir            : 'target/zap-reports',
                            reportFiles          : 'zapReport.html',
                            reportName           : "ZAP report"
                    ])
                }
            }
        }

        stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv(credentialsId: 'sonarqube-secret', installationName: 'sonarqube-server') {
                    withMaven(maven: 'mvn-3.6.3') {
                        sh 'mvn sonar:sonar -Dsonar.dependencyCheck.jsonReportPath=target/dependency-check-report.json -Dsonar.dependencyCheck.xmlReportPath=target/dependency-check-report.xml -Dsonar.dependencyCheck.htmlReportPath=target/dependency-check-report.html -Dsonar.java.pmd.reportPaths=target/pmd.xml -Dsonar.java.spotbugs.reportPaths=target/spotbugsXml.xml -Dsonar.zaproxy.reportPath=target/zap-reports/zapReport.xml -Dsonar.zaproxy.htmlReportPath=target/zap-reports/zapReport.html'
                    }
                }
            }
        }

        stage("Quality gate") {
            steps {
                sh 'sleep 10'
                waitForQualityGate abortPipeline: true
            }
        }
    }
}
