STOP SLAVE;
CHANGE MASTER TO MASTER_HOST='10.0.0.1', MASTER_USER='abrepl', MASTER_PASSWORD='User1589Rep$', MASTER_LOG_FILE='binlog.000002', MASTER_LOG_POS=1646, GET_MASTER_PUBLIC_KEY = 1; 
START SLAVE;
SELECT User, Host FROM mysql.user; 
SHOW SLAVE STATUS\G; 
SHOW DATABASES;
