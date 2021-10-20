FROM pedrogarciamf/fortify-sca:imported

ENV FORTIFY_SCA_MAJOR=21.1.2 \
    FORTIFY_SSC_URL=http://fortify-ssc:8080/ssc \
    FORTIFY_SCANCENTRAL_URL=http://scancentral-sast:8080/scancentral-ctrl \
    FORTIFY_SCA_HOME=/tools/fortify/sca 

ENV PATH=$JAVA_HOME/bin:$FORTIFY_SCA_HOME/bin:$PATH

WORKDIR /ScanCentralWorkdir

USER microfocus

VOLUME "/home/microfocus/.fortify" "/ScanCentralWorkdir" 

CMD ["startsensor"]
