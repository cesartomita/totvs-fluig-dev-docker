#!/bin/bash

set -e

echo "[INFO] Extraindo instalador do Fluig..."
unzip -q /opt/FLUIG-1.8.2-250701-LINUX64.ZIP -d /opt/fluig_installer

cd /opt/fluig_installer

echo "[INFO] Garantindo permissões de execução..."
chmod +x ./jdk-64/bin/java

echo "[INFO] Iniciando instalação do Fluig..."
./jdk-64/bin/java -cp fluig-installer.jar com.fluig.install.ExecuteInstall /opt/install.conf

echo "[INFO] Copiando driver JDBC para o runtime do Fluig..."
mkdir -p /opt/fluig/appserver/lib/
cp /opt/fluig_driver/mysql-connector-j-9.3.0.jar /opt/fluig/appserver/lib/

echo "[INFO] Copiando driver JDBC para o caminho esperado pelo instalador..."
mkdir -p /usr/share/java
cp /opt/fluig_driver/mysql-connector-j-9.3.0.jar /usr/share/java/mysql-connector-j-9.3.0.jar

echo "[INFO] Substitui os arquivos de configuração personalizadas..."
cp /opt/setup/configuration/domain.xml /opt/fluig/appserver/domain/configuration/domain.xml
cp /opt/setup/configuration/host.xml /opt/fluig/appserver/domain/configuration/host.xml

echo "[INFO] Criando pasta fluig-volume..."
mkdir -p /opt/fluig-volume

echo "[INFO] Iniciando serviço do Fluig Indexer..."
service fluig_RealTime start

echo "[INFO] Iniciando serviço do Fluig RealTime..."
service fluig_Indexer start

echo "[INFO] Iniciando serviço do Fluig..."
service fluig start

echo "[INFO] Mostando log do Fluig..."
tail -f /opt/fluig/appserver/domain/servers/fluig1/log/server.log
