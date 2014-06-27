#!/bin/bash

#pwd
#VER = $(cat $AMBARI_UTIL_DIR/version)
#echo $VER

#cp -f $AMBARI_DIR/ambari-server/src/main/resources/Ambari-DDL-Postgres-CREATE.sql /tmp
cp -f $AMBARI_DIR/ambari-server/src/main/resources/Ambari-DDL-Postgres-EMBEDDED-DROP.sql /tmp

sed 's/\${ambariVersion}/'"$(cat $AMBARI_UTIL_DIR/version)"'/g' $AMBARI_DIR/ambari-server/src/main/resources/Ambari-DDL-Postgres-EMBEDDED-CREATE.sql > /tmp/Ambari-DDL-Postgres-EMBEDDED-CREATE.sql 

sudo -u postgres psql -U postgres -f /tmp/Ambari-DDL-Postgres-EMBEDDED-DROP.sql -v username="\"ambari\"" -v password="'bigdata'" -v dbname='ambari'
sudo -u postgres psql -U postgres -f /tmp/Ambari-DDL-Postgres-EMBEDDED-CREATE.sql -v username="\"ambari\"" -v password="'bigdata'" -v dbname='ambari'

