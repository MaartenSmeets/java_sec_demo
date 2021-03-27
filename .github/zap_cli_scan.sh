#!/bin/sh
#copied and altered from https://gist.github.com/ian-bartholomew/0b85c8764a6a1098bf121c1162236fe3

echo Present working directory: $PWD
echo Permissions: `ls -altr $PWD`

DOCKER=`which docker`
IMAGE='owasp/zap2docker-weekly'
URL='http://spring-boot-demo:8080/rest/demo'
ZAP_API_PORT='8090'

# Start our container
CONTAINER_ID=`$DOCKER run -d \
  --network zap \
  -p $ZAP_API_PORT:$ZAP_API_PORT \
  -v $PWD:/zap/reports:rw \
  -i $IMAGE zap.sh \
  -daemon -port $ZAP_API_PORT \
  -host 0.0.0.0 \
  -config api.disablekey=true \
  -config api.addrs.addr.name=.* \
  -config api.addrs.addr.regex=true`

echo "\nWaiting for ZAP to start"
# Poll the api and wait for it to start up
while ! curl -s http://0.0.0.0:$ZAP_API_PORT > /dev/null
do
 sleep .5
done
echo "\nZAP has successfully started"

# Open the provided url
$DOCKER exec $CONTAINER_ID \
  zap-cli -p $ZAP_API_PORT open-url $URL

# Spider the site 
$DOCKER exec $CONTAINER_ID \
  zap-cli -v -p $ZAP_API_PORT spider $URL

echo "\nPerforming ZAP scan"
# Scan the site
$DOCKER exec $CONTAINER_ID \
  zap-cli -v -p $ZAP_API_PORT active-scan \
  --recursive $URL

# Show any alerts 
$DOCKER exec $CONTAINER_ID \
  zap-cli -p $ZAP_API_PORT alerts -l Low

# Generate our report
echo "\nGenerating ZAP report"
$DOCKER exec $CONTAINER_ID \
  zap-cli -p $ZAP_API_PORT report \
  -o /zap/reports/owaspreport.html -f html

echo "\nCleaning up ZAP"
# Shut down the docker image
$DOCKER kill $CONTAINER_ID
echo "\nDone ZAP"
