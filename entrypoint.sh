#!/bin/sh

set -e

echo 'PATH=$PATH:~/.composer/vendor/bin' >> ~/.bashrc

chgrp -R www-data /var/www/html

if [ -z "$1" ]
then
    exec apache2-foreground
else
    exec "$@"
fi

#EOF
