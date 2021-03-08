#!/bin/bash
#Предварительно скрипт проверяет возможность своей работы от пользователя
if [[ $UID -ne 0 ]]; then
echo "Скрипт требуется запустить в привилегированном режиме sudo или от пользователя root"
exit 1; fi

#Создать файл ssh ключей для github.com в автозапуске
rm -rf /etc/ssh/ssh_config.d/github.com.conf
cat <<EOF > /etc/ssh/ssh_config.d/github.com.conf
Host github.com
    HostName github.com
    IdentityFile /etc/ssh/ssh_host_rsa_key
EOF

#Права на файл ключей ssh
chmod 600 /etc/ssh/ssh_config.d/github.com.conf
echo && echo && ssh -T git@github.com

#Устанавка и запуск апача
#Ключ -y отвечает Да на установку
yum -y install httpd && sudo systemctl enable httpd && sudo systemctl start httpd

#Установить git и добавляем репозиторий ВЕБ-сервера
#Подготовка git репозитория
yum -y install git
git config --global user.name "Alexey Boltykhov"
git config --global user.email aboltykhov@mail.ru
git config --global core.editor vi
git config pull.rebase false
cd /tmp/ && mkdir dz_web_server && cd dz_web_server

#Скачать бекап веб-сервера из репозитория,
#Если не скачивает, проверить название ветки, в моем случае main
git init && git remote add origin git@github.com:aboltykhov/dz_web_server.git
git pull origin main && ls -lh && ls -lh /tmp/

#Создаем папки
rm -rf  /var/www/8080 /var/www/8081 /var/www/8082
mkdir /var/www/8080 /var/www/8081 /var/www/8082

#Разворачиваем бекап
#Ключ -a копировать содежимое с атрибутами
cp -a /tmp/dz_web_server/web.bak/var/www/8080/* /var/www/8080/
cp -a /tmp/dz_web_server/web.bak/var/www/8081/* /var/www/8081/
cp -a /tmp/dz_web_server/web.bak/var/www/8082/* /var/www/8082/
cp -a /tmp/dz_web_server/web.bak/var/www/html/* /var/www/html/

cp -a /tmp/dz_web_server/web.bak/etc/httpd/conf.d/8080.conf /etc/httpd/conf.d/
cp -a /tmp/dz_web_server/web.bak/etc/httpd/conf.d/8081.conf /etc/httpd/conf.d/
cp -a /tmp/dz_web_server/web.bak/etc/httpd/conf.d/8082.conf /etc/httpd/conf.d/
rm -rf /etc/httpd/conf/httpd.conf
cp -a /tmp/dz_web_server/web.bak/etc/httpd/conf/httpd.* /etc/httpd/conf/

#Показать ip-адреса хоста
echo && hostname -I && echo 

#Установка пакетов php и php-mysqlnd
dnf -y install php php-mysqlnd php-gd

#Подготовка CMS WordPress 
cd /tmp/
wget http://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz
rsync -avP /tmp/wordpress/ /var/www/html
mkdir /var/www/html/wp-content/uploads
sudo chown -R apache:apache /var/www/html/*
cd /var/www/html/
cp wp-config-sample.php wp-config.php

#Перечитать конфигурацию и показать статус
systemctl restart httpd && systemctl status httpd

#Установить MySQL 
cd /tmp/dz_web_server/
./selinux-off.sh

