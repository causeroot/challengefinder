Prerequisites
===
Install Xcode command line tools

Install latest java
https://www.java.com/en/download/index.jsp

Install homebrew: https://github.com/mxcl/homebrew/wiki/Installation
``ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"``

Install ec2 api tools
``brew install ec2-api-tools``
Add the following variables to your .bash_profile:

    export JAVA_HOME="$(/usr/libexec/java_home)"
    export EC2_HOME="/usr/local/Library/LinkedKegs/ec2-api-tools/jars"
    export AWS_ACCESS_KEY=see passpack for value under (Amazon Access Keys)
    export AWS_SECRET_KEY=see passpack for value under (Amazon Access Keys)
    export EC2_URL=https://ec2.us-west-1.amazonaws.com





