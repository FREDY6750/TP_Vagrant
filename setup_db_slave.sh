#!/bin/bash

# Mettre à jour le système
sudo apt-get update

# Installer MySQL
sudo apt-get install -y mysql-server

# Démarrer et activer MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Configurer MySQL pour la réplication
sudo tee /etc/mysql/mysql.conf.d/mysqld.cnf > /dev/null <<EOL
[mysqld]
server-id = 2
relay-log = /var/log/mysql/mysql-relay-bin.log
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = testdb
EOL

# Redémarrer MySQL pour appliquer les changements
sudo systemctl restart mysql

# Configurer la réplication vers db-master
# Remplace MASTER_LOG_FILE et MASTER_LOG_POS par les valeurs obtenues sur db-master
sudo mysql -e "CHANGE MASTER TO
MASTER_HOST='192.168.56.20',
MASTER_USER='replica',
MASTER_PASSWORD='replica_password',
MASTER_LOG_FILE='mysql-bin.000001',  -- Remplace par la valeur de `File` sur db-master
MASTER_LOG_POS=1167;                  -- Remplace par la valeur de `Position` sur db-master

START SLAVE;"

# Vérifier l'état de la réplication
echo "État de la réplication :"
sudo mysql -e "SHOW SLAVE STATUS\G"