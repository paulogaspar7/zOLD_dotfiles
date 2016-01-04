#!/usr/bin/env bash

cite 'about-alias'
about-alias 'maven abbreviations'


## Release stuff
alias mvnrprep='mvn release:prepare'
alias mvnrperf='mvn release:perform'
alias mvnrrb='mvn release:rollback'

## Information
alias mvndep='mvn dependency:tree'
alias mvnpom='mvn help:effective-pom'

## Build
alias mvnc='mvn clean'
alias mvneclipse='mvn -DdownloadJavadocs=true -DdownloadSources=true eclipse:clean eclipse:eclipse'
alias mvni='mvn install'
alias mvnci='mvn clean install'
alias mvnbuild='mvn clean install'
alias mvnbuild.insec='mvn -Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true clean install'

alias mvnisj='mvn install -Dmaven.test.skip=true -Dfindbugs.skip=true source:jar javadoc:jar'
alias mvncisj='mvn clean install -Dmaven.test.skip=true -Dfindbugs.skip=true source:jar javadoc:jar'

## Fast (no tests) build versions
alias mvnif='mvn install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.source.skip=true -Dfindbugs.skip=true'
alias mvncif='mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.source.skip=true -Dfindbugs.skip=true'
alias mvncifu='mvn -U clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Dmaven.source.skip=true -Dfindbugs.skip=true'

alias mvnvdep='mvn versions:display-dependency-updates'
alias mvnvplugins='mvn versions:display-plugin-updates'
alias mvnvprops='mvn versions:display-property-updates'


