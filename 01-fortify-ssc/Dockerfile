FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

ENV FORTIFY_SSC_MAJOR=20.2.2 \
    FORTIFY_SCA_MAJOR=20.2.2 \
    FORTIFY_WEBINSPECT_MAJOR=20.2.0 \
    JAVA_MAJOR=11 \
    TOMCAT_MAJOR=9 \
    FORTIFY_SSC_HOME=/tools/fortify \
    FORTIFY_SSC_HOME=/tools/fortify \
    FORTIFY_SSC_SEARCH_INDEX=/tools/fortify/search-index \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-11 

RUN ./install.sh

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SSC_HOME/bin:$CATALINA_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools

RUN cat /install.log

WORKDIR $FORTIFY_SSC_HOME

RUN rm -rf /setup

EXPOSE 8080

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" "/tools/fortify/search-index" 

CMD [ "catalina.sh", "run" ]
