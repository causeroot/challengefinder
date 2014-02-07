#!/bin/bash -xle
# install the masked password plugin

# application can have many versions
# environments may run a single version of an application

export EC2_REGION=us-west-1
export EC2_AVAILABILITY_ZONE=us-west-1a
export ELASTICBEANSTALK_URL=https://elasticbeanstalk.us-west-1.amazonaws.com
export EC2_URL=https://ec2.us-west-1.amazonaws.com
export AWS_CREDENTIAL_FILE=~/aws_credentials.txt
echo "AWSAccessKeyId=$AWS_ACCESS_KEY_ID" > $AWS_CREDENTIAL_FILE
echo "AWSSecretKey=$AWS_SECRET_ACCESS_KEY" >> $AWS_CREDENTIAL_FILE
chmod 600 $AWS_CREDENTIAL_FILE

if [ Linux = "$(uname)" ]; then
  
    python --version 2>&1 | grep 3\. && export PATH=$PATH:$(pwd)/AWS-ElasticBeanstalk-CLI-2.6.0/eb/linux/python3
    python --version 2>&1 | grep 2.7 && export PATH=$PATH:$(pwd)/AWS-ElasticBeanstalk-CLI-2.6.0/eb/linux/python2.7
    export JAVA_HOME=/usr/lib/jvm/default-java/jre
elif [ Darwin = "$(uname)" ]; then
    python --version 2>&1 | grep 3\. && export PATH=$PATH:$(pwd)/AWS-ElasticBeanstalk-CLI-2.6.0/eb/macosx/python3
    python --version 2>&1 | grep 2.7 && export PATH=$PATH:$(pwd)/AWS-ElasticBeanstalk-CLI-2.6.0/eb/macosx/python2.7
    export JAVA_HOME=$(/usr/libexec/java_home)
fi

export PATH="$(pwd)/AWS-ElasticBeanstalk-CLI-2.6.0/api/bin":$PATH

