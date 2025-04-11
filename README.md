# TP Infrastructure Virtuelle avec Vagrant

Ce projet consiste à déployer une infrastructure virtuelle comprenant :
- Un **Load Balancer** qui équilibre le trafic vers web1 et web2.
- Deux serveurs web (web1 et web2) (Apache/PHP)
- monitoring (Supervision) : Installe Prometheus et Grafana pour surveiller le 
cluster. 
- une machime **cliente** (Client) : Utilisé pour tester la connectivité. 
- une base de donnée db_master (Base de Données Maître) : Contient les données et envoie les mises à 
jour à db-slave. 
- une base de donnée db_slave (Base de Données Esclave) : Reçoit les mises à jour de db-master. 

## Prérequis
- Vagrant 
- VirtualBox / installation](https://www.virtualbox.org/))
- Git (`sudo apt install git`)


# 1. Configuration de l'infrastructure

### Fichiers clés
- [`Vagrantfile`](./Vagrantfile) : Définit les machines virtuelles et leur provisioning.
- [`scripts/`](./scripts/) : Contient les scripts Bash pour configurer chaque service.

### Démarrer l'infrastructure
```sh
vagrant up
