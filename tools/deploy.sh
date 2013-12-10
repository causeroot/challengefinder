# application can have many versions
# environments may run a single version of an application

export EC2_REGION=us-west-1

function create_snapshot_of_master() {}
  rds_instance=$(rds-describe-db-instances | grep DBINSTANCE | awk '{ print $2 }')
  echo "Creating snapshot for $rds_instance"
  rds-create-db-snapshot -i $rds_instance -s snapshot$(date +%s)
}

function create_config_template() {
  elastic-beanstalk-create-configuration-template --application-name challengefinder \
    --template-name challengefinder-configuration-template \
    --description "Default configuration template for a challegnefinder instance." \
    --solution-stack "64bit Amazon Linux running Ruby 1.9.3" \
    --options-file tools/options.json
}

function create_new_env() {
  elastic-beanstalk-create-environment --application-name challengefinder \
    --version-label $(git rev-parse HEAD) \
    --environment-name challengefinder-master-$(git rev-parse --short HEAD) \
    --template-name challengefinder-configuration-template
}

function create_master_database() {
  rds-create-db-instance --db-instance-identifier challengefinder-rds \
    
}

git aws.push --environment challengefinder-master
