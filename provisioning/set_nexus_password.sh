OLD_PASSWORD=`docker exec -it provisioning_nexus_1 cat /nexus-data/admin.password`
NEW_PASSWORD="Welcome01"

curl -ifu admin:"${OLD_PASSWORD}" \
  -XPUT -H 'Content-Type: text/plain' \
  --data "${NEW_PASSWORD}" \
  http://localhost:8081/service/rest/v1/security/users/admin/change-password
