#!/bin/sh
#Author:Nortorm
#Date:2016/08/29
#Function:install_jdk_tomcat.sh
 
#source function
. /etc/init.d/functions
  
#set jdk and tomcat source url
jdkTgzVer=http://download.oracle.com/otn-pub/java/jdk/8u102-b14/jdk-8u102-linux-x64.tar.gz
tomcatTgzVer=http://mirror.rise.ph/apache/tomcat/tomcat-8/v8.5.4/bin/apache-tomcat-8.5.4.tar.gz
 
function err_echo(){
    echo -e "\e[91m[Error]: $1 \e[0m"
    exit 1
}
 
function info_echo(){
    echo -e "\e[92m[Info]: $1 \e[0m"
}
 
function warn_echo(){
    echo -e "\e[93m[Warning]: $1 \e[0m"
}
 
function check_exit(){
    if [ $? -ne 0 ]; then
        err_echo "$1"
        exit 1
    fi
}
 
#download jdk and tomcat tgz file
function Download(){
    #set software download dir
    softwareTmpDir=/tmp
    #test -d ${softwareTmpDir} && rm -rf ${softwareTmpDir}
    #mkdir ${softwareTmpDir}  
    info_echo "begin download jdk and tomcat tar.gz ..."
    cd ${softwareTmpDir}
    jdkBaseFile=`basename ${jdkTgzVer}`
    tomcatBaseFile=`basename ${tomcatTgzVer}`
    test -f ${jdkBaseFile} && rm -rf ${jdkBaseFile}
    test -f ${tomcatBaseFile} && rm -rf ${tomcatBaseFile}
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" ${jdkTgzVer}
    wget ${tomcatTgzVer}
}
 
#begin install jdk
function InstallJdk(){
    tar -zxvf ${jdkBaseFile} -C /usr/local/
    jdkExtractDir=`find /usr/local/  -maxdepth 1  -iname jdk*`
    jdkInstallDir=/usr/local/java
    mv ${jdkExtractDir} ${jdkInstallDir}
    #set jdk path
cat >> /etc/profile <<EOF 
#Set environment variable
export JAVA_HOME=${jdkInstallDir}
export CLASSPATH=.:\$JAVA_HOME/jre/lib/rt.jar:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
    source /etc/profile
    info_echo "JDK install success!"
}
 
#begin install tomcat
function InstallTomcat(){
    tar -zxvf ${tomcatBaseFile} -C /usr/local/
    tomcatExtractDir=`find /usr/local/  -maxdepth 1  -iname *tomcat*`
    tomcatInstallDir=/usr/local/tomcat
    mv ${tomcatExtractDir} ${tomcatInstallDir}
    
cat >> /etc/profile <<EOF 
#set tomcat path
export TOMCAT_HOME=${tomcatInstallDir}
export CATALINA_HOME=${tomcatInstallDir}
EOF
   
    source /etc/profile
    info_echo "Tomact install success!"
}
 
function Main(){
    Download
    check_exit "jdk or tomcat download failed, break process running！"
    InstallJdk
    check_exit "jdk install failed, exit！"
    InstallTomcat
    check_exit "tomcat install failed, exit！"
}
 
Main 2>&1 | tee -a /tmp/$0_exec.log