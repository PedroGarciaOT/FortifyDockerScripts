#!/bin/bash
export FORTIFY_SCA_HOME=/tools/fortify/sca
export JDK8_HOME=/tools/java/jdk-8
export JDK11_HOME=/tools/java/jdk-11
export ANT_HOME=/tools/ant
export MAVEN_HOME=/tools/maven
export MAVEN_USER_HOME=/tools/maven/repo
export GRADLE_HOME=/tools/gradle
export GRADLE_USER_HOME=/tools/gradle/home
export PATH=$FORTIFY_SCA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH
