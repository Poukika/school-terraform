#!/bin/bash

# Modifiez ces valeurs et conservez-les en lieu sûr
db_username=admin
db_user_password=adminadmin
db_name=mydb
db_host=${rds_host}
# installer le serveur LAMP
sudo yum update -y
# installer le serveur apache
sudo yum install -y httpd


# activez d'abord php7.xx depuis amazon-linux-extra et installez-le

amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install -y php php-{pear,cgi,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip,imap,devel}
# installer l'extension Imagick
sudo yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini
extension=imagick
EOF
systemctl restart php-fpm.service

# Changer le PROPRIÉTAIRE et les autorisations du répertoire /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# Télécharger le package wordpress et l'extraire
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/

# Créer un fichier de configuration wordpress et mettre à jour la valeur de la base de données
cd /var/www/html
cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
sed -i "s/localhost/$db_host/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php

define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '256M');
EOF

# Modifier l'autorisation de /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#  activer les fichiers .htaccess dans la configuration Apache à l'aide de la commande sed
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

# Fait en sorte qu'apache et mariadb démarrent et redémarrent automatiquement apache
systemctl enable  httpd.service
systemctl restart httpd.service