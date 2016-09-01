#!/bin/sh
#Author:nortorm
#Date:2016/09/01
#Function:install_nginx.sh

. /etc/init.d/functions

#set need install software source (must is tar.gz format)
pcre_source=http://ftp.cs.stanford.edu/pub/exim/pcre/pcre-8.36.tar.gz
zlib_source=http://zlib.net/zlib-1.2.8.tar.gz
openssl_source=http://mirror.metrocast.net/openssl/source/old/1.0.2/openssl-1.0.2d.tar.gz
nginx_source=http://nginx.org/download/nginx-1.8.1.tar.gz

#set var
nginx_user=nginx
nginx_group=nginx
software_dir=/tmp
software_install_dir=/usr/local
source_dir=${software_install_dir}/src

#test dir or mkdir dir
#test -d ${software_dir} ||mkdir -p ${software_dir}
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

function DevelopmentTools() {
    #install Development tools
    info_echo "start install need compilation tool..."
    yum -y install gcc  gcc-c++ automake autoconf libtool make
    info_echo "installation  complete!"
    #useradd nginx run user
    info_echo "create an account for nginx:"
    groupadd ${nginx_user}
    useradd -g ${nginx_group} -m ${nginx_user}
    info_echo "useradd ${nginx_user} user  complete!"
}

#pcre
function Pcre() {
    info_echo "Install pcre package..."
    cd ${software_dir}
    pcre_file_tar_gz=`basename ${pcre_source}`
    test -f ${pcre_file_tar_gz} && rm -rf ${pcre_file_tar_gz}
    wget  ${pcre_source}
    pcre_file=${pcre_file_tar_gz%.*.*}
    test -d ${source_dir}/${pcre_file} && rm -rf ${source_dir}/${pcre_file}
    tar -zxvf ${pcre_file_tar_gz} -C ${source_dir}
    cd  ${source_dir}/${pcre_file}
    ./configure
    make
    make install
    check_exit "pcre install failed!"
    info_echo "Install pcre package complete!"
}

#zlib
function Zlib() {
    info_echo "Install zlib package..."
    cd ${software_dir}
    zlib_file_tar_gz=`basename ${zlib_source}`
    test -f ${zlib_file_tar_gz} && rm -rf ${zlib_file_tar_gz}
    wget  ${zlib_source}
    zlib_file=${zlib_file_tar_gz%.*.*}
    test -d ${source_dir}/${zlib_file} && rm -rf ${source_dir}/${zlib_file}
    tar -zxvf ${zlib_file_tar_gz} -C ${source_dir}
    cd ${source_dir}/${zlib_file}
    ./configure
    make
    make install
    check_exit "zlib install failed!"
    info_echo "Install zlib package complete!"
}

#openssl
function Openssl() {
    info_echo "Install openssl package..."
    cd ${software_dir}
    openssl_file_tar_gz=`basename ${openssl_source}`
    test -f ${openssl_file_tar_gz} && rm -rf ${openssl_file_tar_gz}
    wget  ${openssl_source}
    openssl_file=${openssl_file_tar_gz%.*.*}
    test -d ${source_dir}/${openssl_file} && rm -rf ${source_dir}/${openssl_file}
    tar -zxvf ${openssl_file_tar_gz} -C ${source_dir}
    cd ${source_dir}/${openssl_file}
    check_exit "openssl install failed!"
    info_echo "Install openssl package complete!"
}

#nginx
function Nginx() {
    info_echo "Install nginx package..."
    cd ${software_dir}
    nginx_file_tar_gz=`basename ${nginx_source}`
    test -f ${nginx_file_tar_gz} && rm -rf ${nginx_file_tar_gz}
    wget  ${nginx_source}
    nginx_file=${nginx_file_tar_gz%.*.*}
    test -d ${source_dir}/${nginx_file} && rm -rf ${source_dir}/${nginx_file}
    tar -zxvf ${nginx_file_tar_gz} -C ${source_dir}
    cd ${source_dir}/${nginx_file}
    ./configure  --prefix=${software_install_dir}/nginx \
    --user=nginx \
    --group=nginx \
    --sbin-path=${software_install_dir}/nginx/sbin/nginx \
    --conf-path=${software_install_dir}/nginx/conf/nginx.conf \
    --pid-path=${software_install_dir}/nginx/logs/nginx.pid \
    --lock-path=${software_install_dir}/nginx/logs/nginx.lock \
    --with-http_ssl_module \
    --with-http_stub_status_module \
    --with-pcre=${source_dir}/${pcre_file} \
    --with-zlib=${source_dir}/${zlib_file} \
    --with-openssl=${source_dir}/${openssl_file}
    make
    make install
    check_exit "nginx install failed!"
    info_echo "Install nginx package complete!"
}

#main
function Main() {
    info_echo "Start software Install..."
    DevelopmentTools
    Pcre
    Zlib
    Openssl
    Nginx
    info_echo "Install software finished!"
}

Main 2>&1 | tee -a /tmp/$0_exec.log