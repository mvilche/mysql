#!/bin/bash

MYSQL_DATADIR=/var/lib/mysql
    if [ -z $MYSQL_OPTS ]; then
    echo "***************************************************"
    echo "NO SE ENCUENTRA LA VARIABLE MYSQL_OPTS - INICIANDO POR DEFECTO"
    echo "*******************************************************"
    MYSQL_OPTS=
    else
    echo "***************************************************"
    echo "VARIABLE MYSQL_OPTS ENCONTRADA SETENADO VALORES: $MYSQL_OPTS"
    echo "*******************************************************"
    fi

    if [ -z "$TIMEZONE" ]; then
echo "···································································································"
echo "VARIABLE TIMEZONE NO SETEADA - INICIANDO CON VALORES POR DEFECTO"
echo "POSIBLES VALORES: America/Montevideo | America/El_Salvador"
echo "···································································································"
else
echo "···································································································"
echo "TIMEZONE SETEADO ENCONTRADO: " $TIMEZONE
echo "···································································································"
echo "SETENADO TIMEZONE"
cat /usr/share/zoneinfo/$TIMEZONE >> /etc/localtime && echo $TIMEZONE > /etc/timezone;
if [ $? -eq 0 ]; then
echo "···································································································"
echo "TIMEZONE SETEADO CORRECTAMENTE"
echo "···································································································"
else

echo "···································································································"
echo "ERROR AL SETEAR EL TIMEZONE - SALIENDO"
echo "···································································································"
exit 1
fi
fi
if find $MYSQL_DATADIR -mindepth 1 | read; then
    echo "**********************************************"
    echo "EL SERVICIO MYSQL YA FUE INICIALIZADO - SE ENCONTRARON DATOS"
    echo "**********************************************"
else

    if [ -z $MYSQL_ROOT_PASSWORD ]; then
    echo "***************************************************"
    echo "NO SE ENCUENTRA LA VARIABLE MYSQL_ROOT_PASSWORD - ERROR"
    echo "*******************************************************"
    exit 1
    fi    

	echo "***************************************************"
    echo "EL SERVICIO MYSQL NO SE HA INICIALIZADO - INICIALIZANDO..."
    echo "*******************************************************"
    /opt/mysql/bin/mysqld --initialize-insecure --datadir=$MYSQL_DATADIR && chown mysql:mysql -R $MYSQL_DATADIR && \
    /opt/mysql/bin/mysql_ssl_rsa_setup --datadir=$MYSQL_DATADIR && \
    echo "*******************************************************" && \
	echo "SERVICIO INICIALIZADO CORRECTAMENTE" && \
    echo "*******************************************************"

	FILE=/tmp/script.sql

cat << EOF > $FILE
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY "$MYSQL_ROOT_PASSWORD";
FLUSH PRIVILEGES;
EOF
	echo "DEFINIENDO PERMISOS...." && \
        /opt/mysql/bin/mysqld --daemonize  --datadir=$MYSQL_DATADIR
	/opt/mysql/bin/mysql -uroot < $FILE && \
	rm -f $FILE && \
    echo "*******************************************************" && \
	echo "TAREAS COMPLETADAS CORRECTAMENTE."
	pkill -9 mysqld
    echo "*******************************************************"
fi

echo "INICIANDO EL SERVICIO MYSQL...."
sleep 5s
exec /opt/mysql/bin/mysqld --datadir=$MYSQL_DATADIR $MYSQL_OPTS "$@"
