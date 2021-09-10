<?xml version='1.0' ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:b="https://jeremylong.github.io/DependencyCheck/dependency-check.2.5.xsd" xmlns:a="http://pmd.sourceforge.net/report/2.0.0">
    <xsl:template match="/">
        <a:pmd xmlns="http://pmd.sourceforge.net/report/2.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://pmd.sourceforge.net/report/2.0.0 http://pmd.sourceforge.net/report_2_0_0.xsd" version="6.29.0">
            <xsl:attribute name="timestamp">
                <xsl:value-of select="current-dateTime()"/>
            </xsl:attribute>
            <xsl:for-each select="b:analysis/b:dependencies/b:dependency[count(b:vulnerabilities/b:vulnerability)>0]">
                <a:file name="pom.xml">
                    <xsl:for-each select="b:vulnerabilities/b:vulnerability">
                        <violation begincolumn="1" beginline="1" endcolumn="1" endline="1">
                            <xsl:attribute name="externalInfoUrl">
                                <xsl:value-of select="concat('https://nvd.nist.gov/vuln/detail/',b:name)"/>
                            </xsl:attribute>
                            <xsl:attribute name="priority">
                                <xsl:value-of select="ceiling((10 - number(b:cvssV3/b:baseScore)) * 0.5)"/>
                            </xsl:attribute>
                            <xsl:attribute name="rule">
                                <xsl:value-of select="b:name"/>
                            </xsl:attribute>
                            <xsl:attribute name="ruleset">
                                <xsl:value-of select="@source"/>
                            </xsl:attribute>
                            <xsl:value-of select='concat("Filename: ",../../b:fileName," | Reference: ",b:name," | CVSS Score: ",b:cvssV3/b:baseScore," | Category: ",b:cwes/b:cwe[1]," | ",b:description)'/>
                        </violation>
                    </xsl:for-each>
                </a:file>
            </xsl:for-each>
        </a:pmd>
    </xsl:template>
</xsl:stylesheet>