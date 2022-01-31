#!/bin/sh
echo "*** Working folder: '$(pwd)''" 
echo "*** Who am I? '$(whoami)'" 

echo "/setup" 
ls -alF /setup 
echo "          "

echo "/setup/FortifyInstallers" 
ls -alF /setup/FortifyInstallers  
echo "          "

echo "*** Customizing profile.d " 
# Set system wide variables
mv fortify.sh /etc/profile.d/
source /etc/profile.d/fortify.sh

echo "*** Environment Variables " 
# Tomcat native lib
export TOMCAT_NATIVE_LIBDIR=${CATALINA_HOME}/native-jni-lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

function InstallSCSAST { 
    echo "################################################################################"
    echo "################################################################################"
    echo "#          "
    echo "#          Intall Fortify ScanCentral SAST " 
    echo "#          "
    echo "################################################################################"
    echo "################################################################################"

    DEBUG="true"

    mkdir -p ${FORTIFY_SCANCENTRAL_HOME}/
    mkdir -p /home/microfocus/.fortify/
    mkdir -p work/scancentral/
    mkdir -p ${TOMCAT_NATIVE_LIBDIR}/

    unzip -qq FortifyInstallers/Fortify_ScanCentral_Controller_Latest_x64.zip -d ${FORTIFY_SCANCENTRAL_HOME}/
    
    mv ${CATALINA_HOME}/conf/server.xml ${CATALINA_HOME}/conf/server_xml.bkp
    #mv ${CATALINA_HOME}/conf/web.xml ${CATALINA_HOME}/conf/web_xml.bkp
    
    mv server.xml ${CATALINA_HOME}/conf/server.xml
    #mv web.xml ${CATALINA_HOME}/conf/web.xml

    mv ${CATALINA_HOME}/webapps/scancentral-ctrl/WEB-INF/classes/config.properties ${CATALINA_HOME}/webapps/scancentral-ctrl/WEB-INF/classes/config.bkp

    mv config.properties ${CATALINA_HOME}/webapps/scancentral-ctrl/WEB-INF/classes/config.properties

    mv config.properties ${CATALINA_HOME}/webapps/scancentral-ctrl/

    #mv ${CATALINA_HOME}/webapps/scancentral-ctrl/index.html ${CATALINA_HOME}/webapps/scancentral-ctrl/about.html
    #mv index.html ${CATALINA_HOME}/webapps/scancentral-ctrl/index.html

    mv setenv.sh ${CATALINA_HOME}/bin

    rm -rf ${CATALINA_HOME}/bin/*.bat
    rm -rf ${CATALINA_HOME}/bin/*.dll
    rm -rf ${CATALINA_HOME}/bin/*.exe
    rm -rf ${FORTIFY_SCANCENTRAL_HOME}/bin/*.bat

    chmod a+x ${FORTIFY_SCANCENTRAL_HOME}/bin/pwtool
    chmod a+x ${CATALINA_HOME}/bin/*.sh
    
    chown -R microfocus:microfocus /home/microfocus/.fortify/
    chown -R microfocus:microfocus ${FORTIFY_SCANCENTRAL_HOME}/
    chown -R microfocus:microfocus /tools

    cp FortifyInstallers/tomcat-native-latest.tar.gz ${CATALINA_HOME}/bin/tomcat-native.tar.gz

    echo "*** Setting Tomcat native libraries " 
    cd ${CATALINA_HOME}/bin
    tar -pxzf tomcat-native.tar.gz -C ${TOMCAT_NATIVE_LIBDIR} --strip-components=1 && rm -rf tomcat-native.tar.gz

    echo "*** Preparing to build Tomcat native libraries *" 
    yum -y install apr-devel gcc make openssl-devel

    echo "*** Building Tomcat native libraries *" 
    cd ${TOMCAT_NATIVE_LIBDIR}/native
    ./configure --with-apr=/usr/bin/apr-1-config --with-java-home=${JAVA_HOME} --with-ssl=yes --prefix=${CATALINA_HOME}
    make && make install
    
    echo "*** Removing unnecessary content "  
    yum clean all

    echo "################################################################################"
    echo "################################################################################"
    echo "#          "
    echo "#          Finalizing Fortify ScanCentral SAST " 
    echo "#          "
    echo "################################################################################"
    echo "################################################################################"
}

InstallSCSAST > ./install-scancentral-sast.log
