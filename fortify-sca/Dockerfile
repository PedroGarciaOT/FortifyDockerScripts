FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

RUN ./install.sh

ENV FORTIFY_SCA_MAJOR=19.2.3 \
    FORTIFY_SCA_VERSION=19.2.3.0006 \
    JAVA_MAJOR=8 \
    JAVA_VERSION=1.8.0_241 \
    FORTIFY_SSC_URL=http://fortify-ssc:8080/ssc \
    FORTIFY_SCANCENTRAL_URL=http://fortify-scancentral:8080/cloud-ctrl \
    FORTIFY_HOME=/tools/fortify/sca \
    ANT_HOME=/tools/ant \
    MAVEN_HOME=/tools/maven \
    MAVEN_USER_HOME=/tools/maven/repo \
    GRADLE_HOME=/tools/gradle \
    GRADLE_USER_HOME=/tools/gradle/home \
    ANDROID_HOME=/tools/android \
    JAVA_HOME=/tools/java/jdk-8

ENV PATH=$JAVA_HOME/bin:$FORTIFY_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$PATH

RUN chown -R microfocus:microfocus /tools && chown -R microfocus:microfocus /CloudscanWorkdir

WORKDIR /CloudscanWorkdir

RUN cat /install.log

RUN rm -rf /setup

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/maven/repo" "/tools/gradle/home" "/tools/android/platforms" "/tools/android/build-tools" "/CloudscanWorkdir"

CMD ["startsensor"]

