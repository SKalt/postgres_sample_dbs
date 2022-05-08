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

adventureworks: ./sample_dbs/adventureworks/README.md
./sample_dbs/adventureworks/README.md: \
	./tmp/azure-postgresql-samples-databases/postgresql-adventureworks/README.md \
	./scripts/common.sh \
	./scripts/transform/adventureworks.sh
	@./scripts/transform/adventureworks.sh

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

yugabyte-download: ./tmp/yugabyte-db/sample/users.sql
./tmp/yugabyte-db/sample/users.sql: \
	./scripts/common.sh \
	./scripts/download/yugabyte.sh
	@./scripts/download/yugabyte.sh

airflow: ./sample_dbs/airflow/ddl/00_schema.sql
./sample_dbs/airflow/ddl/00_schema.sql: \
	./tmp/yugabyte-db/sample/airflowybrepo.sql \
	./scripts/common.sh \
	./scripts/transform/airflow.sh
	@./scripts/transform/airflow.sh

chinook: ./sample_dbs/chinook/README.md
./sample_dbs/chinook/README.md: \
	./tmp/yugabyte-db/sample/chinook* \
	./scripts/common.sh \
	./scripts/transform/chinook.sh
	@./scripts/transform/chinook.sh

clubdata: ./sample_dbs/clubdata/README.md
./sample_dbs/clubdata/README.md: \
	./tmp/yugabyte-db/sample/clubdata* \
	./scripts/common.sh \
	./scripts/transform/clubdata.sh
	@./scripts/transform/clubdata.sh

northwind: ./sample_dbs/northwind/README.md
./sample_dbs/northwind/README.md: \
	./tmp/yugabyte-db/sample/northwind* \
	./scripts/common.sh \
	./scripts/transform/northwind.sh
	@./scripts/transform/northwind.sh

ALL_SH_FILES=$(shell find -type f -name '*.sh')
lint: $(ALL_SH_FILES)
	shellcheck --source-path=SCRIPTDIR $(ALL_SH_FILES)

.PHONY: yugabyte-download azure-download sakila-download
