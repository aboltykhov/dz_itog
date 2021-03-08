#!/bin/bash
#Восстановление МАСТЕРА
#1)
#НЕОБЯЗАТЕЛЬНО
#на рабочем сервере, подготовка, чтобы копировать бекап без ввода пароля adminroot,
#требуется установка утилиты sshpass, утилита не входит в комплект, поэтому добавим дополнительный пакет
#cd /tmp
#yum -y install wget
#wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
#rpm -ivh epel-release-latest-8.noarch.rpm
#yum -y install sshpass


#2)
#на новом МАСТЕРЕ устанавливаем mysql-server
cd /tmp
yum update
rpm -Uvh https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm
yum -y install mysql-server && systemctl enable mysqld && systemctl start mysqld && systemctl status mysqld

#настраиваем mysql-server, создаем пароль для root, например - User1589$
sudo mysql_secure_installation


#3)
#на МАСТЕРЕ настраиваем репликацию 
#сделаем копию и отредактируем файл конфигра
cp /etc/my.cnf.d/mysql-server.cnf /etc/my.cnf.d/mysql-server.cnf.bak
rm -rf /etc/my.cnf.d/mysql-server.cnf
#Добавить строки, ip нового мастера
cat <<EOF > /etc/my.cnf.d/mysql-server.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
log-error=/var/log/mysql/mysqld.log
pid-file=/run/mysqld/mysqld.pid
bind-address=10.0.0.1
server-id=1
EOF

#Перезапустить службу
systemctl restart mysqld


#4)
#НЕОБЯЗАТЕЛЬНО
#копируем бекап на новый МАСТЕР
#требуется знать пользователя и адрес сервера с бекапом
#ключ scp -r копирует папку целиком 
#вводим пароль пользователя adminroot
#scp -r adminroot@10.0.0.3:/tmp/backupDB-*.sql /tmp/
#sshpass -p Candyshop919 scp -r adminroot@10.0.0.1:/tmp/backupDB-*.sql /tmp/

#на новом МАСТЕРЕ разворачиваем бекап
#sudo mysql -u root --password=User1589$ < /tmp/backupDB-*.sql


#5)
#на МАСТЕРЕ настраиваем репликацию
#ПРИ НЕОБХОДИМОСТИ меняет IP-адрес для слейва
#ключ -e "TEXT" означатет выполнить команды в консоли mysql и выйти
#но удобнее импортировать из файла *.sql
sudo mysql -u root --password=User1589$ < replication.sql

#Создать тестовую БД, пользователя и предоставить пользователю права на созданную БД
sudo mysql -u root --password=User1589$ < db001.sql

#Создать БД, пользователя для управления базой CMS WordPress и применить изменения
sudo mysql -u root --password=User1589$ -e < wp-db-user.sql

#Создать таблицу от имени пользователя wpuser
sudo mysql -u wpuser --password=WP1password$ < wp-albo.sql

#ПРИМЕРЫ
#Grant user permissions to all tables in my_database from localhost --
#GRANT ALL ON my_database.* TO 'user'@'localhost';

#Grant user permissions to my_table in my_database from localhost --
#GRANT ALL ON my_database.my_table TO 'user'@'localhost';

#Grant user permissions to all tables and databases from all hosts --
#GRANT ALL ON *.* TO 'user'@'*';

#FLUSH PRIVILEGES;
#################################################################
#Удалить пользователя
#SELECT user,host FROM mysql.user;
#REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'wpuser'@'localhost';
#DROP USER 'wpuser'@'localhost';
#SHOW GRANTS FOR 'wpuser'@'localhost';
#SELECT user,host FROM mysql.user;
#################################################################
