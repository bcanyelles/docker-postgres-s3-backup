#!/bin/sh

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    --aws-access-key-id)
    AWS_ACCESS_KEY_ID="$2"
    shift
    ;;
    --aws-secret-access-key)
    AWS_SECRET_ACCESS_KEY="$2"
    shift
    ;;
    --aws-s3-bucket)
    AWS_S3_BUCKET="$2"
    shift
    ;;
    --postgres-host)
    POSTGRES_HOST="$2"
    shift
    ;;
    --postgres-user)
    POSTGRES_USER="$2"
    shift
    ;;
    --postgres-port)
    POSTGRES_PORT="$2"
    shift
    ;;
    --postgres-db)
    POSTGRES_DB="$2"
    shift
    ;;
    --postgres-password)
    POSTGRES_PASSWORD="$2"
    shift
    ;;
    *)
    ;;
esac
shift # past argument or value
done

cat <<EOT >> ~/.pgpass
# hostname:port:database:username:password
*:*:*:${POSTGRES_USER}:${POSTGRES_PASSWORD}
EOT

chmod 0600 ~/.pgpass

mkdir -p ~/.aws

cat <<EOT >> ~/.aws/credentials
[default]
aws_access_key_id=${AWS_ACCESS_KEY_ID}
aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}
EOT

echo "backing up ${POSTGRES_DB} on ${POSTGRES_HOST}:${POSTGRES_PORT}"

base_dump_filename=${POSTGRES_DB}_backup
dump_extenstion=sqlc
timestamp=`date "+%Y-%m-%dT%H-%M-%S"`
current_dump_filename=${base_dump_filename}_${timestamp}.${dump_extenstion}
latest_dump_filename=${base_dump_filename}_latest.${dump_extenstion}

pg_dump -Fc -U ${POSTGRES_USER} -h ${POSTGRES_HOST} -p ${POSTGRES_PORT} ${POSTGRES_DB} > ${current_dump_filename}

aws s3 cp ${current_dump_filename} s3://${AWS_S3_BUCKET}/${POSTGRES_HOST}/${current_dump_filename}
aws s3 cp s3://${AWS_S3_BUCKET}/${POSTGRES_HOST}/${current_dump_filename} s3://${AWS_S3_BUCKET}/${POSTGRES_HOST}/${latest_dump_filename}

echo "Backup finished, cleaning up"

rm -f ~/.pgpass
rm -f ~/.aws/credentials
