FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

ENV FORTIFY_SCANCENTRAL_MAJOR=20.2.0 \
    JAVA_MAJOR=8 \
    FORTIFY_SCANCENTRAL_HOME=/tools/fortify \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-8

RUN ./install.sh

ENV PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$FORTIFY_SCANCENTRAL_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools 

WORKDIR $FORTIFY_SCANCENTRAL_HOME

RUN cat /install.log

RUN rm -rf /setup

EXPOSE 8080

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs"  

CMD [ "catalina.sh", "run" ]
