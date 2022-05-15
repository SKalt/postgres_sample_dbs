-- https://www.postgresql.org/docs/current/sql-createtablespace.html
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!! WARNING !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- this code requires that the following directories exist, are empty, and are
-- owned by the system postgres user:
--   * /data/example
--   * /data/indices
-- If you're running docker/an OCI container, you may wish to provision these as
-- volumes.

CREATE TABLESPACE example_tablespace LOCATION '/data/example_tablespace';
CREATE USER tablespace_owner;
CREATE SCHEMA tablespace_dependencies AUTHORIZATION tablespace_owner;
CREATE TABLESPACE indexspace OWNER tablespace_owner LOCATION '/data/indices_tablespace';

-- https://www.postgresql.org/docs/current/sql-createtable.html
CREATE TABLE tablespace_dependencies.example_table(
    id INTEGER
  , CONSTRAINT example_table_pk PRIMARY KEY(id)
) TABLESPACE example_tablespace;

-- https://www.postgresql.org/docs/current/sql-createindex.html
CREATE INDEX example_index ON tablespace_dependencies.example_table(id)
TABLESPACE indexspace;

CREATE DATABASE db_in_tablespace TABLESPACE example_tablespace OWNER tablespace_owner;
