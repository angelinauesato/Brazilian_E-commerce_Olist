use role accountadmin;

create database olist_db;

create role olist_role; 

show grants on warehouse dbt_wh;

grant usage on warehouse dbt_wh to role olist_role;

SELECT CURRENT_USER();
grant role olist_role to user <YOUR_USER>;

grant all on database olist_db to role olist_role;

use role olist_role;

create schema olist_db.raw_olist;

create schema olist_db.prod_olist;

drop schema olist_db.public;

create schema olist_db.snapshots;

create schema olist_db.mart;
