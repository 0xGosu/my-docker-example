
FROM centos:7
MAINTAINER "tranvietanh1991" <tranvietanh1991@email.here>
RUN yum -y update
RUN yum groupinstall -y development
#install proper lib and tool
RUN yum install -y zlib-devel openssl-devel sqlite-devel bzip2-devel yum-utils wget vim python-devel screen epel-release lsof
RUN yum install -y python-pip python-wheel
RUN pip install ansible
ADD ./ansible-tower-setup-2.4.4 /ansible-tower-setup
VOLUME /var/log /etc/ansible
WORKDIR /ansible-tower-setup
RUN ./configure -o tower_setup_conf.yml --no-secondary-prompt
# RUN ./setup.sh
EXPOSE 80 443 8080