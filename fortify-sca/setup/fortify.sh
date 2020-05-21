#!/bin/bash
export FORTIFY_HOME=/tools/fortify/sca
export JDK8_HOME=/tools/java/jdk-8
export JDK11_HOME=/tools/java/jdk-11
export ANT_HOME=/tools/ant
export MAVEN_HOME=/tools/maven
export MAVEN_USER_HOME=/tools/maven/repo
export GRADLE_HOME=/tools/gradle
export GRADLE_USER_HOME=/tools/gradle/home
export ANDROID_HOME=/tools/android
export PATH=$FORTIFY_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH
