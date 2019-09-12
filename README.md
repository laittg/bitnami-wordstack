## .env
```
# for wordmove, wrap value by double quote
WP_HOST_PROD="http://host.com"
WP_HOST_LOCAL="http://host.local"
DB_PASSWORD_PROD="super-secret"
DB_HOST_PROD="127.0.0.1"
SSH_HOST_PROD="ssh-config-host"

# for docker-compose, do not use quote
PROJECT_NAME=bn

# location of id_rsa for production server
#  must be starting exactly with .ssh
#  do not include trailing slash
SSH_DIR=.ssh

# ports
PORT_MARIADB=3306
PORT_WORDPRESS=80
PORT_PMA=8080
```