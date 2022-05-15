# Postgres Sample Dbs

A collection of postgres sample dbs in a standardized format.

## Licensing

Each of the sample databases contains its own license file(s).

The code to extract, transform, and load the sample databases is licensed as MIT in ./LICENSE.md

## Directory structure

Each checked-in sample db in the `./sample_dbs` directory

```
${db_name}
├── sql/*.{ddl,dml}.sql{,.gz}
├── README*   # optional
└── LICENSE*
```

Note that files

- some files >5MB are gzipped (the files matching `dml/*.sql.gz`).

## Usage

### download

#### from releases (preferred)

### restore

<details open><summary>shell</summary>

```sh
#!/usr/bin/env sh
set -eu
pass() { return 0; }
load_file() {
  case "$1" in
    *.gz) gunzip -c "$1" | psql;;
    *.sql) psql -f "$1" ;;
  esac
}
restore_sample_db() {
  path_to_sample_db=$1
  schema_only=${2:-false}

  for f in "$path_to_sample"/sql/*.sql*; do
    case "$f" in
    *.ddl.*) load_file "$f";;
    *.dml.*)
      if [ "$schema_only" = "true" ]; then pass
      else load_file "$f"
      fi
      ;;
    esac
  fi
}

# if your current working directory was in this repo's root
# and you have a running postgres db
restore_sample_db ./sample_dbs/sakila/sql
```

</details>

<details><summary>python</summary>

```py
#!/usr/bin/env python3
"""
USAGE: load.py path/to/sql_dir
"""
import gzip
import logging
import os
import subprocess
import sys
assert sys.version >= (3, 7)

from argparse import ArgumentParser
from pathlib import Path

cli = ArgumentParser()
cli.add_arg("--dry-run", action="store_true", help="print what would be run")
cli.add_arg("--schema-only", action="store_true", help="filter out dml")
cli.add_arg("path", type=Path)

def main(path: str, schema_only: bool = False, dry_run: bool = False) -> None:
    sql_dir = Path(path)
    assert sql_dir.exists(), f"{sql_dir} does not exist"
    assert sql_dir.is_dir(), f"{sql_dir} is not a directory"
    for file in sql_dir.iterdir():
        if schema_only and '.dml.' in file.name:
            continue
        if dry_run:
            logging.info(f"would restore {file}")
            continue
        logging.info(f"restoring {file}")
        with gzip.open(file) if file.name.endswith(".gz") else file as f:
            data = f.read()
        subprocess.run(["psql"], input=data, check=True)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    args = cli.parse_args()
    main(args.path, args.schema_only, args.dry_run)
```

</details>

<!-- TODO: go, rust, perl -->
