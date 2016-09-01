#!/bin/sh
#Author:nortorm
#Date:2016/09/01
#Function:install_maven.sh

. /etc/init.d/functions



function installMaven(){
	mavenSourceUrl=http://mirror.rise.ph/apache/maven/maven-3/3.3.9/source/apache-maven-3.3.9-src.tar.gz
	cd /tmp
	mavenTgzName=`basename ${mavenSourceUrl}`

	test -f ${mavenTgzName} && rm -rf ${mavenTgzName}
}


