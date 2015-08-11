#!/bin/bash
# Author- Gerardo Rada

if pgrep "apache2" > /dev/null
then
	echo "******************************** Ya esta todo instalado ******************************"

else
	# Updating repository
	sudo apt-get -y update

	echo "******************************** Instalando Postgresql *******************************"
	#postgresql
	sudo apt-get install postgresql postgresql-contrib -y
	sudo apt-get install pgadmin3 -y
	sudo echo -e "postgres\npostgres" | sudo passwd postgres
	sudo wget https://www.dropbox.com/s/dzgf15zgi3twdzw/pg_hba.conf?dl=0
	sudo mv pg_hba.conf?dl=0 pg_hba.conf
	sudo mv pg_hba.conf /etc/postgresql/9.3/main/
	sudo chown postgres:postgres -R /etc/postgresql/9.3/main/
	sudo /etc/init.d/postgresql restart
	echo "CREATE DATABASE geo  WITH OWNER = postgres  ENCODING = 'UTF8'  TABLESPACE = pg_default  CONNECTION LIMIT = -1;" > createdb.sql
	sudo -i -u postgres
	psql -a -f /home/vagrant/createdb.sql -U postgres -w -h localhost

	echo "******************************** Instalando GUI **************************************"
	#GUI
	sudo apt-get -y remove dictionaries-common
	sudo /usr/share/debconf/fix_db.pl # fix for dictionaries-common bug
	sudo apt-get install -y xfce4 xfce4-goodies
	sudo apt-get install gnome-icon-theme-full tango-icon-theme
	sudo cp /vagrant/Xwrapper.config /etc/X11
	sudo apt-get install language-pack-UTF-8 #fix for warning "Your environment specifies an invalid locale."
	sudo locale-gen UTF-8 

	echo "******************************** Instalando complementos del virtualbox **************"
	# complementos virtual box
	sudo apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

	echo "******************************** Instalando Mysql ************************************"
	# Installing MySQL and it's dependencies, Also, setting up root password for MySQL as it will prompt to enter the password during installation
	sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
	sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'
	sudo apt-get -y install mysql-server
	wget https://www.dropbox.com/s/op9pgox0snyyp1i/lacnic_dummy.sql?dl=0 > /dev/null
	sudo mv lacnic_dummy.sql?dl=0 lacnic_dummy.sql
	echo "create database lacnic" | mysql -u root -proot
	mysql -u root -proot lacnic < lacnic_dummy.sql
	
	echo "******************************** Instalando Java ************************************"
	# Installing Java 7 
	sudo apt-get install openjdk-7-jre -y 

	echo "******************************** Instalando Chrome ************************************"
	#Installing Chrome
	sudo apt-get install libxss1 libappindicator1 libindicator7 -y
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb  > /dev/null
	sudo dpkg -i google-chrome*.deb


	#Installing Firefox
	#sudo apt-get install firefox -y

	echo "******************************** Instalando jboss6 ************************************"
	# Installing Jboss
	wget https://www.dropbox.com/s/vt38sfz2d2ojf1e/jboss61.tar.gz?dl=0 > /dev/null
	sudo mv jboss61.tar.gz?dl=0 jboss61.tar.gz
	sudo tar -xvzf jboss61.tar.gz
	sudo chown vagrant:vagrant -R .
	sudo find . -name "._*" -exec rm -v {} \;
	sudo rm jboss61.tar.gz
	/home/vagrant/jboss-6.1/bin/run.sh -b 0.0.0.0 &
	
	echo "******************************** Configurar jboss para inicie con el ubuntu ***********"
	echo "/home/vagrant/jboss-6.1/bin/run.sh -b 0.0.0.0 &" > jboss_run.sh
	sudo mv /home/vagrant/jboss_run.sh /etc/init.d/
	sudo chmod +x /etc/init.d/jboss_run.sh
	sudo update-rc.d jboss_run.sh defaults

	echo "******************************** Instalando apache ************************************"
	# Installing Apache
	sudo apt-get -y install apache2
	wget https://www.dropbox.com/s/dpi4tpvz8hrnwrg/000-default.conf?dl=0
	sudo mv 000-default.conf?dl=0 000-default.conf
	sudo cp /etc/apache2/mods-available/proxy_http.load /etc/apache2/mods-enabled/
	sudo cp /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/
	sudo cp 000-default.conf /etc/apache2/sites-enabled/
	sudo /etc/init.d/apache2 restart
	
	echo "******************************** Instalando wireshark *********************************"
	sudo apt-get install wireshark -y

	echo "******************************** Instalación finalizada *******************************"
fi

echo "******************************** Iniciando jboss y gui ********************************"
	
#Iniciado jboss y GUI	
#sudo /home/vagrant/jboss-6.1/bin/run.sh -b 0.0.0.0 &
su - vagrant -c "startxfce4"