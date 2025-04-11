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
server-id = 1
log_bin = /var/log/mysql/mysql-bin.log
binlog_do_db = testdb
bind-address = 0.0.0.0
EOL

# Redémarrer MySQL pour appliquer les changements
sudo systemctl restart mysql

# Configurer la base de données et l'utilisateur de réplication
sudo mysql -e "CREATE DATABASE testdb;"
sudo mysql -e "CREATE USER 'replica'@'192.168.56.21' IDENTIFIED BY 'replica_password';"
sudo mysql -e "GRANT REPLICATION SLAVE ON *.* TO 'replica'@'192.168.56.21';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Créer une table pour stocker les données
sudo mysql -e "USE testdb; CREATE TABLE data (id INT AUTO_INCREMENT PRIMARY KEY, value VARCHAR(255) NOT NULL);"

# Afficher les informations de réplication
echo "Informations de réplication pour db-slave :"
sudo mysql -e "SHOW MASTER STATUS;"