FROM centos:7
ENV TIMEZONE=
RUN yum install openssl libaio numactl-libs wget -y && \
groupadd mysql && \
useradd -r -g mysql -s /bin/false mysql && \
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz -O mysql.tar.xz && \
mkdir /opt/mysql /var/lib/mysql && tar xvf mysql.tar.xz  -C /opt/mysql --strip-components 1 && rm -rf mysql.tar.xz
RUN unlink /etc/localtime && touch /etc/localtime /etc/timezone && chown mysql:mysql -R /opt /var/lib/mysql /etc/localtime /etc/timezone && \
touch /tmp/mysql.log && \
chown --dereference mysql /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2 /tmp/mysql.log && \
ln -sf /dev/stdout /tmp/mysql.log && ln -sf /dev/stderr /tmp/mysql.log && \
ln -s /opt/mysql/bin/mysql /usr/bin/mysql && \
yum remove wget -y && yum autoremove -y && yum clean all &&  rm -rf /var/cache/yum
USER mysql
COPY run.sh /usr/bin/run.sh
EXPOSE 3306
ENTRYPOINT ["/usr/bin/run.sh"]
VOLUME ["var/lib/mysql"]
CMD ["--user=mysql", "--log-error=/tmp/mysql.log", "--bind-address=0.0.0.0", "--console"]



