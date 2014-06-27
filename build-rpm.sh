#!/bin/sh

cd $AMBARI_DIR
#mvn versions:set -DnewVersion=$(cat $AMBARI_UTIL_DIR/version)
mvn clean package rpm:rpm -DskipTests=true -Dfindbugs.skip
cp ambari-server/target/rpm/ambari-server/RPMS/noarch/ambari-server-*.noarch.rpm $AMBARI_UTIL_DIR/ambari-server.rpm
cp ambari-agent/target/rpm/ambari-agent/RPMS/x86_64/ambari-agent-*.x86_64.rpm $AMBARI_UTIL_DIR/ambari-agent.rpm
#cp ambari-server.rpm ambari-agent.rpm ~/vagrant

