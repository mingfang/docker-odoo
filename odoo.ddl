CREATE ROLE odoo WITH SUPERUSER LOGIN PASSWORD 'postgres';

update pg_database set datallowconn = TRUE where datname = 'template0';
update pg_database set datistemplate = FALSE where datname = 'template1';
drop database template1;
create database template1 with template = template0 encoding = 'UTF8';
update pg_database set datistemplate = TRUE where datname = 'template1';
update pg_database set datallowconn = FALSE where datname = 'template0';
