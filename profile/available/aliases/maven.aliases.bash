cite about-alias
about-alias 'maven related aliases'


## Release stuff
alias mvnrprep="mvn release:prepare"
alias mvnrperf="mvn release:perform"
alias mvnrrb="mvn release:rollback"

## Information
alias mvndep="mvn dependency:tree"
alias mvnpom="mvn help:effective-pom"

## Build
alias mvnc='mvn clean'
alias mvneclipse='mvn eclipse:clean eclipse:eclipse'
alias mvni="mvn install"
alias mvnci='mvn clean install'
alias mvnbuild='mvn clean install'

## Fast (no tests) build versions
alias mvnif='mvn install -Dmaven.test.skip=true'
alias mvncif='mvn clean install -Dmaven.test.skip=true'


