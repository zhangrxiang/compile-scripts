#!/bin/sh
#Author:nortorm
#Date:2016/08/30
#Function:install_zookeeper.sh

. /etc/rc.d/init.d/functions

function InstallZookeeper(){
    zookeeperSource=http://mirror.rise.ph/apache/zookeeper/zookeeper-3.4.8/zookeeper-3.4.8.tar.gz
    cd /tmp
    zookeeperBaseFile=`basename ${zookeeperSource}`
    #zookeeperBaseFile=`basename ${zookeeperSource} .tar.gz`
    zookeeperBaseDir=${zookeeperBaseFile%.*.*}
    test -f ${zookeeperBaseFile} && rm -rf ${zookeeperBaseFile}
    wget ${zookeeperSource}
    test -d /usr/local/${zookeeperBaseDir} && mv /usr/local/${zookeeperBaseDir} /usr/local/${zookeeperBaseDir}_bak
    tar -zxvf ${zookeeperBaseFile} -C /usr/local/
    mv /usr/local/${zookeeperBaseDir} /usr/local/zookeeper
    cp /usr/local/zookeeper/conf/zoo_sample.cfg /usr/local/zookeeper/conf/zoo.cfg
}

InstallZookeeper