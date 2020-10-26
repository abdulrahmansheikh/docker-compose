#!/bin/bash

echo "\nWait for connectors to be alive"
#until [[ $(curl -I --silent -o /dev/null -w %{http_code} -u admin:admin localhost:8083/connectors/) =~ 2[0-9][0-9]  ]] ;do
#    printf '.'
#    sleep 2
#done

echo "\nlist connectors"
curl -H "Accept:application/json" localhost:8083/connectors/

echo "\nadd debezium mysql connector configuration"
curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{
   "name":"staging-inventory-connector",
   "config":{
      "connector.class":"io.debezium.connector.mysql.MySqlConnector",
      "tasks.max":"1",
      "database.hostname":"mysql",
      "database.port":"3306",
      "database.user":"debezium",
      "database.password":"dbz",
      "database.server.id":"1000",
      "database.server.name":"staging-db",
      "database.whitelist":"bigw-staging-local",
      "database.history.kafka.bootstrap.servers":"broker:29092",
      "table.whitelist":"bigw-staging-local.inventory",
      "database.history.kafka.topic":"1000-staging-inventory-connector-history-topic",
      "include.schema.changes":"false",
      "database.history.kafka.recovery.poll.interval.ms":"10000",
      "message.key.columns":"bigw-staging-local.inventory:articleId,siteId"
   }
}'

echo "\nlist connectors"
curl -H "Accept:application/json" localhost:8083/connectors/
