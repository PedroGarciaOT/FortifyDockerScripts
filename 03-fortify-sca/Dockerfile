FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

ENV FORTIFY_SCA_MAJOR=20.2.2 \
    JAVA_MAJOR=8 \
    FORTIFY_SSC_URL=http://fortify-ssc:8080/ssc \
    FORTIFY_SCANCENTRAL_URL=http://fortify-scancentral:8080/scancentral-ctrl \
    FORTIFY_SCA_HOME=/tools/fortify/sca \
    ANT_HOME=/tools/ant \
    MAVEN_HOME=/tools/maven \
    MAVEN_USER_HOME=/tools/maven/repo \
    GRADLE_HOME=/tools/gradle \
    GRADLE_USER_HOME=/tools/gradle/home \
    JAVA_HOME=/tools/java/jdk-8

RUN ./install.sh

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools && chown -R microfocus:microfocus /ScanCentralWorkdir

WORKDIR /ScanCentralWorkdir

RUN cat /install.log

RUN rm -rf /setup

USER microfocus

VOLUME "/home/microfocus/.fortify" "/ScanCentralWorkdir" "/tools/maven/repo" "/tools/gradle/home" 

CMD ["startsensor"]

