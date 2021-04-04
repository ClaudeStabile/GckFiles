FROM debian:latest
MAINTAINER Claude Stabile <claude@free-solutions.ch>

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Required Dependencies
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --force-yes \
                systemd \
                systemd-sysv \
		ca-certificates \
		iptables \
		sudo \
		git \
		vim \
		haveged \
		ssl-cert \
		ghostscript \
		libtiff5-dev \
		libtiff-tools \
		nginx \
		net-tools \
		lynx \
		libpq-dev \
		php php-cli php-fpm php-pgsql php-sqlite3 php-odbc php-curl php-imap php-pear php-dev libmcrypt-dev wget curl openssh-server supervisor net-tools\
	&& apt-get clean \
	&& git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx 

RUN chown -R www-data:www-data /var/www/fusionpbx
RUN wget https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/debian/resources/nginx/fusionpbx -O /etc/nginx/sites-available/fusionpbx && ln -s /etc/nginx/sites-available/fusionpbx /etc/nginx/sites-enabled/fusionpbx \
	&& ln -s /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/nginx.key \
	&& ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/nginx.crt \
	&& rm /etc/nginx/sites-enabled/default
RUN wget -O - https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/debian/pre-install.sh | sh;
# Set Free-Solutions Docker password & copy config files & install config
RUN sed -i -e 's/random/FS_OS2610/g' /usr/src/fusionpbx-install.sh/debian/resources/config.sh
RUN sed -i -e '8iswitch_package_all=true'  /usr/src/fusionpbx-install.sh/debian/resources/config.sh 
#RUN cp /data/DISTRIBS/FreeSwitchConfig/install.sh /usr/src/fusionpbx-install.sh/debian/install.sh

#RUN mkdir /etc/FreeSwitchConfig
#Clone Github config repository
#RUN cd /etc/FreeSwitchConfig \
#	&& git clone https://github.com/ClaudeStabile/FreeSwitchConfig
#Prepare Postgresql & start it via init.d
ENV PSQL_PASSWORD="psqlpass"
RUN password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64) \
        && apt-get install -y --force-yes sudo postgresql \
        && apt-get clean
RUN /etc/init.d/postgresql start \
        && sleep 10 \
        && echo "psql -c \"CREATE DATABASE fusionpbx\";" | su - postgres \
        && echo "psql -c \"CREATE DATABASE freeswitch\";" | su - postgres \
        && echo "psql -c \"CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'\";" | su - postgres \
        && echo "psql -c \"CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'\";" | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx\";"  | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx\";" | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch\";" | su - postgres
# Install FusionPBX Package à decommenter
#RUN cd /usr/src/fusionpbx-install.sh/debian && rm install.sh
#RUN cd /usr/src/fusionpbx-install.sh/debian && wget https://github.com/ClaudeStabile/GckFiles/blob/main/install.sh 
#RUN cd /usr/src/fusionpbx-install.sh/debian && cat install.sh.1 > install.sh
RUN cd /usr/src/fusionpbx-install.sh/debian && ./install.sh
RUN sleep 10
RUN freeswitch &

# Install Free-Solutions Config files
#
#RUN cp /etc/FreeSwitchConfig/FreeSwitchConfig/vars.xml /etc/freeswitch/vars.xml
#RUN cp /etc/FreeSwitchConfig/FreeSwitchConfig/external.xml /etc/freeswitch/sip_profiles/external.xml
#RUN cp /etc/FreeSwitchConfig/FreeSwitchConfig/internal.xml /etc/freeswitch/sip_profiles/internal.xml
#RUN cp /etc/FreeSwitchConfig/FreeSwitchConfig/switch.conf.xml /etc/freeswitch/autoload_configs/switch.conf.xml
#RUN apt-get install -y freeswitch-meta-all 
#Set permissions for Freeswitch
RUN usermod -a -G freeswitch www-data \
	&& usermod -a -G www-data freeswitch \
	&& chown -R freeswitch:freeswitch /var/lib/freeswitch \
	&& chmod -R ug+rw /var/lib/freeswitch \
	&& find /var/lib/freeswitch -type d -exec chmod 2770 {} \; \
	&& chmod -R ug+rw /usr/share/freeswitch \
	&& find /usr/share/freeswitch -type d -exec chmod 2770 {} \; \
	&& chown -R freeswitch:freeswitch /etc/freeswitch \
	&& chmod -R ug+rw /etc/freeswitch \
	&& find /etc/freeswitch -type d -exec chmod 2770 {} \; \
	&& chown -R freeswitch:freeswitch /var/log/freeswitch \
	&& chmod -R ug+rw /var/log/freeswitch \
	&& find /var/log/freeswitch -type d -exec chmod 2770 {} \;


USER root
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY start-freeswitch.sh /usr/bin/start-freeswitch.sh
VOLUME ["/var/lib/postgresql", "/etc/freeswitch", "/var/lib/freeswitch", "/usr/share/freeswitch", "/var/www/fusionpbx"]
CMD /usr/bin/supervisord -n

#Prepare for fusionPBX console install







