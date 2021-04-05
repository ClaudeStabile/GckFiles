#!/bin/bash
#
# Install ssl certs from outside

#make sure the nginx ssl directory exists
mkdir -p /etc/nginx/ssl
export domain_name="fusionpbx.free-solutions.org"

#update nginx config
sed "s@ssl_certificate         /etc/ssl/certs/nginx.crt;@ssl_certificate /etc/dehydrated/certs/$domain_alias/fullchain.pem;@g" -i /etc/nginx/sites-available/fusionpbx
sed "s@ssl_certificate_key     /etc/ssl/private/nginx.key;@ssl_certificate_key /etc/dehydrated/certs/$domain_alias/privkey.pem;@g" -i /etc/nginx/sites-available/fusionpbx


        #make sure the freeswitch directory exists
        mkdir -p /etc/freeswitch/tls

        #make sure the freeswitch certificate directory is empty
        rm /etc/freeswitch/tls/*

        #combine the certs into all.pem
        cat /attachements/LETSENCRYPT/fullchain.pem > /etc/freeswitch/tls/all.pem
        cat /attachements/LETSENCRYPT/privkey.pem >> /etc/freeswitch/tls/all.pem
        #cat /attachements/LETSENCRYPT/chain.pem >> /etc/freeswitch/tls/all.pem

        #copy the certificates
        cp /attachements/LETSENCRYPT/cert.pem /etc/freeswitch/tls
        cp /attachements/LETSENCRYPT/chain.pem /etc/freeswitch/tls
        cp /attachements/LETSENCRYPT/fullchain.pem /etc/freeswitch/tls
        cp /attachements/LETSENCRYPT/privkey.pem /etc/freeswitch/tls

        #add symbolic links
        ln -s /etc/freeswitch/tls/all.pem /etc/freeswitch/tls/agent.pem
        ln -s /etc/freeswitch/tls/all.pem /etc/freeswitch/tls/tls.pem
        ln -s /etc/freeswitch/tls/all.pem /etc/freeswitch/tls/wss.pem
        ln -s /etc/freeswitch/tls/all.pem /etc/freeswitch/tls/dtls-srtp.pem

        #set the permissions
        chown -R www-data:www-data /etc/freeswitch/tls

