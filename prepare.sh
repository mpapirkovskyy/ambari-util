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
	mvn clean package -DskipTests -Dfindbugs.skip
fi

#cd $AMBARI_DIR/ambari-server/target
#tar zxvf $AMBARI_DIR/ambari-server/target/ambari-server*.tar.gz
rm -rf $AMBARI_DIR/launch-dir
cp -r $AMBARI_DIR/ambari-server/target/ambari-server-*-dist/ambari-server-* launch-dir
cd $AMBARI_DIR/launch-dir
cp $AMBARI_UTIL_DIR/ambari.properties etc/ambari-server/conf
cp $AMBARI_UTIL_DIR/log4j.properties etc/ambari-server/conf
cp $AMBARI_UTIL_DIR/version var/lib/ambari-server/resources
cp $AMBARI_UTIL_DIR/jdk-6u31-linux-x64.bin var/lib/ambari-server/resources

rm -rf web
ln -s $AMBARI_DIR/ambari-web/public web
# comment out the line above and modify/uncomment the line below to 
# allow ambari-web development directly from the host
# ln -s /host/ambari-web/public web

# start the server
#java -cp etc/ambari-server/conf/:lib/ambari-server/* org.apache.ambari.server.controller.AmbariServer 

