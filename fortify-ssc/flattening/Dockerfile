FROM pedrogarciamf/fortify-ssc:imported

ENV FORTIFY_SSC_MAJOR=20.1.0 \
    FORTIFY_SCA_MAJOR=20.1.0 \
    FORTIFY_WEBINSPECT_MAJOR=20.1.0 \
    JAVA_MAJOR=8 \
    TOMCAT_MAJOR=9 \
    FORTIFY_SSC_HOME=/tools/fortify \
    FORTIFY_SSC_SEARCH_INDEX=/tools/fortify/search-index \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-8 

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SSC_HOME/bin:$CATALINA_HOME/bin:$PATH

EXPOSE 8080

WORKDIR $FORTIFY_SSC_HOME

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" "/tools/fortify/search-index" 

CMD [ "catalina.sh", "run" ]
