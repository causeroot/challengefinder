rds_instance=$(eb status | grep RDS\ Database | awk '{ print $NF }' | awk 'BEGIN { FS = "." } ; { print $1 }')
echo "Creating snapshot for $rds_instance"
rds-create-db-snapshot -i $rds_instance -s snapshot$(date +%s)
