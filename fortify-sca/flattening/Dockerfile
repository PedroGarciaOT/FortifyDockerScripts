FROM pedrogarciamf/fortify-sca:imported

ENV FORTIFY_SCA_MAJOR=20.1.0 \
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

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCA_HOME/bin:$ANT_HOME/bin:$MAVEN_HOME/bin:$GRADLE_HOME/bin:$PATH

WORKDIR /ScanCentralWorkdir

USER microfocus

VOLUME "/home/microfocus/.fortify" "/ScanCentralWorkdir" "/tools/maven/repo" "/tools/gradle/home" 

CMD ["startsensor"]
