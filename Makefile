azure-download: ./tmp/azure-postgresql-sample-databases/README.md
./tmp/azure-postgresql-sample-databases/README.md: \
	./scripts/common.sh \
	./scripts/download/azure.sh
	@./scripts/download/azure.sh

polls: ./sample_dbs/polls/README.md
./sample_dbs/polls/README.md: \
	./tmp/azure-postgresql-samples-databases/polls-database-schema/readme.md \
	./scripts/common.sh \
	./scripts/transform/polls.sh
	@./scripts/transform/polls.sh

.PHONY: polls-dump
polls-dump: ./tmp/polls.schema.dump.sql.gz
./tmp/polls.schema.dump.sql.gz: ./sample_dbs/polls/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh polls --schema-only

adventureworks: ./sample_dbs/adventureworks/README.md
./sample_dbs/adventureworks/README.md: \
	./tmp/azure-postgresql-samples-databases/postgresql-adventureworks/README.md \
	./scripts/common.sh \
	./scripts/transform/adventureworks.sh
	@./scripts/start_local_db.sh
	@PGHOST=localhost PGUSER=postgres ./scripts/transform/adventureworks.sh

.PHONY: adventureworks-dump
adventureworks-dump: ./tmp/adventureworks.schema.dump.sql.gz
./tmp/adventureworks.schema.dump.sql.gz: ./sample_dbs/adventureworks/README.md
# ^ produced as a by-product of checking in the sample db

sakila-download: ./tmp/sakila/README.md
./tmp/sakila/README.md: \
	./scripts/common.sh \
	./scripts/download/sakila.sh
	@./scripts/download/sakila.sh

sakila: ./sample_dbs/sakila/README.md
./sample_dbs/sakila/README.md: \
	./tmp/sakila/README.md \
	./scripts/common.sh \
	./scripts/transform/sakila.sh
	@./scripts/transform/sakila.sh

.PHONY: sakila-dump
sakila-dump:./tmp/sakila.schema.dump.sql.gz
./tmp/sakila.schema.dump.sql.gz: ./sample_dbs/sakila/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh sakila

yugabyte-download: ./tmp/yugabyte-db/sample/users.sql
./tmp/yugabyte-db/sample/users.sql: \
	./scripts/common.sh \
	./scripts/download/yugabyte.sh
	@./scripts/download/yugabyte.sh

airflow: ./sample_dbs/airflow/sql/00_schema.ddl.sql
./sample_dbs/airflow/sql/00_schema.ddl.sql: \
	./tmp/yugabyte-db/sample/airflowybrepo.sql \
	./scripts/common.sh \
	./scripts/transform/airflow.sh
	@./scripts/transform/airflow.sh

.PHONY: airflow-dump
airflow-dump: ./tmp/airflow.schema.dump.sql.gz
./tmp/airflow.schema.dump.sql.gz: ./sample_dbs/airflow/sql/00_schema.ddl.sql
	@./scripts/start_local_db.sh
	@./scripts/dump.sh airflow --schema-only

chinook: ./sample_dbs/chinook/README.md
./sample_dbs/chinook/README.md: \
	./tmp/yugabyte-db/sample/chinook* \
	./scripts/common.sh \
	./scripts/transform/chinook.sh
	@./scripts/transform/chinook.sh

.PHONY: chinook-dump
chinook-dump: ./tmp/chinook.schema.dump.sql.gz
./tmp/chinook.schema.dump.sql.gz: ./sample_dbs/chinook/README.md
	@./scripts/start_local_db.sh
	@./scripts/dump.sh chinook

clubdata: ./sample_dbs/clubdata/README.md
./sample_dbs/clubdata/README.md: \
	./tmp/yugabyte-db/sample/clubdata* \
	./scripts/common.sh \
	./scripts/transform/clubdata.sh
	@./scripts/transform/clubdata.sh

.PHONY: clubdata-dump
clubdata-dump: ./tmp/clubdata.schema.dump.sql.gz
./tmp/clubdata.schema.dump.sql.gz: ./sample_dbs/clubdata/README.md
	@./scripts/start_local_db.sh
	@./scripts/dump.sh clubdata

northwind: ./sample_dbs/northwind/README.md
./sample_dbs/northwind/README.md: \
	./tmp/yugabyte-db/sample/northwind* \
	./scripts/common.sh \
	./scripts/transform/northwind.sh
	@./scripts/transform/northwind.sh

.PHONY: northwind-dump
northwind-dump: ./tmp/northwind.schema.dump.sql.gz
./tmp/northwind.schema.dump.sql.gz: ./sample_dbs/northwind/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh northwind

covid: ./sample_dbs/covid/README.md
./sample_dbs/covid/README.md: \
	./tmp/yugabyte-db/sample/covid-data-case-study/covid-data-case-study.zip \
	./scripts/common.sh \
	./scripts/transform/covid.sh
	@./scripts/transform/covid.sh

.PHONY: covid-dump
covid-dump: ./tmp/covid.schema.dump.sql.gz
./tmp/covid.schema.dump.sql.gz: ./sample_dbs/covid/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh covid

retail_analytics: ./sample_dbs/retail_analytics/README.md
./sample_dbs/retail_analytics/README.md: \
	./tmp/yugabyte-db/sample/schema.sql \
	./tmp/yugabyte-db/sample/users.sql \
	./tmp/yugabyte-db/sample/orders.sql \
	./tmp/yugabyte-db/sample/reviews.sql \
	./scripts/common.sh \
	./scripts/transform/retail_analytics.sh
	@./scripts/transform/retail_analytics.sh

.PHONY: retail-analytics-dump
retail-analytics-dump:./tmp/retail_analytics.schema.dump.sql.gz
./tmp/retail_analytics.schema.dump.sql.gz: ./sample_dbs/retail_analytics/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh retail_analytics

sportsdb: ./sample_dbs/sportsdb/README.md
./sample_dbs/sportsdb/README.md: \
	./tmp/yugabyte-db/sample/sportsdb* \
	./scripts/common.sh \
	./scripts/transform/sportsdb.sh
	@./scripts/transform/sportsdb.sh

.PHONY: sportsdb-dump
sportsdb-dump: ./tmp/sportsdb.schema.dump.sql.gz
./tmp/sportsdb.dump.sql.gz: ./sample_dbs/sportsdb/README.md ./scripts/dump.sh
	@./scripts/start_local_db.sh
	@./scripts/dump.sh sportsdb

ALL_SH_FILES=$(shell find -type f -name '*.sh')
lint: $(ALL_SH_FILES)
	shellcheck --source-path=SCRIPTDIR $(ALL_SH_FILES)

.PHONY: yugabyte-download azure-download sakila-download
all-dbs: \
	airflow \
	chinook \
	clubdata \
	covid \
	northwind \
	polls \
	retail_analytics \
	sakila \
	sportsdb \

all-dumps: \
	airflow-dump \
	chinook-dump \
	clubdata-dump \
	covid-dump \
	northwind-dump \
	polls-dump \
	retail-analytics-dump \
	sakila-dump \
	sportsdb-dump \

.PHONY: psql
### get access to a psql shell
psql:
	docker-compose up -d pg
	while ! docker-compose exec pg pg_isready -h localhost; do sleep .5; done
	docker-compose exec pg psql
	docker-compose down -v
