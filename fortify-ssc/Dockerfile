FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

RUN ./install.sh

ENV FORTIFY_SSC_MAJOR=19.2.1 \
    FORTIFY_SSC_VERSION=19.2.1.3007 \
    FORTIFY_SCA_MAJOR=19.2.3 \
    FORTIFY_SCA_VERSION=19.2.3.0006 \
    FORTIFY_WEBINSPECT_MAJOR=19.2.0 \
    JAVA_MAJOR=8 \
    JAVA_VERSION=1.8.0_241 \
    TOMCAT_MAJOR=9 \
    TOMCAT_VERSION=9.0.31 \
    FORTIFY_HOME=/tools/fortify \
    FORTIFY_SSC_HOME=/tools/fortify \
    FORTIFY_SSC_SEARCH_INDEX=/tools/fortify/search-index \
    CATALINA_HOME=/tools/fortify/tomcat \
    JAVA_HOME=/tools/java/jdk-8 

#    FORTIFY_SSC_VERSION=19.2.1.XXXX \
#    FORTIFY_WEBINSPECT_VERSION=19.2.0.XXXX \

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SSC_HOME/bin:$CATALINA_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools

RUN cat /install.log

WORKDIR $FORTIFY_SSC_HOME

RUN rm -rf /setup

EXPOSE 8080

USER microfocus

VOLUME "/home/microfocus/.fortify" "/tools/fortify/tomcat/logs" "/tools/fortify/search-index" 

CMD [ "catalina.sh", "run" ]
