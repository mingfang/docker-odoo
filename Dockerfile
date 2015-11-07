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

#Requirements
RUN apt-get install -y postgresql gdebi-core

#python-ofxparse
RUN wget http://http.us.debian.org/debian/pool/main/p/python-ofxparse/python-ofxparse_0.14-1_all.deb && \
    gdebi -n *.deb && \
    rm *.deb

#wkhtmltox
RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && \
    gdebi -n *.deb && \
    rm *.deb
RUN cp /usr/local/bin/wkhtmltopdf /usr/bin && \
    cp /usr/local/bin/wkhtmltoimage /usr/bin 

#Odoo
RUN wget -O - https://nightly.odoo.com/odoo.key | apt-key add -
RUN echo "deb http://nightly.odoo.com/9.0/nightly/deb/ ./" >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y odoo

#Configure database
ADD odoo.ddl /
RUN sudo -u postgres /usr/lib/postgresql/9.3/bin/postmaster -D /etc/postgresql/9.3/main & sleep 3 && \
    sudo -u postgres psql < odoo.ddl

RUN useradd -m openerp
RUN chmod 777 /usr/lib/python2.7/dist-packages/openerp/addons

#Add runit services
ADD sv /etc/service 
