#!/bin/sh

LOCALCLASSPATH=.:build-core:build-demo
for i in lib/*.jar ;
	do LOCALCLASSPATH=$i:${LOCALCLASSPATH}
done
echo ${max_level} ${queryOthers} ${access_token}
java -cp ${LOCALCLASSPATH} -Xmx384m org.gagia.demo.GetVideoInfo $*
