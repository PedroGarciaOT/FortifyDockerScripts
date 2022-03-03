FROM pedrogarciamf/fortify-centos:8

COPY setup /setup

WORKDIR /setup

RUN chmod a+x *.sh

ENV FORTIFY_SCA_MAJOR=21.2.3 \
    FORTIFY_SSC_URL=http://fortify-ssc:8080/ssc \
    FORTIFY_SCANCENTRAL_URL=http://scancentral-sast:8080/scancentral-ctrl \
    FORTIFY_SCA_HOME=/tools/fortify/sca 

RUN ./install.sh

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCA_HOME/bin:$PATH

RUN chown -R microfocus:microfocus /tools && chown -R microfocus:microfocus /ScanCentralWorkdir

RUN cat install-sca-linux.log

WORKDIR /ScanCentralWorkdir

RUN rm -rf /setup

USER microfocus

VOLUME "/ScanCentralWorkdir" 

CMD ["startsensor"]

