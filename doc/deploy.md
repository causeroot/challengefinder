# Overview
Amazon Beanstalk is a [PaaS](https://en.wikipedia.org/wiki/Cloud_computing#Platform_as_a_service_.28PaaS.29) product, similar to Heroku, that is built on top of Amazon's other [IaaS](https://en.wikipedia.org/wiki/Cloud_computing#Infrastructure_as_a_service_.28IaaS.29) services. Beanstalk provides a higher level of abstraction that is more expressive while still allowing for fine tuning under the hood. Beanstalk is comprised of a set of command line tools and a web interface that orchestrate these high level abstractions. Access to these services is guarded by authentication tokens.

## Required Software

### Xcode 5
Login required [https://developer.apple.com/downloads/index.action](https://developer.apple.com/downloads/index.action). Make sure to install the Command Line tools from _Preferences -> Downloads_.

### java
Install the latest version of java from [https://www.java.com/en/download/index.jsp](https://www.java.com/en/download/index.jsp)

### homebrew
Install homebrew by running: ``ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"``

You can find more information here: [https://github.com/mxcl/homebrew/wiki/Installation](https://github.com/mxcl/homebrew/wiki/Installation)

### AWS Command Line Tools
Run: ``brew update && brew install aws-elasticbeanstalk ec2-api-tools rds-command-line-tools``

### Authentication
Our username for [passpack](https://www.passpack.com/online/) is *CauseRoot*. Login to retreive the password for *ec2.tar.bz2.aes256*. Then from a Terminal window execute:

    cp ~/src/challengefinder/doc/ec2.tar.bz2.aes256 ~/
    cd ~/
    openssl enc -d -aes-256-cbc -in ec2.tar.bz2.aes256 -out ec2.tar.bz2
    tar jxvf ec2.tar.bz2
    ~/.ec2/update_bash_profile.sh
    
Your command line environment is now configured to interact with Amazon Web Services.

## AWS Elastic Beanstalk Command Line Client
A high level tool for interacting with Elastic Beanstalk is called ``eb``. To display information about the current environment execute ``eb status --verbose`` which outputs

    Retrieving status of environment "challengefinder-develop".
    URL	: challengefinder-develop-9n5twwgfee.elasticbeanstalk.com
    Status	: Ready
    Health	: Green
    Environment Name:	challengefinder-develop
    Environment ID:		e-usbpcwccdi
    Solution Stack:		64bit Amazon Linux running Ruby 1.9.3
    Version Label:		git-589cdc94137013605bb55b30a22cff500a97482b-1382076192361
    Date Created:		2013-10-14 22:18:47
    Date Updated:		2013-10-17 23:22:15
    Description:		

    RDS Database: AWSEBRDSDatabase | aa17tlfakil5cub.cumsh0ift78l.us-west-1.rds.amazonaws.com:3306
    Database Engine:	mysql 5.5.33
    Allocated Storage:	5
    Instance Class:		db.t1.micro
    Multi AZ:		False
    Master Username:	ebroot
    Creation Time:		2013-10-14 22:22:21
    DB Instance Status:	available

You can see from the output above that **Environment Name:	challengefinder-develop** which corresponds to the git branch that we are on.

    bonker:challengefinder ephidryn$ git branch
    * develop
      master
    bonker:challengefinder ephidryn$ 

*If ``eb status`` returns Environment "challengefinder-develop" is not running. then you must start it with ``eb start``.

This is a good area to try out changes and deploy them to a real server. To push your changes in your local git develop branch execute: ``git aws.push``

You can monitor deployment progress at <https://aws.amazon.com>

When you are finished with the development environment it is a good idea to stop it to save money. This is done with ``eb stop``.
