FROM debian:9
ENV TIMEZONE=
RUN apt update && apt install wget openssl procps libnuma1 libaio1 xz-utils -y && \
groupadd mysql && \
useradd -r -g mysql -s /bin/false mysql && \
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.15-linux-glibc2.12-x86_64.tar.xz -O mysql.tar.xz && \
mkdir /opt/mysql /var/lib/mysql && tar xvf mysql.tar.xz  -C /opt/mysql --strip-components 1 && rm -rf mysql.tar.xz && \ 
touch /etc/localtime && chown mysql:mysql -R /opt /var/lib/mysql /etc/localtime && \
touch /tmp/mysql.log && \
chown --dereference mysql /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2 /tmp/mysql.log && \
ln -sf /dev/stdout /tmp/mysql.log && ln -sf /dev/stderr /tmp/mysql.log && \
ln -s /opt/mysql/bin/mysql /usr/bin/mysql && \
apt remove wget xz-utils -y && apt clean && apt autoclean && apt autoremove -y
USER mysql
COPY run.sh /usr/bin/run.sh
EXPOSE 3306
ENTRYPOINT ["/usr/bin/run.sh"]
VOLUME ["var/lib/mysql"]
CMD ["--user=mysql", "--log-error=/tmp/mysql.log", "--bind-address=0.0.0.0", "--console"]



