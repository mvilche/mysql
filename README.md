# MYSQL 5.7

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)


# Funcionalidades:

  - Permite definir la zona horaria al iniciar el servicio
  - Permite definir parametros adicionales al iniciar el servicio MySql
  - Non-root container

### Iniciar


Ejecutar para iniciar el servicio

```sh
$ docker run -d -e TIMEZONE=America/Montevideo -e MYSQL_OPTS=--character-set-server=utf8mb4 -e MYSQL_ROOT_PASSWORD=123456 mvilche/mysql:5.7-centos7
```
Eliga el tag según el sistema operativo desead

### Variables


| Variable | Detalle |
| ------ | ------ |
| TIMEZONE | Define la zona horaria a utilizar (America/Montevideo, America/El_salvador) |
| MYSQL_ROOT_PASSWORD | Password para el usuario root - variable requerida |
| MYSQL_OPTS | Define parametros adicionales al iniciar el servicio mysql (ver mysqld --verbose --help ) |

License
----

Martin vilche

