# Итоговый проект: Al Bo

## Тема: настройка пары серверов или восстанволение

#############################################################

- Количество серверов: 3 шт.

- Используемая ОС: CentOS 8 (предварительно обновите ОС) 

- Используемая сеть: 10.0.0.0/24

- Основной сервер: 10.0.0.1/24

- Сервер-реплика: 10.0.0.2/24

- Сервер-замена: 10.0.0.3/24

#############################################################

С каждого сервера проверяем SSH подключение: ssh -T username@ip -p 22

Устанавливаем и настраиваем GIT: sudo yum -y install git

Скачиваем репозиторий в /tmp: git clone https://github.com/aboltykhov/albo.git

#############################################################

- Каталог albo

#############################################################

- 1-server-slave				#Подкаталог: сервер-реплика

- 2-server-master				#Подкаталог: основной сервер

- sql					      		#Подкаталог: sql-запросы 

#############################################################

Установка:

Заходим в подкаталог 1-server-slave

- ./0-selinux-off.sh				#Отключаем SELinux

Перезагружаемся,

Нахоидим каталог 1-server-slave и запускаем скрипт ./1-docker-nginx-setup.sh

Установка будет проходить в полуавтоматическом режиме по нумерации скриптов из каталога,

Во время установки потребуется настроить компонент проверки пароля MySQL, 

Установите пароль User1589$

#############################################################

Описание скриптов из каталога albo/1-server-slave:

- 1-docker-nginx-setup.sh		#Установка Docker и образа nginx

- 2-new-sql-server-slave.sh		#Установка СУБД MySQL c настриваемой репликацией master/slave

- 3-node-exporter-client-setup.sh	#Установка Node Exporter для сбора метрик сервера-реплики

- 4-docker-elk-setup.sh			#Установка образа Docker (Elasticsearch, Logstash, Kibana)

#############################################################
#############################################################
#############################################################

Установка:

Заходим в подкаталог 2-server-master

- ./0-selinux-off.sh				#Отключаем SELinux

Перезагружаемся,

Находим каталог 2-server-master и запускаем скрипт  ./1-httpd-php-wp-setup.sh

Установка будет проходить в полуавтоматическом режиме по нумерации скриптов из каталога,

Во время установки потребуется настроить компонент проверки пароля MySQL, 

Установите пароль User1589$

#############################################################

Описание скриптов из каталога albo/2-server-master:

- 1-httpd-php-wp-setup.sh		#Установка веб-сервера на базе LAMP, CMS WordPress

- 2-new-sql-server-master.sh	#СУБД MySQL c настриваемой репликацией master/slave

- 3-grafana-setup.sh			#Веб-приложение для визуализации мониторинга

- 4-prometheus.sh				#Установка Prometheus системы мониторинга 

- 5-alertm-setup.sh			#Установка Alertmanager для отправки уведоблений

- 6-node-exporter-setup.sh		#Установка Node Exporter для сбора метрик

- 7-targets-node-setup.sh		#Добавление хостов для мониторинга

#############################################################

3 сервер в проекте как "сервер бекапов" или "замена" основного сервера

#############################################################

Готово

#############################################################
