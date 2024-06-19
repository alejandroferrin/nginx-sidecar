#!/bin/sh

# Verificación de argumentos
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 domain_name localhost"
    exit 1
fi

DOMAIN1=$1
LOCALHOST=$2

# encabezado del archivo de configuración nginx.conf
cat <<EOL > ./nginx.conf
worker_processes  1;
events { worker_connections  1024; }
http {
    include mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout  65;
    server {
        listen 80 default_server;
        return 301 https://\$host\$request_uri;
    }
    server {
        listen 443 ssl;
        server_name $DOMAIN1;
        client_max_body_size 1000M;
        location / {
            resolver 127.0.0.1 [$LOCALHOST]:8080 valid=30s;
            proxy_pass http://$LOCALHOST:8080;
            proxy_redirect off;
            proxy_set_header Host \$host;
        }
        ssl_certificate /etc/letsencrypt/live/$DOMAIN1/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/$DOMAIN1/privkey.pem;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
        ssl_ciphers HIGH:!aNULL:!MD5;
    }
}
EOL
