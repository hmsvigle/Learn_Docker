#!/bin/bash
set -e

cd ~/
wget https://raw.githubusercontent.com/apache/ambari/branch-2.7/ambari-server/src/main/resources/Ambari-DDL-Postgres-CREATE.sql
sed -i "s/\${ambariSchemaVersion}/2.7.0.0/g" Ambari-DDL-Postgres-CREATE.sql

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL

    create database ambari;
    create user ambari with password 'dev';
    GRANT ALL PRIVILEGES ON DATABASE ambari TO ambari;
    ALTER SCHEMA public OWNER to ambari;

    \connect ambari ambari;
    CREATE SCHEMA ambari AUTHORIZATION ambari;
    ALTER SCHEMA ambari OWNER TO ambari;
    ALTER ROLE ambari SET search_path to 'ambari', 'public';

    \i Ambari-DDL-Postgres-CREATE.sql 
EOSQL

cp /pg_hba.conf /var/lib/postgresql/data/
