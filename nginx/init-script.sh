#!/bin/bash
apk add certbot
# Sustituye los valores de 'yourdomain.com' y 'youremail@domain.com' por los correspondientes
domain="yourdomain.com"
email="youremail@domain.com"
# Obtener certificado de Let's Encrypt
certbot certonly --nginx --non-interactive --agree-tos -d $domain -m $email
# Recargar Nginx
nginx -s reload