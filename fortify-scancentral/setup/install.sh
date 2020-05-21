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
export FORTIFY_MAJOR=19.2.0
export FORTIFY_SCANCENTRAL_MAJOR=19.2.1

# Tomcat native lib
export TOMCAT_NATIVE_LIBDIR=${CATALINA_HOME}/native-jni-lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

function install { 
    DEBUG="true"

    echo "*** Starting Installation " 
    FILE_SCANCENTRAL=Fortify_CloudScan_Controller_${FORTIFY_SCANCENTRAL_MAJOR}.zip
    FILE_SCANCENTRAL_CONTROLLER=Fortify_CloudScan_Controller_${FORTIFY_SCANCENTRAL_MAJOR}_x64.zip
    FILE_SCANCENTRAL_CONFIG=${FORTIFY_SCANCENTRAL_MAJOR}-config.properties


    if [ $DEBUG = "true" ]; then
        echo "          "
        echo "********************************************************************************"
        echo "FILE_SCANCENTRAL=${FILE_SCANCENTRAL}"
        echo "FILE_SCANCENTRAL_CONTROLLER=${FILE_SCANCENTRAL_CONTROLLER}"
        echo "FILE_SCANCENTRAL_CONFIG=${FILE_SCANCENTRAL_CONFIG}"
        echo "FORTIFY_SCANCENTRAL_HOME=${FORTIFY_SCANCENTRAL_HOME}"
        echo "CATALINA_HOME=${CATALINA_HOME}"
        echo "********************************************************************************"
        echo "          "
    fi

    mkdir -p ${FORTIFY_SCANCENTRAL_HOME}/
    mkdir /CloudscanWorkdir/
    mkdir -p /home/microfocus/.fortify/
    mkdir -p work/scancentral/

    if [ -f "FortifyInstallers/${FILE_SCANCENTRAL}" ]; then 
        echo "*** Unziping FortifyInstallers/${FILE_SCANCENTRAL} to work/scancentral/ "
        unzip -qq FortifyInstallers/${FILE_SCANCENTRAL} -d work/scancentral/
    else 
        echo "*** Moving FortifyInstallers/${FILE_SCANCENTRAL_CONTROLLER} to work/scancentral/ "
        mv FortifyInstallers/${FILE_SCANCENTRAL_CONTROLLER} work/scancentral/
    fi 
    echo "*** Unziping work/scancentral/${FILE_SCANCENTRAL_CONTROLLER} to ${FORTIFY_SCANCENTRAL_HOME}/ "
    unzip -qq work/scancentral/${FILE_SCANCENTRAL_CONTROLLER} -d ${FORTIFY_SCANCENTRAL_HOME}/
    
    mv ${CATALINA_HOME}/webapps/cloud-ctrl/WEB-INF/classes/config.properties ${CATALINA_HOME}/webapps/cloud-ctrl/WEB-INF/classes/config.bkp

    mv ${FILE_SCANCENTRAL_CONFIG} ${CATALINA_HOME}/webapps/cloud-ctrl/WEB-INF/classes/config.properties

    cp ${FORTIFY_SCANCENTRAL_HOME}/cloudscan.zip ${CATALINA_HOME}/webapps/cloud-ctrl/

    mv ${CATALINA_HOME}/webapps/cloud-ctrl/index.html ${CATALINA_HOME}/webapps/cloud-ctrl/controller.html

    mv index.html ${CATALINA_HOME}/webapps/cloud-ctrl/

    mv setenv.sh ${CATALINA_HOME}/bin

    rm ${CATALINA_HOME}/bin/*.bat

    chmod a+x ${FORTIFY_SCANCENTRAL_HOME}/bin/pwtool
    chmod a+x ${CATALINA_HOME}/bin/*.sh
    
    chown -R microfocus:microfocus /home/microfocus/.fortify/
    chown -R microfocus:microfocus ${FORTIFY_SCANCENTRAL_HOME}/
    chown -R microfocus:microfocus /CloudscanWorkdir/
    chown -R microfocus:microfocus /tools
    
    echo "*** Preparing to build Tomcat native libraries *" 
    yum -y install apr-devel gcc make openssl-devel

    echo "*** Building Tomcat native libraries *" 
    cd ${TOMCAT_NATIVE_LIBDIR}/native
    ./configure --with-apr=/usr/bin/apr-1-config --with-java-home=${JAVA_HOME} --with-ssl=yes --prefix=${CATALINA_HOME}
    make && make install
    
    echo "*** Removing unnecessary content "  
    yum clean all

    echo "*** Finalizing installation " 
}

install > /install.log
