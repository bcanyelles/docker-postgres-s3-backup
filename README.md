# Postgres to S3 backup

This container backups a postgres database base and pushes the backup to S3.

## Usage

```shell
docker run --rm leifg/postgres-s3-backup
  --postgres-host db_host \
  --postgres-port 5432 \
  --postgres-user postgres \
  --postgres-password postgres \
  --postgres-db db_name \
  --aws-access-key-id access-key \
  --aws-secret-access-key access-secret \
  --aws-s3-bucket db-backups
```

Backps will be stored in the bucket under the name of the host


## Roadmap

- Restore
- Encryption
