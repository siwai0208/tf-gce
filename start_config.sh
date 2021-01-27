#!/bin/bash
sudo su -
useradd -p ${userpass} -d /home/${username} ${username}
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1
yum install -y git zip unzip
yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
yum install -y yum-utils
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
yum module -y disable mysql mariadb
yum install -y mysql-community-server
yum module -y reset php nginx
yum module -y enable nginx:1.18
yum module -y enable php:7.3
yum install -y php php-fpm php-json php-pdo php-xml php-mbstring php-mysqlnd
yum install -y nginx
export HOME=/root && /usr/bin/curl -s https://getcomposer.org/installer | /usr/bin/php && mv composer.phar /usr/local/bin/composer
cd /usr/share/nginx/html/ && git config --global user.name ${gituser} && git config --global user.email ${gitemail} && git clone https://${gituser}:${gitpassword}@github.com/siwai0208/food-app
cd /usr/share/nginx/html/ && chown -R ${username}:${username} food-app
cd /usr/share/nginx/html/food-app && chmod -R 777 storage && chmod -R 777 bootstrap/cache/
cd /usr/share/nginx/html/food-app && sudo -u ${username} /usr/local/bin/composer update
sed -i s@'listen = /run/php-fpm/www.sock'@'listen = 127.0.0.1:9000'@g /etc/php-fpm.d/www.conf
sudo setenforce 0
sed -i s@'SELINUX=enforcing'@'SELINUX=disabled'@g /etc/selinux/config
systemctl start mysqld && systemctl enable mysqld
echo validate_password_policy=LOW >> /etc/my.cnf
systemctl restart mysqld
mysql -u root "-p$(grep -oP '(?<=root@localhost\: )\S+' /var/log/mysqld.log)" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${dbpassword}'" --connect-expired-password
mysql -u root "-p${dbpassword}" -e "CREATE USER '${dbuser}'@'%' IDENTIFIED BY '${dbpassword}'"
mysql -u root "-p${dbpassword}" -e "GRANT ALL PRIVILEGES ON *.* TO '${dbuser}'@'%'"
mysql -u root "-p${dbpassword}" -e "FLUSH PRIVILEGES"
mysql -u root "-p${dbpassword}" -e "CREATE DATABASE ${dbname}"
cat << 'EOF' > /etc/nginx/conf.d/default.conf
server {
    listen 80;
    root /usr/share/nginx/html/food-app/public;
    index index.php index.html index.htm;
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
    location / {
        try_files $uri $uri/ /index.php$is_args$args;
    }
    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }
}
EOF
su ${username}
cd /usr/share/nginx/html/food-app
cp .env.example .env
sed -i s/'APP_NAME=Laravel'/'APP_NAME="Food Delivery APP"'/g .env
sed -i s/'DB_PASSWORD='/DB_PASSWORD=${dbpassword}/g .env
php artisan key:generate
php artisan config:cache
php artisan migrate
php artisan db:seed
systemctl start php-fpm.service && systemctl start nginx.service
systemctl enable php-fpm.service && systemctl enable nginx.service
