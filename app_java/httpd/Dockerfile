FROM httpd:2.4.71

LABEL author="admin_stagiaire"
LABEL created_at="2026-11-25"
LABEL app="app-java"
LABEL app.tiers="httpd"

# copier le fichier de configuration custom dans l'image
COPY ./httpd.conf /usr/local/apache2/conf

# créer un dossier /usr/local/apache2/conf/sites
RUN mkdir /usr/local/apache2/conf/sites

# exposition: rien d'autre qu'une information utilasable par les utilisateurs de cette image
# si on veut un apache qui écoute 443 il faut l'expliquer dans la conf apache !!!
EXPOSE 80 443

###### par défaut notre image perso, utilise les entrypoint et cmd de l'image FROM
###### mais pour faire un exemple on va remplacer le CMD ici

# on lance toujours un démon en avant-plan dans un conteneur !
CMD ["httpd", "-D", "FOREGROUND"]


### si ENTRYPOINT et CMD la commande complète est ENTRYPOINT + CMD
# ENTRYPOINT [ "httpd" ]
# CMD ["-D", "FOREGROUND"]

