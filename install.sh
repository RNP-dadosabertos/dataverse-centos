#!/bin/bash
cd
rm -rf anaconda-ks.cfg epel-release-latest-7.noarch.rpm
yum update -y
yum install -y wget git net-tools
wget http://download.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ihv epel-release*
yum update -y
yum install -y nano curl htop lynx wget unzip nmap mod_ssl lsof java-1.8.0-openjdk java-1.8.0-openjdk-devel ImageMagick sendmail sendmail-cf m4 R
cd /etc/
rm -f hosts
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/hosts
cd
rm -rf v4.9.1.zip dvinstall.zip
wget https://github.com/IQSS/dataverse/archive/v4.9.1.zip
wget https://github.com/IQSS/dataverse/releases/download/v4.9.1/dvinstall.zip
rm -rf dataverse-4.9.1
unzip v4.9.1.zip
rm -rf dvinstall
unzip dvinstall.zip
rm -rf /tmp/dvinstall
cp -R dvinstall /tmp/
cd
rm -rf glassfish-4.1.zip
wget http://dlc-cdn.sun.com/glassfish/4.1/release/glassfish-4.1.zip
unzip glassfish-4.1.zip
rm -rf /usr/local/glassfish4
mv glassfish4 /usr/local
useradd glassfish
chown -R glassfish:glassfish /usr/local/glassfish4
su - glassfish
cd /usr/local/glassfish4/glassfish/modules
rm -f weld-osgi-bundle.jar
wget http://central.maven.org/maven2/org/jboss/weld/weld-osgi-bundle/2.2.10.SP1/weld-osgi-bundle-2.2.10.SP1-glassfish4.jar
cd /usr/local/glassfish4/glassfish/domains/domain1/config/
rm -f domain.xml
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/domain.xml
rm -rf /usr/local/glassfish4/glassfish/domains/domain1/config/cacerts.jks
cp -f /usr/lib/jvm/java-1.8.0-openjdk/jre/lib/security/cacerts /usr/local/glassfish4/glassfish/domains/domain1/config/cacerts.jks
exit
cd /usr/lib/systemd/system
rm -f glassfish.service
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/glassfish.service
systemctl daemon-reload
systemctl start glassfish.service
systemctl enable glassfish.service
cd /usr/bin
rm -rf jq
wget http://stedolan.github.io/jq/download/linux64/jq
chmod +x jq
jq --version
cd
rm -rf pgdg-centos96-9.6-3.noarch.rpm
wget https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install -y pgdg-centos96-9.6-3.noarch.rpm
yum makecache fast
yum install -y postgresql96-server
/usr/pgsql-9.6/bin/postgresql96-setup initdb
/usr/bin/systemctl start postgresql-9.6
/usr/bin/systemctl enable postgresql-9.6
cd /var/lib/pgsql/9.6/data
rm -f pg_hba.conf
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/pg_hba.conf
systemctl restart postgresql-9.6
su - postgres
psql
password ''$1''
\q
exit
systemctl restart postgresql-9.6
useradd solr
mkdir /usr/local/solr
chown solr:solr /usr/local/solr
su - solr
cd /usr/local/solr
rm -rf solr-7.3.0.tgz
wget https://archive.apache.org/dist/lucene/solr/7.3.0/solr-7.3.0.tgz
tar xvzf solr-7.3.0.tgz
cd solr-7.3.0
cp -r server/solr/configsets/_default server/solr/collection1
cp /tmp/dvinstall/schema.xml /usr/local/solr/solr-7.3.0/server/solr/collection1/conf
cp /tmp/dvinstall/solrconfig.xml /usr/local/solr/solr-7.3.0/server/solr/collection1/conf
cd /usr/local/solr/solr-7.3.0
bin/solr start
bin/solr create_core -c collection1 -d server/solr/collection1/conf/
exit
cd /usr/lib/systemd/system
rm -f solr.service
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/solr.service
systemctl daemon-reload
systemctl start solr.service
systemctl enable solr.service
cd /etc/security/
rm -f limits.conf
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/limits.conf
cd
sudo -i R
dir.create(Sys.getenv("R_LIBS_USER"), recursive = TRUE) 
.libPaths(Sys.getenv("R_LIBS_USER")) 
install.packages("R2HTML", repos="https://cloud.r-project.org/" )
install.packages("rjson", repos="https://cloud.r-project.org/" )
install.packages("DescTools", repos="https://cloud.r-project.org/" )
install.packages("Rserve", repos="https://cloud.r-project.org/" )
install.packages("haven", repos="https://cloud.r-project.org/" )
q()
n
cd /etc/mail/
hostname >> /etc/mail/relay-domains
rm -f sendmail.mc
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/sendmail.mc
m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf
systemctl restart sendmail.service
cd /tmp/dvinstall
rm -rf default.config
wget https://raw.githubusercontent.com/adornetejr/dataverse-furg/master/default.config
./install