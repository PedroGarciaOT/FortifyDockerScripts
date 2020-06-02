FROM pedrogarciamf/fortify-scancentral:imported

ENV FORTIFY_SCANCENTRAL_MAJOR=20.1.0 \
    JAVA_MAJOR=8 \
    FORTIFY_SCANCENTRAL_HOME=/tools/fortify \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-8 

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCANCENTRAL_HOME/bin:$CATALINA_HOME/bin:$PATH

EXPOSE 8080

WORKDIR $FORTIFY_SCANCENTRAL_HOME

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" 

CMD [ "catalina.sh", "run" ]
