# Overview
Amazon Beanstalk is a [PaaS](https://en.wikipedia.org/wiki/Cloud_computing#Platform_as_a_service_.28PaaS.29) product, similar to Heroku, that is built on top of Amazon's other [IaaS](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29) services. Beanstalk provides a higher level of abstraction that is more expressive while still allowing for fine tuning under the hood. Beanstalk is comprised of a set of command line tools and a web interface that orchestrate these high level abstractions. Access to these services is guarded by authentication tokens.

## Required Software
Please refer to the next section when prompted for authentication information while following instructions to download software here: http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/usingCLI.html
Specifically, unzip the linked file from [here](https://aws.amazon.com/code/AWS-Elastic-Beanstalk/6752709412171743) and add this to your ~/.bash_profile

## Authentication
Access to the (web interface)[https://console.aws.amazon.com/console/home] is guarded by a username-password combination that is stored in (passpack)[https://www.passpack.com/online/] under the case-sensitive username "CauseRoot" and a secret password. The passpack entry is named "Amazon Web Services".
The api tokens required for command line configuration can be accessed (here)[http://docs.aws.amazon.com/general/latest/gr/getting-aws-sec-creds.html].

Our *ELASTICBEANSTALK_URL* is https://elasticbeanstalk.us-west-1.amazonaws.com

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
