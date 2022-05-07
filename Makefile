azure-download: ./tmp/azure-postgresql-sample-databases/README.md
./tmp/azure-postgresql-sample-databases/README.md: \
	./scripts/common.sh \
	./scripts/download/azure.sh
	./scripts/download/azure.sh

sakila-download: ./tmp/sakila/README.md
./tmp/sakila/README.md: \
	./scripts/common.sh \
	./scripts/download/sakila.sh
	./scripts/download/sakila.sh

sakila: \
	./tmp/sakila/README.md \
	./scripts/common.sh \
	./scripts/transform/sakila.sh
	./scripts/transform/sakila.sh

yugabyte-download: ./tmp/yugabyte-db/sample/users.sql
./tmp/yugabyte-db/sample/users.sql: \
	./scripts/common.sh \
	./scripts/download/yugabyte.sh
	./scripts/download/yugabyte.sh

ALL_SH_FILES=$(shell find -type f -name '*.sh')
lint: $(ALL_SH_FILES)
	shellcheck --source-path=SCRIPTDIR $(ALL_SH_FILES)

.PHONY: yugabyte-download azure-download sakila-download
