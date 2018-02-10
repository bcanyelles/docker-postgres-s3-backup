# Postgres to S3 backup

This container backups a postgres database base and pushes the backup to S3.

## Usage

### Backup

```shell
docker run --rm leifg/postgres-s3-backup backup \
  --postgres-host <db_host> \
  --postgres-port 5432 \
  --postgres-user postgres \
  --postgres-password postgres \
  --postgres-db <db-name> \
  --aws-access-key-id <access-key> \
  --aws-secret-access-key <access-secret> \
  --aws-s3-bucket db-backups
```

Backps will be stored in the bucket under the name of the host

### Restore

```shell
docker run --rm leifg/postgres-s3-backup restore \
  --postgres-host <db_host> \
  --postgres-port 5432 \
  --postgres-user postgres \
  --postgres-password postgres \
  --postgres-db <db-name> \
  --aws-access-key-id <access-key> \
  --aws-secret-access-key <access-secret> \
  --aws-s3-bucket db-backups
```

Flags for backup:

- `--skip-cleanup` by default the dump is downloaded, restored and then deleted. For local testing it might be useful to skip the deletion step. If the script finds an existing file it will skip the download and speed up the process
- `--overwrite` usually the script refuses to drop any tables and will stop the restore. Again for local testing it makes sense to overwrite existing data.

## Roadmap

- Encryption
