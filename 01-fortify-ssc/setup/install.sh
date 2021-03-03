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
export FORTIFY_MAJOR=20.2.0
export FORTIFY_SSC_MAJOR=20.2.2
export FORTIFY_SCANCENTRAL_MAJOR=20.2.0
export FORTIFY_SCA_MAJOR=20.2.2
export FORTIFY_SCA_PLUGINS_MAJOR=20.2.0
export WEBINSPECT_MAJOR=20.2
export SOURCE_AND_LIB_SCANNER_MAJOR=20.2.1

export MYSQL_DRIVER_VERSION=8.0.20
export TOMCAT_MAJOR=9
export TOMCAT_VERSION=9.0.43

# Tomcat native lib
export TOMCAT_NATIVE_LIBDIR=${CATALINA_HOME}/native-jni-lib
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$TOMCAT_NATIVE_LIBDIR

function install { 
    DEBUG="true"

    echo "*** Starting Installation " 
    FILE_FORTIFY_ALL_IN_ONE=Fortify_${FORTIFY_MAJOR}.zip
    FILE_WI=WebInspect_64_${WEBINSPECT_MAJOR}.zip
    FILE_SECURITY_TOOLKIT=SecurityToolkit_${WEBINSPECT_MAJOR}.zip
    FILE_RUNTIME_AGENT=WebInspectAgent_${WEBINSPECT_MAJOR}.zip
    FILE_DATABASE_CONNECTOR=mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz
    FILE_JDBC_DRIVER=mysql-connector-java-${MYSQL_DRIVER_VERSION}.jar
    FILE_BIRT=birt-report-designer-all-in-one-4.7.0-20170622-win32.win32.x86_64.zip
    URL_BIRT=http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4.7.0-201706222054/${FILE_BIRT}
    TARGET_TOMCAT=apache-tomcat-${TOMCAT_VERSION}
    FILE_TOMCAT_ZIP=${TARGET_TOMCAT}.zip
    FILE_TOMCAT_TAR=${TARGET_TOMCAT}.tar.gz
    FILE_SCA_LINUX=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_linux_x64.run
    FILE_SCA_OSX=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_osx_x64.app.zip
    FILE_SCA_WINDOWS=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_windows_x64.exe
    FILE_SCANCENTRAL_CLIENT=Fortify_ScanCentral_Client_${FORTIFY_SCANCENTRAL_MAJOR}_x64.zip
    FILE_SSC_SERVER_ZIP=Fortify_SSC_Server_${FORTIFY_SSC_MAJOR}.zip
    FILE_SSC_SERVER_WAR_ZIP=Fortify_${FORTIFY_SSC_MAJOR}_Server_WAR_Tomcat.zip
    FILE_LIB_SCANNER=Fortify_SourceAndLibScanner_${SOURCE_AND_LIB_SCANNER_MAJOR}_x64.zip

    if [ $DEBUG = "true" ]; then
        echo "          "
        echo "********************************************************************************"
        echo "FILE_FORTIFY_ALL_IN_ONE=${FILE_FORTIFY_ALL_IN_ONE}"
        echo "FILE_WI=${FILE_WI}"
        echo "FILE_SECURITY_TOOLKIT=${FILE_SECURITY_TOOLKIT}"
        echo "FILE_RUNTIME_AGENT=${FILE_RUNTIME_AGENT}"
        echo "FILE_DATABASE_CONNECTOR=${FILE_DATABASE_CONNECTOR}"
        echo "FILE_JDBC_DRIVER=${FILE_JDBC_DRIVER}"
        echo "FILE_BIRT=${FILE_BIRT}"
        echo "FILE_TOMCAT_ZIP=${FILE_TOMCAT_ZIP}"
        echo "FILE_TOMCAT_TAR=${FILE_TOMCAT_TAR}"
        echo "FILE_SCA_LINUX=${FILE_SCA_LINUX}"
        echo "FILE_SCA_OSX=${FILE_SCA_OSX}"
        echo "FILE_SCA_WINDOWS=${FILE_SCA_WINDOWS}"
        echo "FILE_LIB_SCANNER=${FILE_LIB_SCANNER}"

        echo "FILE_SSC_SERVER_ZIP=${FILE_SSC_SERVER_ZIP}"
        echo "FILE_SSC_SERVER_WAR_ZIP=${FILE_SSC_SERVER_WAR_ZIP}"
        echo "********************************************************************************"
        echo "          "
    fi

    # Setting Working folders
    mkdir -p work/jdbc/
    mkdir -p work/ssc/
    mkdir -p work/sca-linux/
    mkdir -p work/sca-osx/
    mkdir -p work/sca-windows/

    # TODO Download the files from https://softwaresupport.softwaregrp.com/ automatically as well as other files like Oracle JDBC that requires user authentication.  
    # TODO Unzip all patches and handle them

    echo "*** Looking for ${FILE_FORTIFY_ALL_IN_ONE} "
    # Extract Fortify Full pack
    if [ -f "FortifyInstallers/${FILE_FORTIFY_ALL_IN_ONE}" ]; then 
        echo "*** Unziping ${FILE_FORTIFY_ALL_IN_ONE} to FortifyInstallers/ " 
        unzip -qq FortifyInstallers/${FILE_FORTIFY_ALL_IN_ONE} -d FortifyInstallers/
    fi 

    # Extract SSC
    echo "*** Looking for ${FILE_SSC_SERVER_ZIP} " 
    if [ -f "FortifyInstallers/${FILE_SSC_SERVER_ZIP}" ]; then
        echo "*** Unziping ${FILE_SSC_SERVER_ZIP}  to work/ssc/ " 
        unzip -qq FortifyInstallers/${FILE_SSC_SERVER_ZIP} -d work/ssc/
    fi

    echo "*** Looking for ${FILE_SSC_SERVER_WAR_ZIP} " 
    PATH_TO_SSC_SERVER_WAR_ZIP=${FILE_SSC_SERVER_WAR_ZIP}
    if [ -f "work/ssc/${FILE_SSC_SERVER_WAR_ZIP}" ]; then        
        PATH_TO_SSC_SERVER_WAR_ZIP=work/ssc/${PATH_TO_SSC_SERVER_WAR_ZIP}
    else 
        PATH_TO_SSC_SERVER_WAR_ZIP=FortifyInstallers/${PATH_TO_SSC_SERVER_WAR_ZIP}
    fi 
    mkdir -p ${FORTIFY_SSC_HOME}/
    mkdir -p $FORTIFY_SSC_SEARCH_INDEX/
    mkdir -p /home/microfocus/.fortify/
    echo "*** Unziping ${PATH_TO_SSC_SERVER_WAR_ZIP} to ${FORTIFY_SSC_HOME} " 
    unzip -qq ${PATH_TO_SSC_SERVER_WAR_ZIP} -d ${FORTIFY_SSC_HOME}

    echo "*** Looking for ssc.war " 
    mkdir -p ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/
    mkdir -p ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/
    mkdir -p ${TOMCAT_NATIVE_LIBDIR}/
    echo "*** Unziping ${FORTIFY_SSC_HOME}/ssc.war to ${CATALINA_HOME}/webapps/ssc/ "
    unzip -qq ${FORTIFY_SSC_HOME}/ssc.war -d ${CATALINA_HOME}/webapps/ssc/

    # Extract Tomcat
    echo "*** Looking for Tomcat " 
    if [ -f "work/ssc/${FILE_TOMCAT_ZIP}" ]; then
        echo "*** Unziping ${FILE_TOMCAT_ZIP}/ssc.war to work/ "
        unzip -qq work/ssc/${FILE_TOMCAT_ZIP} -d work/
        echo "Moving work/${TARGET_TOMCAT} to work/tomcat/ "
        mv work/${TARGET_TOMCAT} work/tomcat/
        echo "Copying work/tomcat/ to ${FORTIFY_SSC_HOME}/ "
        cp -rf work/tomcat/ ${FORTIFY_SSC_HOME}/
    else
        if [ ! -f "FortifyInstallers/${FILE_TOMCAT_TAR}" ]; then
            echo "*** Downloading ${FILE_TOMCAT_TAR} " 
            wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -P FortifyInstallers/
        fi
        echo "*** Extracting FortifyInstallers/${FILE_TOMCAT_TAR} to ${CATALINA_HOME} " 
        tar -pxzf FortifyInstallers/${FILE_TOMCAT_TAR} -C ${CATALINA_HOME}/ --strip-components=1
    fi 

    # Extract JDBC
    echo "*** Looking for MySQL Connector-J " 
    if [ ! -f "FortifyInstallers/${FILE_DATABASE_CONNECTOR}" ]; then
        echo "*** Downloading ${FILE_DATABASE_CONNECTOR}" 
        wget https://cdn.mysql.com//Downloads/Connector-J/${FILE_DATABASE_CONNECTOR} -P FortifyInstallers/
    fi
    echo "*** Extracting ${FILE_DATABASE_CONNECTOR} to work/jdbc/ " 
    tar -pxzf FortifyInstallers/${FILE_DATABASE_CONNECTOR} -C work/jdbc/ --strip-components=1
    echo "*** Moving work/jdbc/${FILE_JDBC_DRIVER} to ${CATALINA_HOME}/lib/ " 
    mv work/jdbc/${FILE_JDBC_DRIVER} ${CATALINA_HOME}/lib/

    echo "*** Looking for MS SQL JDBC " 
    if [ ! -f "FortifyInstallers/sqljdbc_8.2.0.0_enu.tar.gz" ]; then
        echo "*** Downloading sqljdbc_8.2.0.0_enu.tar.gz" 
        wget https://download.microsoft.com/download/4/0/8/40815588-bef6-4715-bde9-baace8726c2a/sqljdbc_8.2.0.0_enu.tar.gz  -P FortifyInstallers/
        tar -pxzf FortifyInstallers/sqljdbc_8.2.0.0_enu.tar.gz -C work/jdbc/ --strip-components=1
        echo "*** Moving work/jdbc/enu/mssql-jdbc-8.2.0.jre8.jar to ${CATALINA_HOME}/lib/ " 
        mv work/jdbc/enu/mssql-jdbc-8.2.0.jre8.jar ${CATALINA_HOME}/lib/
    fi

    echo "*** Looking for Oracle JDBC " 
    if [ -f "FortifyInstallers/ojdbc8.jar" ]; then
        echo "*** Moving FortifyInstallers/ojdbc8.jar to ${CATALINA_HOME}/lib/ " 
        mv FortifyInstallers/ojdbc8.jar ${CATALINA_HOME}/lib/
    fi 

    # Creating Download Site
    echo "*** Customizing SSC - Downloads " 
    mv downloads.jsp ${CATALINA_HOME}/webapps/ssc/downloads/index.jsp

    # Source And Lib Scanner  
    if [ -f "FortifyInstallers/${FILE_LIB_SCANNER}" ]; then
        echo "*** Moving FortifyInstallers/${FILE_LIB_SCANNER} to ${CATALINA_HOME}/webapps/ssc/downloads/" 
        mv FortifyInstallers/${FILE_LIB_SCANNER} ${CATALINA_HOME}/webapps/ssc/downloads/SourceAndLibScanner_Latest_x64.zip
    fi

    # SCA Linux
    if [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz" ]; then
        echo "*** Extracting FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz to work/sca-linux/ " 
        tar -pxzf FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz -C work/sca-linux/ 
    elif [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip" ]; then
        echo "*** Unziping FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip to work/sca-linux/ " 
        unzip -qq FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip -d work/sca-linux/ 
    else 
        echo "*** Moving FortifyInstallers/${FILE_SCA_LINUX} to work/sca-linux/" 
        mv FortifyInstallers/${FILE_SCA_LINUX} work/sca-linux/ 
    fi
    if [ $DEBUG = "true" ]; then
        echo "work/sca-linux/ "
        ls -alF work/sca-linux/
        echo "          "
    fi 
    echo "*** Moving SCA Linux Installer and Options to ${CATALINA_HOME}/webapps/ssc/downloads/"
    mv fortify_sca_unattended_linux.options ${CATALINA_HOME}/webapps/ssc/downloads/SCA_Linux_Latest_x64.run.options
    mv work/sca-linux/${FILE_SCA_LINUX} ${CATALINA_HOME}/webapps/ssc/downloads/SCA_Linux_Latest_x64.run

    # SCA MacOSX
    if [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Mac.tar.gz" ]; then
        echo "*** Extracting FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Mac.tar.gz to work/sca-osx/ " 
        tar -pxzf FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Mac.tar.gz -C work/sca-osx/ 
    else 
        echo "*** Moving FortifyInstallers/${FILE_SCA_OSX} to work/sca-osx/" 
        mv FortifyInstallers/${FILE_SCA_OSX} work/sca-osx/ 
    fi
    if [ $DEBUG = "true" ]; then
        echo "work/sca-osx/ "
        ls -alF work/sca-osx/
        echo "          "
    fi 
    echo "*** Moving SCA OSX Installer and Options to ${CATALINA_HOME}/webapps/ssc/downloads/"
    mv fortify_sca_unattended_osx.options ${CATALINA_HOME}/webapps/ssc/downloads/SCA_OSX_Latest_x64.app.zip.options
    mv work/sca-osx/${FILE_SCA_OSX} ${CATALINA_HOME}/webapps/ssc/downloads/SCA_OSX_Latest_x64.app.zip

    # SCA Windows
    if [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Windows.zip" ]; then
        echo "*** Unziping FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Windows.zip to work/sca-windows/ " 
        unzip -qq FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Windows.zip -d work/sca-windows/ 
    else
        echo "*** Moving FortifyInstallers/${FILE_SCA_WINDOWS} to work/sca-windows/ " 
        mv FortifyInstallers/${FILE_SCA_WINDOWS} work/sca-windows/ 
    fi
    if [ $DEBUG = "true" ]; then
        echo "work/sca-windows/ "
        ls -alF work/sca-windows/ 
        echo "          "
    fi 
    echo "*** Moving SCA Windows Installer and Options to ${CATALINA_HOME}/webapps/ssc/downloads/"
    mv fortify_sca_unattended_windows.options ${CATALINA_HOME}/webapps/ssc/downloads/SCA_Windows_Latest_x64.exe.options
    mv work/sca-windows/${FILE_SCA_WINDOWS} ${CATALINA_HOME}/webapps/ssc/downloads/SCA_Windows_Latest_x64.exe

    # ScanCentral Client
    if [ -f "FortifyInstallers/${FILE_SCANCENTRAL_CLIENT}" ]; then
        echo "*** Moving ScanCentral Client FortifyInstallers/${FILE_SCANCENTRAL_CLIENT} to ${CATALINA_HOME}/webapps/ssc/downloads/"  
        mv FortifyInstallers/${FILE_SCANCENTRAL_CLIENT} ${CATALINA_HOME}/webapps/ssc/downloads/
        cp ${CATALINA_HOME}/webapps/ssc/downloads/${FILE_SCANCENTRAL_CLIENT} ${CATALINA_HOME}/webapps/ssc/downloads/scancentral.zip
    fi

    # Other downloads
    echo "*** Looking for  FortifyInstallers/${FILE_BIRT} " 
    if [ ! -f "FortifyInstallers/${FILE_BIRT}" ]; then
        echo "*** Downloading BIRT ${FILE_BIRT} "
        wget ${URL_BIRT} -P FortifyInstallers/
    fi
    echo "*** Moving Eclipse BIRT FortifyInstallers/${FILE_BIRT} to ${CATALINA_HOME}/webapps/ssc/downloads/ " 
    mv FortifyInstallers/${FILE_BIRT} ${CATALINA_HOME}/webapps/ssc/downloads/birt-report-designer.zip

    FILE_INTELLIJ_REMEDIATION=Fortify_IntelliJ_Remediation_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip
    echo "*** Looking for  ${FILE_INTELLIJ_REMEDIATION} " 
    PATH_TO_INTELLIJ_REMEDIATION=${FILE_INTELLIJ_REMEDIATION}
    if [ -f "work/sca-windows/${FILE_INTELLIJ_REMEDIATION}" ]; then
        PATH_TO_INTELLIJ_REMEDIATION=work/sca-windows/${FILE_INTELLIJ_REMEDIATION}
    else
        PATH_TO_INTELLIJ_REMEDIATION=FortifyInstallers/${FILE_INTELLIJ_REMEDIATION}
    fi
    echo "*** Moving SCA  IntelliJ Remediation Plugin ${PATH_TO_INTELLIJ_REMEDIATION} to ${CATALINA_HOME}/webapps/ssc/downloads/ " 
    mv ${PATH_TO_INTELLIJ_REMEDIATION} ${CATALINA_HOME}/webapps/ssc/downloads/Fortify_IntelliJ_Remediation_Plugin_Latest.zip

    echo "*** Moving Other Installers to ${CATALINA_HOME}/webapps/ssc/downloads/ " 
    mv FortifyInstallers/${FILE_WI} ${CATALINA_HOME}/webapps/ssc/downloads/WebInspect_Latest_x64.zip
    mv FortifyInstallers/${FILE_SECURITY_TOOLKIT} ${CATALINA_HOME}/webapps/ssc/downloads/SecurityToolkit_Latest.zip
    mv FortifyInstallers/${FILE_RUNTIME_AGENT} ${CATALINA_HOME}/webapps/ssc/downloads/WebInspectAgent_Latest.zip

    # Creating Update Site
    echo "*** Customizing SSC - Update-Site " 
    FILE_ECLIPSE_REMEDIATION=Fortify_Eclipse_Remediation_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip
    echo "*** Looking for  ${FILE_ECLIPSE_REMEDIATION} " 
    PATH_TO_ECLIPSE_REMEDIATION=${FILE_ECLIPSE_REMEDIATION}
    if [ -f "work/sca-windows/${FILE_ECLIPSE_REMEDIATION}" ]; then
        PATH_TO_ECLIPSE_REMEDIATION=work/sca-windows/${PATH_TO_ECLIPSE_REMEDIATION}
    else
        PATH_TO_ECLIPSE_REMEDIATION=FortifyInstallers/${PATH_TO_ECLIPSE_REMEDIATION}
    fi
    echo "*** Unziping Eclipse Remediation ${PATH_TO_ECLIPSE_REMEDIATION} to ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/ " 
    unzip -qq ${PATH_TO_ECLIPSE_REMEDIATION} -d ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/
    cp eclipse-update.jsp ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/remediation/index.jsp

    FILE_ECLIPSE_SECURITY_ASSISTANT=Fortify_SecurityAssistant_Eclipse_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip
    echo "*** Looking for  ${FILE_ECLIPSE_SECURITY_ASSISTANT} " 
    PATH_TO_ECLIPSE_SECURITY_ASSISTANT=${FILE_ECLIPSE_SECURITY_ASSISTANT}
    if [ -f "work/sca-windows/${FILE_ECLIPSE_SECURITY_ASSISTANT}" ]; then
        PATH_TO_ECLIPSE_SECURITY_ASSISTANT=work/sca-windows/${PATH_TO_ECLIPSE_SECURITY_ASSISTANT}
    else
        PATH_TO_ECLIPSE_SECURITY_ASSISTANT=FortifyInstallers/${PATH_TO_ECLIPSE_SECURITY_ASSISTANT}
    fi
    echo "*** Unziping Eclipse Security Assistant ${PATH_TO_ECLIPSE_SECURITY_ASSISTANT} to ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/ " 
    unzip -qq ${PATH_TO_ECLIPSE_SECURITY_ASSISTANT} -d ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/
    mv eclipse-update.jsp ${CATALINA_HOME}/webapps/ssc/update-site/eclipse/security-assistant/index.jsp

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

install > /install.log

