## nous allons utiliser une image debian12
## REM: pour faire une image de distro ==> FROM scratch
FROM debian:bookworm-slim

## documenter l'image
LABEL author="matt"
LABEL created="2026-11-25"
LABEL app="app-java"
LABEL stack.tiers="tomcat"

# PARAM=dflt valeur par défaut qui sera écrasée par docker build --build-arg=10 ou dans le docker compose
ARG TOMCAT_VERSION_MAJOR=9
ARG TOMCAT_VERSION_FULL

## installer java (apt-get)
## et nettoyer le dépôt apt-get après
## ajouter un dossier /opt/tomcat
## injecter le fichier https://downloads.apache.org/tomcat/tomcat-9/v9.0.124/bin/apache-tomcat-9.0.124.tar.gz dans ce dossier
# REMPLACER ADD par RUN curl qui retourne un flux ( | ...)
# ADD https://downloads.apache.org/tomcat/tomcat-9/v9.0.124/bin/apache-tomcat-9.0.124.tar.gz /opt/tomcat
## décomprésser dans ce dossier sans dossier intermédiaire 
## et supprimer l'archive
# RUN rm /opt/tomcat/apache-tomcat-9.0.124.tar.gz
RUN apt-get update && apt-get install -y openjdk-17-jre-headless curl && \
    rm -rf /var/lib/apt/cache/lists/* && \
    mkdir /opt/tomcat && \
    curl https://downloads.apache.org/tomcat/tomcat-${TOMCAT_VERSION_MAJOR}/v${TOMCAT_VERSION_FULL}/bin/apache-tomcat-${TOMCAT_VERSION_FULL}.tar.gz | \
    tar -xzv -C /opt/tomcat --strip-components=1

## ajouter un utilisateur tomcat avec le dossier /opt/tomcat comme home et le groupe propriétaire
RUN useradd -M -d /opt/tomcat -U tomcat

## déterminer le dossier home du conteneur : pwd: /opt/tomcat/webapps
WORKDIR /opt/tomcat/webapps

## télécharger l'application sample https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war dans le dossier home 
ADD https://tomcat.apache.org/tomcat-10.1-doc/appdev/sample/sample.war .

## spécifier le propriétaire et groupe à tomcat pour le dossier /opt/tomcat 
RUN chown -R tomcat:tomcat /opt/tomcat

## changer l'utilisateur à tomcat
USER tomcat

# j'ajoute une ou plusieurs variables d'environnement utilisables dans le conteneur (docker run)
ENV USER=tomcat

## persister le dossier home pour accéder ou sauvegarder les apps
## crée des volumes "anonymes" exploitables avec volumes_from dans un conteneur sidecar
## exemple: docker run -it --rm --volumes-from app-java-tomcat alpine:3.24.4
VOLUME [ "/opt/tomcat/webapps" ]

## pour communiquer avec httpd avec le port par défaut de tomcat  ???
EXPOSE 8080

## exécuter de manière dynamique (avec substitution) le binaire en foreground catalina.sh vs startup.sh ???
## et ajouter la sous commande pour lancer en one shot run ou start ???
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]

# quand le docker run est lancé
# le CMD ci dessus est lancé
# 1. on attent <start-period>
# 2. le CMD du HEALTHCHECK est lancé
# 3.1. le // termine avant le <timeout> avec le code 0 => SUCESS => (healthy) dans le STATUS du docker ps
# 3.2. le // termine avant le <timeout> avec un code non-zero => ERROR (unhealthy)
# 3.3. le // ne termine pas avant le <timeout>
# si 3.2 ou 3.3 => on reessaye <retries> fois
# si 3.2 ou 3.3 => avant de réessayer on attend <interval>s
## REM: le CMD doit être écrit sans JSON
HEALTHCHECK \
            --start-period=3s \
            --timeout=5s \
            --retries=3 \
            --interval=3s \
            CMD grep "Server startup" /opt/tomcat/logs/catalina.*.log

