FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

RUN ./install.sh

ENV FORTIFY_SCANCENTRAL_MAJOR=19.2.1 \
    JAVA_MAJOR=8 \
    JAVA_VERSION=1.8.0_241 \
    FORTIFY_HOME=/tools/fortify \
    FORTIFY_SCANCENTRAL_HOME=/tools/fortify \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-8

ENV PATH=$JAVA_HOME/bin:$CATALINA_HOME/bin:$FORTIFY_SCANCENTRAL_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools && chown -R microfocus:microfocus /CloudscanWorkdir

WORKDIR $FORTIFY_SCANCENTRAL_HOME

RUN cat /install.log

RUN rm -rf /setup

EXPOSE 8080

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" "/CloudscanWorkdir"  

CMD [ "catalina.sh", "run" ]
