# Overview
Amazon Beanstalk is a [PaaS](https://en.wikipedia.org/wiki/Cloud_computing#Platform_as_a_service_.28PaaS.29) product, similar to Heroku, that is built on top of Amazon's other [IaaS](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29) services. Beanstalk provides a higher level of abstraction that is more expressive while still allowing for fine tuning under the hood. Beanstalk is comprised of a set of command line tools and a web interface that orchestrate these high level abstractions. Access to these services is guarded by authentication tokens.

## Required Software

### java
Install the latest version of java from [https://www.java.com/en/download/index.jsp](https://www.java.com/en/download/index.jsp)

### homebrew
Install homebrew by running: ``ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"``

You can find more information here: [https://github.com/mxcl/homebrew/wiki/Installation](https://github.com/mxcl/homebrew/wiki/Installation)

### AWS Command Line Tools
Run: ``brew update && brew install aws-elasticbeanstalk ec2-api-tools rds-command-line-tools``

### Authentication
Our username for [passpack](https://www.passpack.com/online/) is *CauseRoot*. Login to retreive the password for *ec2.tar.bz2.aes256*. Then from a Terminal window execute:

    cp ~/src/challengefinder/doc/ec2.tar.bz2 ~/
    cd ~/
    openssl enc -d -aes-256-cbc -in ec2.tar.bz2.aes256 -out ec2.tar.bz2
    tar jxvf ec2.tar.bz2
    ~/.ec2/update_bash_profile.sh

## After configuration ~/challengefinder/.elasticbeanstalk/config 
    bonker:challengefinder USERNAME$ cat .elasticbeanstalk/config 
    [global]
    ApplicationName=challengefinder
    ApplicationVersionName=git-57bcf1f2a80af6c98a2ea7e9e7832478cf6fa013-1379484532333
    AwsCredentialFile=/Users/USERNAME/.elasticbeanstalk/aws_credential_file
    DevToolsEndpoint=git.elasticbeanstalk.us-west-1.amazonaws.com
    EnvironmentName=challengefinder-env
    EnvironmentType=SingleInstance
    InstanceProfileName=aws-elasticbeanstalk-ec2-role
    OptionSettingFile=/Users/USERNAME/src/challengefinder/.elasticbeanstalk/optionsettings.challengefinder-env
    RdsDeletionPolicy=Snapshot
    RdsEnabled=Yes
    RdsSourceSnapshotName=
    Region=us-west-1
    ServiceEndpoint=https://elasticbeanstalk.us-west-1.amazonaws.com
    SolutionStack=64bit Amazon Linux running Ruby 1.9.3

## Solr extra step
Amazon offers their own indexing service that rivals Solr. Interestingly, Solr is not deployed correctly during the elastic beanstalk process. To enable Solr an additional step is required. We should figure out how to automate this but for now it is an additional manual step.

    ssh -i ~/Downloads/beanstalk.pem ec2-user@ec2-54-241-30-66.us-west-1.compute.amazonaws.com
    sudo killall java
    cd /var/app/current/
    bundle install
    bundle exec rake db:migrate
    bundle exec rake sunspot:solr:start
    bundle exec rake assets:precompile
    bundle exec rake db:seed
