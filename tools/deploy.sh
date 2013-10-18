rds_instance=$(eb status | grep RDS\ Database | awk '{ print $NF }' | awk 'BEGIN { FS = "." } ; { print $1 }')

