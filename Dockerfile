FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt upgrade -y && \
    apt install -y fontconfig unzip openjdk-11-jdk

RUN mkdir -p /opt/fluig_driver /usr/share/java

COPY setup/drivers/mysql-connector-j-9.3.0.jar /opt/fluig_driver/mysql-connector-j-9.3.0.jar
COPY setup/drivers/mysql-connector-j-9.3.0.jar /usr/share/java/mysql-connector-j-9.3.0.jar
COPY setup/configuration/domain.xml /opt/setup/configuration/domain.xml
COPY setup/configuration/host.xml /opt/setup/configuration/host.xml
COPY setup/zip/FLUIG-1.8.2-250701-LINUX64.ZIP /opt/
COPY setup/install.conf /opt/install.conf
COPY entrypoint.sh /entrypoint.sh

WORKDIR /opt

RUN chmod +x /entrypoint.sh

EXPOSE 8080 7777 8888 8000 8983 9990

ENTRYPOINT ["/entrypoint.sh"]