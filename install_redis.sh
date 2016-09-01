#!/bin/sh
#Author:nortorm
#Date:2016/08/30
#Function:install_redis.sh

. /etc/init.d/functions

function InstallTools(){
    yum install -y expect gcc gcc-c++ cmake make tcl
}

function InstallRedis(){
    redisSource=http://download.redis.io/releases/redis-3.2.3.tar.gz
    cd /tmp
    redisBaseFile=`basename ${redisSource}`
    test -f ${redisBaseFile} && rm -rf ${redisBaseFile}
    wget ${redisSource}
    tar -zxvf ${redisBaseFile} -C /usr/local/src
    redisSrcDir=${redisBaseFile%.*.*}
    cd /usr/local/src/${redisSrcDir}
    make
    test -d /usr/local/redis ||mkdir /usr/local/redis 
    make PREFIX=/usr/local/redis install 
cat >> /etc/profile <<EOF
export PATH=\$PATH:/usr/local/redis/bin
EOF
}

function ConfigRedis(){
    /usr/bin/expect <<\EOF
    
    #set redis version
    set redisVer "redis-3.2.3"
    
    spawn sh /usr/local/src/${redisVer}/utils/install_server.sh
    expect "6379]"
    send "6379\r"
    expect "/etc/redis/6379.conf]" 
    send "/usr/local/redis/conf/6379.conf\r"
    expect "/var/log/redis_6379.log]" 
    send "/usr/local/redis/log/redis_6379.log\r"
    expect "/var/lib/redis/6379]" 
    send "/usr/local/redis/data/6379\r"
    expect "/usr/local/redis/bin/redis-server]" 
    send "/usr/local/redis/bin/redis-server\r"
    expect "Ctrl-C to abort."
    send " \r"
    expect eof 
EOF
    exit 0 
}

function Main(){
    InstallTools
    InstallRedis
    ConfigRedis
}

Main 2>&1 | tee -a /tmp/$0_exec.log