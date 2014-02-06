#!/bin/bash -xe
# install the masked password plugin

# application can have many versions
# environments may run a single version of an application

export EC2_REGION=us-west-1
export ELASTICBEANSTALK_URL="https://elasticbeanstalk.us-west-1.amazonaws.com"
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

function create_environments() {
    elastic-beanstalk-describe-environments
    elastic-beanstalk-describe-environments | awk '{ print $20 }' | grep cf-master-test
    if [ $? -ne 0 ]; then
        create_new_env cf-master-test
    fi
  
    elastic-beanstalk-describe-environments | awk '{ print $20 }' | grep cf-master
    if [ $? -ne 0 ]; then
        create_new_env cf-master
    fi
  
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
    --environment-name "$1" \
    --template-name challengefinder-configuration-template
}

function deploy_to_env() {
  git aws.push --environment "$1"
  echo -n "Waiting for environment to start..."
  status=$(elastic-beanstalk-describe-environments | grep "$1 " | awk '{ print $23 }')
  while [ "$status" != "Green" ]; do
    echo "Status = $status. Waiting..."
    status=$(elastic-beanstalk-describe-environments | grep "$1 " | awk '{ print $23 }')
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
      export rdsdir=$(ls -d RDSCli-*)
    fi
    export AWS_RDS_HOME=$(pwd)/$rdsdir
    export PATH=$AWS_RDS_HOME/bin:$PATH
}

function swap_cloudflare_cname() {
    echo "swap_cloudflare_cname() not yet implemented"
    exit 1
}

#create_snapshot_of_master

branch=$(git branch | grep \* | awk '{ print $2 }')
new_env=cf-$branch-$(git rev-parse --short HEAD)

install_cmd_tools

create_environments

create_snapshot_of_master

set -e
deploy_to_env "cf-master-test"
test_new_env "cf-master-test"

deploy_to_env "cf-master"
test_new_env "cf-master"

elastic-beanstalk-terminate-environment --environment-name "cf-master-test"
