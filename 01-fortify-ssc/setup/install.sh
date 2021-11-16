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

function install { 
    DEBUG="true"

    echo "*** Starting Installation " 

    # Create folders defined in fortify.sh
    mkdir -p ${FORTIFY_SSC_HOME}/
    mkdir -p $FORTIFY_SSC_SEARCH_INDEX/
    
    # Create fortify config folder in user home folder
    mkdir -p /home/microfocus/.fortify/

    echo "*** Unziping Fortify_Latest_Server_WAR_Tomcat.zip to ${FORTIFY_SSC_HOME} " 
    unzip -qq FortifyInstallers/Fortify_Latest_Server_WAR_Tomcat.zip -d ${FORTIFY_SSC_HOME}

    # Create update-site
    echo "*** Looking for ssc.war " 
    mkdir -p ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/
    mkdir -p ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/

    # Extract SSC to the Tomcat webapps folder
    echo "*** Unziping ${FORTIFY_SSC_HOME}/ssc.war to ${CATALINA_HOME}/webapps/ssc/ "
    unzip -qq ${FORTIFY_SSC_HOME}/ssc.war -d ${CATALINA_HOME}/webapps/ssc/

    # Setup Tomcat
    mkdir -p ${TOMCAT_NATIVE_LIBDIR}/
    # Extract Tomcat
    tar -pxzf FortifyInstallers/apache-tomcat-latest.tar.gz -C ${CATALINA_HOME}/ --strip-components=1

    mv ${CATALINA_HOME}/conf/server.xml ${CATALINA_HOME}/conf/server_xml.bkp
    #mv ${CATALINA_HOME}/conf/web.xml ${CATALINA_HOME}/conf/web_xml.bkp
    
    mv server.xml ${CATALINA_HOME}/conf/server.xml
    #mv web.xml ${CATALINA_HOME}/conf/web.xml

    # Creating Download Site
    echo "*** Customizing SSC - Downloads " 
    mv downloads.jsp ${CATALINA_HOME}/webapps/ssc/downloads/index.jsp

    mkdir -p ${CATALINA_HOME}/webapps/ssc/get-license/
    mv get-license.jps ${CATALINA_HOME}/webapps/ssc/get-license/index.jsp

    # Source And Lib Scanner  
    mv FortifyInstallers/SourceAndLibScanner_Latest_x64.zip ${CATALINA_HOME}/webapps/ssc/downloads/SourceAndLibScanner_Latest_x64.zip
    # SCA Linux 
    mv fortify_sca_unattended_linux.options ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_Linux_Latest_x64.run.options
    mv FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_Linux_Latest_x64.run

    # SCA MacOSX
    mv fortify_sca_unattended_osx.options ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_OSX_Latest_x64.app.zip.options
    mv FortifyInstallers/Fortify_SCA_OSX_Latest_x64.app.zip ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_OSX_Latest_x64.app.zip

    # SCA Windows
    mv fortify_sca_unattended_windows.options ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_Windows_Latest_x64.exe.options
    mv FortifyInstallers/Fortify_SCA_Windows_Latest_x64.exe ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_SCA_Windows_Latest_x64.exe
    
    # ScanCentral Client
    mv client.properties ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_ScanCentral_Client.properties
    mv worker.properties ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_ScanCentral_Sensor.properties
    mv scancentral.properties ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_ScanCentral.properties

    mv FortifyInstallers/Fortify_ScanCentral_Client_Latest_x64.zip ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_ScanCentral_Client_Latest_x64.zip
    mv FortifyInstallers/fortify.license ${CATALINA_HOME}/webapps/ssc/downloads/fortify.license
    mv FortifyInstallers/birt-report-designer.zip ${CATALINA_HOME}/webapps/ssc/downloads/birt-report-designer.zip
    mv FortifyInstallers/Fortify_IntelliJ_Remediation_Plugin_Latest.zip ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_IntelliJ_Remediation_Plugin_Latest.zip

    mv FortifyInstallers/WebInspect_64_Latest.zip ${CATALINA_HOME}/webapps/ssc/downloads/WebInspect_Latest_x64.zip
    mv FortifyInstallers/SecurityToolkit_Latest.zip ${CATALINA_HOME}/webapps/ssc/downloads/SecurityToolkit_Latest.zip
    mv FortifyInstallers/WebInspectAgent_Latest.zip ${CATALINA_HOME}/webapps/ssc/downloads/WebInspectAgent_Latest.zip

    # Creating Update Site
    unzip -qq FortifyInstallers/Fortify_Eclipse_Remediation_Plugin_Latest.zip -d ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/
    cp eclipse-update.jsp ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/index.jsp

    unzip -qq FortifyInstallers/Fortify_SecurityAssistant_Eclipse_Plugin_Latest.zip -d ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/
    cp eclipse-update.jsp ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/index.jsp

    echo "*** Creating ${CATALINA_HOME}/webapps/ssc/update-site/installers/update.xml "  
    mv update.xml ${CATALINA_HOME}/webapps/ssc/update-site/installers/update.xml
    mv sca-update.jsp ${CATALINA_HOME}/webapps/ssc/update-site/installers/index.jsp

    if [ -f "FortifyInstallers/maven-plugin-bin.tar.gz" ]; then
        echo "Extracting SCA Maven Plugin Documentation"
        mkdir -p work/sca-maven-plugin
        tar -pxzf FortifyInstallers/maven-plugin-bin.tar.gz -C work/sca-maven-plugin/ 
        mv work/sca-maven-plugin/docs ${CATALINA_HOME}/webapps/fortify-sca-maven-plugin
    fi

    echo "*** Customizing SSC - Internal " 
    mv -f ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/securityContext.xml ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/securityContext.bkp
    mv -f securityContext.xml ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/securityContext.xml

    mv -f ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/serviceContext.xml ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/serviceContext.bkp
    mv -f serviceContext.xml ${CATALINA_HOME}/webapps/ssc/WEB-INF/internal/serviceContext.xml

    mv -f ${CATALINA_HOME}/webapps/ssc/WEB-INF/init/app.properties ${CATALINA_HOME}/webapps/ssc/WEB-INF/init/app.properties.bkp
    mv -f app.properties ${CATALINA_HOME}/webapps/ssc/WEB-INF/init/app.properties

    echo "*** Customizing Tomcat Landing Page" 
    mv setenv.sh ${CATALINA_HOME}/bin/
    rm -f ${CATALINA_HOME}/bin/*.bat
    mv ${CATALINA_HOME}/webapps/ROOT/index.jsp ${CATALINA_HOME}/webapps/ROOT/tomcat.jsp
    mv redirect.jsp ${CATALINA_HOME}/webapps/ROOT/index.jsp
    
    echo "*** Setting permissions a+x "
    chmod a+x ${FORTIFY_SSC_HOME}/bin/pwtool
    chmod a+x ${FORTIFY_SSC_HOME}/Tools/fortifyclient/bin/fortifyclient
    chmod a+x ${CATALINA_HOME}/bin/*.sh

    echo "*** Setting ownership to microfocus:microfocus "
    chown -R microfocus:microfocus /home/microfocus/.fortify/

    # Setting SSC Downloads
    echo "*** Packing SSC Tools *" 
    cd ${FORTIFY_SSC_HOME}/Tools
    zip -qqr9 SSCTools.zip ./
    mv SSCTools.zip ${CATALINA_HOME}/webapps/ssc/downloads

    echo "*** Packing SSC Samples *" 
    cd ${FORTIFY_SSC_HOME}/Samples
    zip -qqr9 SSCSamples.zip ./
    mv SSCSamples.zip ${CATALINA_HOME}/webapps/ssc/downloads

    echo "*** Packing SSC Plugins *" 
    cd ${FORTIFY_SSC_HOME}/plugins
    zip -qqr9 SSCPlugins.zip ./ 
    mv SSCPlugins.zip ${CATALINA_HOME}/webapps/ssc/downloads

    if [ $DEBUG = "true" ]; then
        echo "*** Fortify SSC Downloadas. ***" 
        ls -alF ${CATALINA_HOME}/webapps/ssc/downloads 

        echo "*** Fortify SSC Installers Update-Site. ***" 
        ls -alF ${CATALINA_HOME}/webapps/ssc/update-site/installers/ 

        echo "*** Fortify SSC Eclipse Update-Site. ***" 
        ls -alF ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/ 
    fi

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

    echo "*** Finalizing installation " 
}

install > ./install-ssc.log

