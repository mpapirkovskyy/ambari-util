#!/bin/sh

cd $AMBARI_DIR
if [ $# -gt 0 ]; then
	case "$1" in
		"quick" )
			SKIP_BUILD=1
			;;
	esac
fi

if [ -z "$SKIP_BUILD" ]; then
	mvn clean package -DskipTests -Dfindbugs.skip -Drat.ignoreErrors
fi

#cd $AMBARI_DIR/ambari-server/target
#tar zxvf $AMBARI_DIR/ambari-server/target/ambari-server*.tar.gz
rm -rf $AMBARI_UTIL_DIR/launch-dir
cp -r $AMBARI_DIR/ambari-server/target/ambari-server-*-dist/ambari-server-* $AMBARI_UTIL_DIR/launch-dir
cd $AMBARI_UTIL_DIR/launch-dir
cp $AMBARI_UTIL_DIR/ambari.properties etc/ambari-server/conf
cp $AMBARI_UTIL_DIR/log4j.properties etc/ambari-server/conf
cp $AMBARI_UTIL_DIR/version var/lib/ambari-server/resources
cp $AMBARI_UTIL_DIR/jdk-6u31-linux-x64.bin var/lib/ambari-server/resources
cp $AMBARI_DIR/ambari-server/conf/unix/ca.config $AMBARI_UTIL_DIR/launch-dir/keystore
cp -r $AMBARI_DIR/ambari-server/src/main/resources/custom_action_definitions var/lib/ambari-server/resources/
cp -r $AMBARI_DIR/ambari-server/src/main/resources/custom_actions var/lib/ambari-server/resources/
sed -i 's|/var/lib/ambari-server/keys/db|'"$AMBARI_UTIL_DIR"'/launch-dir/keystore/db|' $AMBARI_UTIL_DIR/launch-dir/keystore/ca.config


rm -rf web
mkdir web
cp -r $AMBARI_DIR/ambari-web/public/* web

AMBARI_VER=`cat var/lib/ambari-server/resources/version`
APPJS=web/javascripts/app.js
gunzip -f $APPJS.gz
sed "s/App.version.*=.*;/App.version = '$AMBARI_VER';/" $APPJS > tmp.js
mv tmp.js $APPJS
gzip $APPJS

# comment out the line above and modify/uncomment the line below to 
# allow ambari-web development directly from the host
# ln -s /host/ambari-web/public web

# start the server
#java -cp etc/ambari-server/conf/:lib/ambari-server/* org.apache.ambari.server.controller.AmbariServer 

