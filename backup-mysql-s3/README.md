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
