FROM centos:7
ENV MYSQL_REPO_URL=https://dev.mysql.com/get/mysql80-community-release-el7-2.noarch.rpm
ENV MYSQL_VERSION=mysql-community-server-5.7.25-1.el7
ENV MYSQL_REPO=mysql57-community
RUN rm -rf /etc/localtime && touch /etc/localtime && chown 1001:1001 -R /etc/localtime && \
rpm -ivh $MYSQL_REPO_URL && sed -i "s/enabled=1/enabled=0/g" /etc/yum.repos.d/mysql-community.repo && \
yum install --enablerepo $MYSQL_REPO $MYSQL_VERSION -y && \
yum autoremove -y && \
yum clean all && rm -rf /var/cache/yum && \
touch /tmp/mysql.log && \
chown --dereference mysql /dev/stdout /dev/stderr /proc/self/fd/1 /proc/self/fd/2 /tmp/mysql.log && \
ln -sf /dev/stdout /tmp/mysql.log && ln -sf /dev/stderr /tmp/mysql.log
USER mysql
COPY run.sh /usr/bin/run.sh
ENTRYPOINT ["/usr/bin/run.sh"]
CMD ["--user=mysql", "--log-error=/tmp/mysql.log", "--bind-address=0.0.0.0", "--console"]