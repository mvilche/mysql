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

if [ -d /var/lib/mysql/mysql ]; then
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
    mysqld --initialize && chown mysql:mysql -R $MYSQL_DATADIR && \
    echo "*******************************************************" && \
	echo "SERVICIO INICIALIZADO CORRECTAMENTE" && \
    echo "*******************************************************"

	FILE=/tmp/script.sql

cat << EOF > $FILE
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PdockASSWORD' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
	echo "DEFINIENDO PERMISOS...." && \
	mysqld --user=mysql --bootstrap --verbose=0 < $FILE && \
	rm -f $FILE && \
    echo "*******************************************************" && \
	echo "TAREAS COMPLETADAS CORRECTAMENTE." && \
    echo "*******************************************************"
fi

echo "INICIANDO EL SERVICIO MYSQL...."
sleep 5s
exec mysqld $MYSQL_OPTS "$@"
