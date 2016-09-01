#!/bin/sh
:<<!
@Author:Notorm
@Date:2016/07/08
@Explanation:install_mysql.sh
!

. /etc/init.d/functions

function MysqlInstall(){
	#add mysql user
	groupadd mysql
	useradd -g mysql -m mysql -s /sbin/nologin 
	
	#mysql source address
	local mysqlSource=http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.31.tar.gz
	local mysqlBasename=$(basename ${mysqlSource})
	local mysqlBase=${mysqlBasename%.*.*}
	#install tools
	yum -y install cmake wget make gcc-c++ bison-devel ncurses-devel
	
	#down mysql package and install ...
	cd /tmp
	test -f ${mysqlBasename} && rm -rf ${mysqlBasename}
	wget ${mysqlSource}
	tar zxvf ${mysqlBasename} -C /usr/local/src/
	cd /usr/local/src/${mysqlBase}
	#begin make file
	cmake \
	-DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
	-DMYSQL_DATADIR=/usr/local/mysql/data \
	-DSYSCONFDIR=/etc \
	-DWITH_MYISAM_STORAGE_ENGINE=1 \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_MEMORY_STORAGE_ENGINE=1 \
	-DWITH_READLINE=1 \
	-DMYSQL_UNIX_ADDR=/var/lib/mysql/mysql.sock \
	-DMYSQL_TCP_PORT=3306 \
	-DENABLED_LOCAL_INFILE=1 \
	-DWITH_PARTITION_STORAGE_ENGINE=1 \
	-DEXTRA_CHARSETS=all \
	-DDEFAULT_CHARSET=utf8 \
	-DDEFAULT_COLLATION=utf8_general_ci
	make && make install
	#init mysql
	chown -R mysql:mysql /usr/local/mysql
	/usr/local/mysql/scripts/mysql_install_db --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data --user=mysql --ldata=/var/lib/mysql
	 echo -e "export PATH=/usr/local/mysql/bin:\$PATH" >> /etc/profile
	 source /etc/profile
	 cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql 
	 chkconfig mysql on
	 service mysql start 
}
MysqlInstall 2>&1 | tee -a /tmp/$0_exec.log