
#!/bin/sh
#Author:nortorm
#Date:2016/08/30
#Function:install_php.sh
. /etc/init.d/functions
  
function InstallPhp(){
    
    phpSourceUrl=https://github.com/php/php-src/archive/php-5.4.43.tar.gz

    #afresh refresh yum repolist
    yum -y install epel-release
    #yum clean all
    #yum makecache
    
    #install develop tools
    yum  -y install  ntp  lsof vim wget lrzsz  cmake make apr* autoconf automake bzip2 bzip2-devel curl curl-devel \
    gcc gcc-c++  e2fsprogs e2fsprogs-devel zlib*  openssl openssl-devel pcre pcre-devel gd gd-devel \
    kernel keyutils patch perl perl-DBI kernel-headers compat* mpfr cpp glibc libgomp libstdc++-devel ppl cloog-ppl \
    keyutils-libs-devel libcom_err-devel libsepol-devel libselinux-devel krb5-devel zlib-devel libXpm* freetype \
    freetype-devel libpng* libpng10 libpng10-devel libpng-devel php-common php-gd ncurses* ncurses-devel libtool* 
    
    yum -y install libtool-libs libxml2-devel patch glibc glibc-devel glib2 glib2-devel krb5 krb5-devel libevent libevent-devel \
    libidn libidn-devel nss_ldap openldap openldap-clients openldap-devel openldap-servers openssl openssl-devel \
    pspell-devel net-snmp* net-snmp-devel popt popt-devel tcl tcl-devel git bp2-devel libmcrypt  \
    libjpeg-devel curl curl-devel tcl* libxml2-devel gmp-devel libjpeg* libpng freetype libjpeg-devel libpng-devel \
    freetype-devel  libmcrypt libmcrypt-devel bzip2 bzip2-devel libevent-devel pcre pcre-devel zlib* openssl-devel lua* git tcl \
    tcl-devel openssl-devel openssl popt-devel popt  
    
    #install php
    cd /tmp
    phpTgzName=`basename ${phpSourceUrl}`
    test -f ${phpTgzName} && rm -rf ${phpTgzName}
    wget ${phpSourceUrl}
    phpSrcDir=${phpTgzName%.*.*}
    test -d /usr/local/src/${phpSrcDir} && rm -rf /usr/local/src/${phpSrcDir}
    tar -zxvf ${phpTgzName} -C /usr/local/src
    cd /usr/local/src/${phpSrcDir}
    ./configure --prefix=/usr/local/php --with-openssl --with-config-file-path=/usr/local/php/etc \
    --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --enable-fpm --with-mcrypt= \
    --with-libxml-dir=  --enable-mbstring --with-curl --with-gmp= --enable-soap --enable-inline-optimization \
    --with-bz2 --with-zlib --with-openssl --enable-sockets --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-pcntl \
    --enable-mbregex --with-mhash --enable-bcmath --enable-zip --with-pcre-regex --with-gd=/usr/local/libgd/ \
    --enable-gd-native-ttf --with-jpeg-dir --with-png-dir --with-freetype-dir
    make
    make install   
}
function ConfigPhp(){
    cp /usr/local/src/${phpSrcDir}/php.ini-development /usr/local/php/etc/php.ini
    cp /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
    echo "export PATH=\$PATH:/usr/local/php/bin:/usr/local/php/sbin" > /etc/profile.d/php.sh
    source /etc/profile.d/php.sh
}
function InstallHidef(){
    
    hidefSourceUrl=http://pecl.php.net/get/hidef-0.1.8.tgz
    
    cd /tmp
    hidefTgzName=`basename ${hidefTgzName}`
    test -f ${hidefTgzName} && rm -rf ${hidefTgzName}
    wget ${hidefSourceUrl}
    hidefSrcDir=${hidefTgzName%.*.*}
    test -d ${hidefSrcDir} && rm -rf ${hidefSrcDir}
    tar -zxvf ${hidefTgzName} -C /usr/local/src
    /usr/local/php/bin/phpize
    ./configure --enable-hidef --with-php-config=/usr/local/php/bin/php-config 
    make 
    make install
    sed -i '/extension=msql.so/aextension=hidef.so\nhidef.ini_path = \/usr\/local\/php\/etc\/' /usr/local/php/etc/php.ini
    touch /usr/local/php/etc/hidef.ini
}
function Main(){
    InstallPhp
    ConfigPhp
    InstallHidef   
}
Main 2>&1 | tee -a /tmp/$0_exec.log
