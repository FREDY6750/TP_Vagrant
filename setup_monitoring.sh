#!/bin/bash

# Mise à jour du système
sudo apt-get update -y

# -------------------------------------------------------------------
# Installation de Grafana
# -------------------------------------------------------------------

# Ajout du dépôt Grafana
sudo apt-get install -y software-properties-common gnupg
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main" -y
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

# Installation de Grafana
sudo apt-get update -y
sudo apt-get install -y grafana

# -------------------------------------------------------------------
# Installation de Prometheus
# -------------------------------------------------------------------

# Téléchargement et déploiement de Prometheus
PROM_VERSION="2.30.3"
PROM_TAR="prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
PROM_DIR="prometheus-${PROM_VERSION}.linux-amd64"

wget "https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/${PROM_TAR}"
tar xvfz "${PROM_TAR}"
sudo mv "${PROM_DIR}" /opt/prometheus

# Configuration des permissions
sudo useradd --no-create-home --shell /bin/false prometheus || true
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /opt/prometheus /var/lib/prometheus /etc/prometheus

# Copie des fichiers
sudo cp /opt/prometheus/prometheus /usr/local/bin/
sudo cp /opt/prometheus/promtool /usr/local/bin/
sudo cp -r /opt/prometheus/consoles /etc/prometheus/
sudo cp -r /opt/prometheus/console_libraries /etc/prometheus/

# Configuration YAML de base
sudo tee /etc/prometheus/prometheus.yml > /dev/null <<EOL
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['localhost:9090']
EOL

# Service systemd pour Prometheus
sudo tee /etc/systemd/system/prometheus.service > /dev/null <<EOL
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
ExecStart=/usr/local/bin/prometheus \\
  --config.file=/etc/prometheus/prometheus.yml \\
  --storage.tsdb.path=/var/lib/prometheus \\
  --web.console.templates=/etc/prometheus/consoles \\
  --web.console.libraries=/etc/prometheus/console_libraries
ExecReload=/bin/kill -HUP \$MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# -------------------------------------------------------------------
# Démarrage des services
# -------------------------------------------------------------------

# Rechargement des services systemd
sudo systemctl daemon-reload

# Activation et démarrage de Prometheus
sudo systemctl enable prometheus
sudo systemctl start prometheus

# Activation et démarrage de Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

# Nettoyage
rm -rf "${PROM_TAR}" "${PROM_DIR}"

# Vérification finale
echo "Vérification des services :"
sudo systemctl status prometheus grafana-server --no-pager