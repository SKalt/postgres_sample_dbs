# Postgres Sample Dbs

A collection of postgres sample dbs in a standardized format.

## Directory structure

Each checked-in sample db in the ./sample_dbs directory

```
${db_name}
├── ddl/*.sql
├── dml/*.sql{,.gz} # optional
├── README*   # optional
└── LICENSE*
```

Note that files

- some dml files >5MB are gzipped (the files matching `dml/*.sql.gz`).
- After decompressing any data-files, all files in the sample directory should be able to run in asciibetical order: `${db_name}/**/*.sql`.

## Licensing

Each of the sample databases contains its own license file(s).

The code to extract, transform, and load the sample databases is licensed as MIT in ./LICENSE.md
