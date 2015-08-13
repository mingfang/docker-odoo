FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8
RUN echo "export PS1='\e[1;31m\]\u@\h:\w\\$\[\e[0m\] '" >> /root/.bashrc

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common jq psmisc

RUN apt-get install -y runit 
CMD /usr/sbin/runsvdir-start

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common

RUN apt-get install -y postgresql

RUN apt-get install -y gdebi-core

RUN wget http://nightly.odoo.com/8.0/nightly/deb/odoo_8.0.latest_all.deb 
RUN gdebi -n odoo*.deb

ADD odoo.ddl /
RUN sudo -u postgres /usr/lib/postgresql/9.3/bin/postmaster -D /etc/postgresql/9.3/main & sleep 3 && \
    sudo -u postgres psql < odoo.ddl

RUN useradd -m openerp
RUN chmod 777 /usr/lib/python2.7/dist-packages/openerp/addons

#Add runit services
ADD sv /etc/service 

