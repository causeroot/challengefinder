#!/bin/bash

# do this in the background to take advantage of entropy generated by apt-get
sudo apt-get update
sudo apt-get upgrade
# install the first batch of supporting software
sudo apt-get install unattended-upgrades git apticron ruby1.9.1 ruby1.9.1-dev \
    libxslt-dev libxml2-dev libnokogiri-ruby1.9.1 sqlite3 openjdk-6-jdk \
    solr-tomcat vim debconf-utils apache2 libapache2-mod-passenger \
    libmysql-ruby libmysqlclient-dev -y

# set notifications for auto-update
sudo sed --in-place 's/EMAIL="root"/EMAIL="info@causeroot.org"/g' /etc/apticron/apticron.conf

# wait for gey generation to finish
echo "Waiting for %1"
wait %1

# preseed mysql with a root password
MYSQL_ROOT_PASSWORD=$(openssl rand -hex 32)
echo "Using root password: ${MYSQL_ROOT_PASSWORD}"

echo "mysql-server-5.5	mysql-server/root_password_again	password	${MYSQL_ROOT_PASSWORD}" > mysql.seed
echo "mysql-server-5.5	mysql-server/root_password	password	${MYSQL_ROOT_PASSWORD}" >> mysql.seed
echo "mysql-server-5.5	mysql-server-5.5/postrm_remove_databases	boolean	false" >> mysql.seed
echo "mysql-server-5.5	mysql-server-5.5/start_on_boot	boolean	true" >> mysql.seed
echo "mysql-server-5.5	mysql-server-5.5/really_downgrade	boolean	false" >> mysql.seed

cat mysql.seed | sudo debconf-set-selections

sudo apt-get install mysql-server-5.5 -y
mysqladmin --user="root" --password="${MYSQL_ROOT_PASSWORD}" create challengefinder

mysql --user="root" --password="${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON challengefinder.* TO challengefinder@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'"
mysqladmin --user="root" --password="${MYSQL_ROOT_PASSWORD}" flush-privileges

sudo gem install bundler

if [ -d challengefinder ]; then
    # pull updated from the repo
    cd challengefinder;
    git pull origin
    rake db:migrate
    touch tmp/restart.txt
    cd ..
else
    git clone https://github.com/causeroot/challengefinder.git
cat <<'EOF' > challengefinder/config/database.yml
development:
    adapter: mysql2
    encoding: utf8
    database: challengefinder
    username: challengefinder
    password: ${MYSQL_ROOT_PASSWORD}
    host: 127.0.0.1
    port: 3306
EOF
    bundle install
    rake db:migrate
    rake sunspot:solr:start
    rake db:seed
    mkdir -p challengefinder/tmp
    touch challengefinder/tmp/restart.txt
fi

cat <<'EOF' > challengefinder.conf
<VirtualHost *:80>
    ServerName www.challengefinder.org
    DocumentRoot /home/ubuntu/challengefinder/public
    <Directory /home/ubuntu/challengefinder/public>
        Allow from all
        Options -MultiViews
    </Directory>
</VirtualHost>
EOF

sudo mv challengefinder.conf /etc/apache2/sites-available/challengefinder
sudo mv /etc/apache2/sites-available/000-default old-default

sudo a2ensite challengefinder
sudo service apache2 reload


# sign the public key so that we can trust using it for encryption
wget "https://invulnerable.org/gardner.pub"
gpg --import gardner.pub
gpg --import challengefinder/doc/causeroot.key 

# locally sign our key "neverused" is actually used once, to sign the key locally.
echo "neverused" | gpg --passphrase-fd 0 --yes --batch --lsign-key 7CEF7BFC
gpg --yes --batch --recipient gardner@invulnerable.org --encrypt mysql.seed
rm -f mysql.seed
rm -f gardner.pu*