function create_snapshot_of_master() {
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

wait_for_env() {
  if [ "$2" ]; then
    wait_minutes=$2
  else
    wait_minutes=10
  fi
  
  elastic-beanstalk-describe-environments | grep -v Terminated | grep "$1 |" | grep Green
  while [ $? -ne 0 ]; do
    if [ $wait_minutes -lt 1 ]; then
      break
    fi
    echo "Not yet green. Waiting $wait_minutes more minutes."
    sleep 60
    wait_minutes=$(expr $wait_minutes - 1)
    elastic-beanstalk-describe-environments | grep "$1 |" | grep Green
  done
}

function create_environment() {
    set +e
    state=$(elastic-beanstalk-describe-environments | grep -v Terminated | grep "$1 |")
    if [ $? -ne 0 ]; then
        create_new_env $1
    else 
      echo "$1 environment already exists. Checking state."
      echo $state | grep Green
      if [ $? -ne 0 ]; then
        echo "$1 is in a Grey state. Waiting 1 minute before recreating it."
        wait_for_env $1 1
        elastic-beanstalk-describe-environments | grep "$1 |" | grep Green
        if [ $? -ne 0 ]; then
          echo "Waited for $1 to turn green. Now attempting to terminate and recreate the environment."
        fi
        terminate_environment $1
        
        if [ "$2" ]; then
          depth=$(expr $depth - 1)
        else
          depth=3
        fi          
        if [ $depth -gt 0 ]; then
          create_environment $1 $depth
        fi
      fi
    fi
    set -e
}

function create_new_env() {
  label=$(git rev-parse HEAD)
  elastic-beanstalk-describe-application-versions --application-name challengefinder \
    --version-label $label | grep $label
  
  if [ $? -ne 0 ]; then 
      elastic-beanstalk-create-application-version --application-name challengefinder \
        --version-label $label \
        --auto-create \
        --description "ChallengeFinder $(date)"
  fi
  elastic-beanstalk-create-environment --application-name challengefinder \
    --version-label $label \
    --environment-name $1 \
    --template-name challengefinder-configuration-template
  
  wait_for_env $1

  elastic-beanstalk-describe-environment-resources --show-json -e $1
  sec_group=$(elastic-beanstalk-describe-environment-resources --show-json -e $1)
  sec_group=$(echo $sec_group | python -mjson.tool | grep -A1 \"AWSEBSecurityGroup\" | grep PhysicalResourceId | awk '{ print $NF }' | sed 's/\"//' | sed 's/\",//')
  add_security_group_to_rds $sec_group
}

function remove_security_group_from_rds() {
  rds-revoke-db-security-group-ingress default --ec2-security-group-name $1 --ec2-security-group-owner-id $AWS_OWNER_ID
}

function add_security_group_to_rds() {
  rds-authorize-db-security-group-ingress default --ec2-security-group-name $1 --ec2-security-group-owner-id $AWS_OWNER_ID
}

function terminate_environment() {
  elastic-beanstalk-describe-environment-resources --show-json -e $1
  sec_group=$(elastic-beanstalk-describe-environment-resources --show-json -e $1)
  sec_group=$(echo $sec_group | python -mjson.tool | grep -A1 \"AWSEBSecurityGroup\" | grep PhysicalResourceId | awk '{ print $NF }' | sed 's/\"//' | sed 's/\",//')
  echo $sec_group
  if [ ! "$sec_group" ]; then
    elastic-beanstalk-describe-environment-resources --show-json -e $1
    echo "Security group is empty."
  else
    remove_security_group_from_rds $sec_group
  fi
  echo "Terminating $1..."
  elastic-beanstalk-terminate-environment --environment-name $1
  sleep 60
  wait_minutes=10
  elastic-beanstalk-describe-environments | grep "$1 |" | grep Terminating
  while [ $? -ne 0 ]; do
    if [ $wait_minutes -lt 1 ]; then
      break
    fi
    echo "Still terminating instance. Waiting $wait_minutes more minutes."
    sleep 60
    wait_minutes=$(expr $wait_minutes - 1)
    elastic-beanstalk-describe-environments | grep "$1 |" | grep Terminating
  done
}

function deploy_to_env() {
  git aws.push --environment $1
  echo -n "Waiting for environment to start..."
  status=$(elastic-beanstalk-describe-environments | grep -v Terminated | grep "$1 " | grep "Green")
  while [ "$status" != "Green" ]; do
    echo "Status = $status. Waiting..."
    status=$(elastic-beanstalk-describe-environments | grep -v Terminated | grep "$1 " | grep "Green")
    sleep 10
  done
}

function test_new_env() {
    cname=$(elastic-beanstalk-describe-environments | grep "$1 " | awk '{ print $5 }')
    count=1
    wget --spider -o wget.log -e robots=off --wait 1 -r -p "http://$cname"
    rc=$?
    while [ $rc -ne 0 -o $count -gt 18 ]; do
        let count++
        echo "Testing new environment $1 from $cname failed with $rc. Sleeping before retry..."
        wget --spider -o wget.log -e robots=off --wait 1 -r -p "http://$cname"
        rc=$?
    done
    cat wget.log
}

function install_cmd_tools() {
  if [ ! -d AWS-ElasticBeanstalk-CLI-2.6.0 ]; then
    wget -c https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.6.0.zip
    unzip AWS-ElasticBeanstalk-CLI-2.6.0.zip
  fi
  if [ ! -d .git/AWSDevTools ]; then
      AWS-ElasticBeanstalk-CLI-2.6.0/AWSDevTools/Linux/AWSDevTools-RepositorySetup.sh    
  fi
  export rdsdir=$(ls -d RDSCli-*)
  if [ ! -d "$rdsdir" ]; then
    wget -c http://s3.amazonaws.com/rds-downloads/RDSCli.zip
    unzip RDSCli.zip
  fi
  export rdsdir=$(ls -d RDSCli-*)
  export AWS_RDS_HOME=$(pwd)/$rdsdir
  export PATH=$AWS_RDS_HOME/bin:$PATH
}

function swap_cloudflare_cname() {
    echo "swap_cloudflare_cname() not yet implemented"
    exit 1
}

#create_snapshot_of_master
new_env=cf-master-$(git rev-parse --short HEAD)

install_cmd_tools

create_environment cf-master
create_environment cf-master-test

create_snapshot_of_master

set -e
deploy_to_env "cf-master-test"
test_new_env "cf-master-test"

deploy_to_env "cf-master"
test_new_env "cf-master"

terminate_environment "cf-master-test"
