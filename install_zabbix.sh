#!/bin/sh
#Author:nortorm
#Date:2016/08/30
#Function:install_zabbix.sh

. /etc/rc.d/init.d/functions

function InstallZabbix(){
    yum -y install curl curl-devel net-snmp net-snmp-devel perl-DBI gcc
    groupadd zabbix
    useradd -g zabbix -m zabbix  -s /sbin/nologin
    zabbixSourceUrl=https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/3.0.4/zabbix-3.0.4.tar.gz/download
    zabbixTgzName=`echo $zabbixSourceUrl |cut -f 9 -d "/"`
    cd /tmp
    test -f ${zabbixTgzName} && rm -rf ${zabbixTgzName}
    wget --no-check-certificate ${zabbixSourceUrl} -O ${zabbixTgzName}
    zabbixSrcDir=${zabbixTgzName%.*.*}
    test -d ${zabbixSrcDir} && rm -rf ${zabbixSrcDir}
    tar -zxvf ${zabbixTgzName} -C /usr/local/src
    cd /usr/local/src/${zabbixSrcDir}
    ./configure --prefix=/usr/local/zabbix-server --enable-server --enable-agent --enable-proxy \
    --enable-java --with-mysql --enable-ipv6 --with-net-snmp --with-libcurl --with-libxml2 
    make
    make install  
}

InstallZabbix 2>&1 | tee -a $0_exec.log