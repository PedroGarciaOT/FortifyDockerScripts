FROM pedrogarciamf/fortify-scancentral-sast:imported

ENV FORTIFY_SCANCENTRAL_MAJOR=21.1.0 \
    JAVA_MAJOR=11 \
    FORTIFY_SCANCENTRAL_HOME=/tools/fortify \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-11

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCANCENTRAL_HOME/bin:$CATALINA_HOME/bin:$PATH

EXPOSE 8080 8443

WORKDIR $FORTIFY_SCANCENTRAL_HOME

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" 

CMD [ "catalina.sh", "run" ]
