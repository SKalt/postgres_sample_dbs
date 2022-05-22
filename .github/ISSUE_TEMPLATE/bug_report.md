---
name: Bug report
about: Flag a problem that prevents your use of any of the sample DBs
title: ''
labels: bug
assignees: ''

---

**Describe the bug**
A clear and concise description of what the bug is.

**Expected behavior**
A clear and concise description of what you expected to happen.

**To Reproduce**

```sh
#!/usr/bin/env bash
# TODO: write a script to reproduce the bug here
```

**What have you tried so far to resolve this bug? What were the results?**


**Diagnostics (please paste the results of the following script):**
```sh
#!/usr/bin/env sh
log_version() { echo "$1: $($1 --version 2>&1)"; }
log_version git
log_version make
log_version docker
log_version psql
log_version pg_restore
log_version docker-compose
```
```
# paste output here
```

**Additional context**
Add any other context about the problem here.
