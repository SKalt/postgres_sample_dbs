./tmp/azure-postgresql-sample-databases/README.md: \
	./scripts/download/common.sh \
	./scripts/download/azure.sh
	./scripts/download/azure.sh

./tmp/salika/README.md: \
	./scripts/download/common.sh \
	./scripts/download/salika.sh
	./scripts/download/salika.sh

./tmp/yugabyte-db/sample/users.sql: \
	./scripts/download/common.sh \
	./scripts/download/yugabyte.sh
	./scripts/download/yugabyte.sh

ALL_SH_FILES=$(shell find -type f -name '*.sh')
lint: $(ALL_SH_FILES)
	shellcheck --source-path=SCRIPTDIR $(ALL_SH_FILES)
