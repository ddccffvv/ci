#! /bin/bash
/usr/bin/mysqld_safe &
sleep 5
mysql < /tmp/prepare_database.sql
