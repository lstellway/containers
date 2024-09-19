# Backup MySQL Database(s) to S3 Bucket

## Environment Variables

-   `BACKUP_DATABASES`
    -   Comma-separated list of database names to backup.<br />
        _(User must have access to specified database)_
-   `DB_USER`
    -   Database user
-   `DB_PASS`
    -   Database password
-   `DB_PASS_FILE`
    -   Secret file containing database password
-   `DB_HOST` _(Default: `localhost`)_
    -   Database host
-   `DB_PORT` _(Default: `3306`)_
    -   Database port
-   `DB_SSL` _(Default: No)_
    -   Determines whether the `mysql` client initializes an encrypted connection.
-   `S3_PROTOCOL` _(Default: `https`)_
    -   Protocol used to connect to S3 server
-   `S3_REGION` _(Default: `us-east-1`)_
    -   S3 server region
-   `S3_BUCKET_PATH`
    -   S3 path where to store backup files
-   `S3_LATEST_FILE_PATH`
    -   S3 path where to store latest backup
-   `S3_ENDPOINT_URL`
    -   S3 endpoint
-   `S3_ACCESS_KEY`
    -   S3 access key
-   `S3_ACCESS_KEY_FILE`
    -   Path to file containing S3 access key
-   `S3_ACCESS_SECRET`
    -   S3 access secret
-   `S3_ACCESS_SECRET_FILE`
    -   Path to file containing S3 access secret

## Recommendations

**MySQL User**

It is recommended to create a MySQL user that only has read permissions on your databases to backup.

```mysql
CREATE USER '{{DB_USER}}'@'%' IDENTIFIED BY '{{DB_PASS}}';
GRANT LOCK TABLES, SELECT ON {{DB_NAME}}.* TO '{{DB_USER}}'@'%';
```

## GitHub Actions

You can use this container in a GitHub action to backup a database<br />
_(note: the server host must be accessible via the GitHub action environment)_

```yml
name: Backup MySQL Databases

on:
    workflow_dispatch:
    schedule:
        - cron: "0 2 * * *"

jobs:
    backup:
        runs-on: ubuntu-latest
        container:
            image: ghcr.io/lstellway/backup-mysql-s3:0.1.0
            env:
                DB_HOST: ${{ secrets.DB_HOST }}
                DB_PORT: ${{ secrets.DB_PORT }}
                DB_PASS: ${{ secrets.DB_PASS }}
                DB_USER: ${{ secrets.DB_USER }}
                DB_SSL: "true"
                BACKUP_DATABASES: database_name,another_name
                S3_BUCKET_PATH: s3://backups/db/{year}/{month}
                S3_LATEST_FILE_PATH: s3://backups/db/latest.tar.gz
                S3_ENDPOINT_URL: https://example.s3provider.com
                AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
                AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
                AWS_DEFAULT_REGION: region
            options: --cpus 1 --entrypoint "tail -f /dev/null"
        steps:
            - name: Execute backup script
              run: |
                  /etc/periodic/daily/backup
```
