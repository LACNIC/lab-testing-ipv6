#!/bin/bash
# Author- Gerardo Rada

# Updating repository

sudo apt-get -y update

#postgresql
#sudo apt-get -y install postgresql-9.4 postgresql-client-9.3 pgadmin3
#wget https://www.dropbox.com/s/r6grgky9dcwaun6/geo.sql?dl=0 > /dev/null
#sudo mv geo.sql?dl=0 geo.sql


#GUI
sudo apt-get -y remove dictionaries-common
sudo /usr/share/debconf/fix_db.pl # fix for dictionaries-common bug
sudo apt-get install -y xfce4 xfce4-goodies
sudo apt-get install gnome-icon-theme-full tango-icon-theme
sudo cp /vagrant/Xwrapper.config /etc/X11
sudo apt-get install language-pack-UTF-8 #fix for warning "Your environment specifies an invalid locale."
sudo locale-gen UTF-8 

# complementos virtual box
sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

# Installing Apache
sudo apt-get -y install apache2

# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
sudo apt-get -y install mysql-server

wget https://www.dropbox.com/s/op9pgox0snyyp1i/lacnic_dummy.sql?dl=0 > /dev/null
sudo mv lacnic_dummy.sql?dl=0 lacnic_dummy.sql
echo "create database lacnic" | mysql -u root -proot
mysql -u root -proot lacnic < lacnic_dummy.sql

# Installing Java 7 
sudo apt-get install openjdk-7-jre -y 

#Installing Chrome
sudo apt-get install libxss1 libappindicator1 libindicator7 -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb  > /dev/null
sudo dpkg -i google-chrome*.deb

#Installing Firefox
sudo apt-get install firefox -y

# Installing Jboss
wget https://www.dropbox.com/s/vt38sfz2d2ojf1e/jboss61.tar.gz?dl=0 > /dev/null
sudo mv jboss61.tar.gz?dl=0 jboss61.tar.gz
sudo tar -xvzf jboss61.tar.gz
sudo chown vagrant:vagrant -R .
sudo find . -name "._*" -exec rm -v {} \;
#sudo rm jboss61.tar.gz
/home/vagrant/jboss-6.1/bin/run.sh -b 0.0.0.0 &
