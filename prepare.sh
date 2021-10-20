#!/bin/bash

function install { 
    echo "          "
    echo "Prepare started"
    echo "          "
    FORTIFY_MAJOR=21.1.0
    SOURCE_AND_LIB_SCANNER_MAJOR=21.1.0
    WEBINSPECT_MAJOR=21.1
    
    FORTIFY_SSC_MAJOR=21.1.2
    FORTIFY_SCANCENTRAL_MAJOR=21.1.0
    FORTIFY_SCA_MAJOR=21.1.2
    FORTIFY_SCA_PLUGINS_MAJOR=21.1.1
    
    TOMCAT_MAJOR=9
    TOMCAT_VERSION=9.0.54

    FILE_FORTIFY_LICESE=Fortify_2021.license
    FILE_JDK=jdk-11.0.11_linux-x64_bin.tar.gz

    FILE_FORTIFY=Fortify_${FORTIFY_MAJOR}.zip
    FILE_SCANCENTRAL=Fortify_ScanCentral_Controller_${FORTIFY_MAJOR}.zip
    FILE_SCANCENTRAL_CONTROLLER=Fortify_ScanCentral_Controller_${FORTIFY_MAJOR}_x64.zip
    FILE_SCANCENTRAL_CLIENT=Fortify_ScanCentral_Client_${FORTIFY_MAJOR}_x64.zip
    FILE_SCA_LINUX=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_linux_x64.run
    FILE_SCA_OSX=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_osx_x64.app.zip
    FILE_SCA_WINDOWS=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_windows_x64.exe
    FILE_LIB_SCANNER=Fortify_SourceAndLibScanner_${SOURCE_AND_LIB_SCANNER_MAJOR}_x64.zip
    FILE_WI=WebInspect_64_${WEBINSPECT_MAJOR}.zip
    FILE_SECURITY_TOOLKIT=SecurityToolkit_${WEBINSPECT_MAJOR}.zip
    FILE_RUNTIME_AGENT=WebInspectAgent_${WEBINSPECT_MAJOR}.zip  

    FILE_SSC_PATCH=Fortify_21.1.2_Server_WAR_Tomcat.zip
    FILE_SCANCENTRAL_PATCH=Fortify_ScanCentral_Controller_21.1.1.zip
    FILE_SCA_PATCH_LINUX=Fortify_SCA_and_Apps_21.1.2_linux_x64.zip
    FILE_SCA_PATCH_OSX=Fortify_SCA_and_Apps_21.1.2_osx_x64.app.zip
    FILE_SCA_PATCH_WINDOWS=Fortify_SCA_and_Apps_21.1.2_windows_x64.zip

    FILE_TOMCAT=apache-tomcat-${TOMCAT_VERSION}.tar.gz

    FILE_BIRT=birt-report-designer-all-in-one-4.7.0-20170622-win32.win32.x86_64.zip
    URL_BIRT=http://www.eclipse.org/downloads/download.php?file=/birt/downloads/drops/R-R1-4.7.0-201706222054/${FILE_BIRT}

    echo "*** Unziping ${FILE_FORTIFY} to FortifyInstallers/ " 
    unzip -qq FortifyInstallers/${FILE_FORTIFY} -d FortifyInstallers/

    echo "*** Unziping ${FILE_SCANCENTRAL} to FortifyInstallers/ " 
    unzip -qq FortifyInstallers/${FILE_SCANCENTRAL} -d FortifyInstallers/

    if [ ! -f "FortifyInstallers/${FILE_BIRT}" ]; then 
        echo "*** Downloading ${FILE_BIRT} " 
        wget ${URL_BIRT} -P FortifyInstallers/
    fi 
    mv FortifyInstallers/${FILE_BIRT} FortifyInstallers/birt-report-designer.zip

    if [ ! -f "FortifyInstallers/${FILE_TOMCAT}" ]; then
        echo "*** Downloading ${FILE_TOMCAT} " 
        wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/${FILE_TOMCAT} -P FortifyInstallers/
    fi
    mv FortifyInstallers/${FILE_TOMCAT} FortifyInstallers/apache-tomcat-latest.tar.gz

    wget https://dlcdn.apache.org/tomcat/tomcat-connectors/native/1.2.31/source/tomcat-native-1.2.31-src.tar.gz -P FortifyInstallers/ 
    mv FortifyInstallers/tomcat-native-1.2.31-src.tar.gz FortifyInstallers/tomcat-native-latest.tar.gz

    mkdir -p 00-fortify-centos8/setup/FortifyInstallers
    mv FortifyInstallers/${FILE_JDK} 00-fortify-centos8/setup/FortifyInstallers/jdk-11_latest_linux-x64_bin.tar.gz

    mkdir -p 02-fortify-scancentral-sast/setup/FortifyInstallers    
    if [ -f "FortifyInstallers/${FILE_SCANCENTRAL_PATCH}" ]; then
        mv FortifyInstallers/${FILE_SCANCENTRAL_PATCH} 02-fortify-scancentral-sast/setup/FortifyInstallers/Fortify_ScanCentral_Controller_Latest_x64.zip
    else
        mv FortifyInstallers/${FILE_SCANCENTRAL_CONTROLLER} 02-fortify-scancentral-sast/setup/FortifyInstallers/Fortify_ScanCentral_Controller_Latest_x64.zip
    fi
    cp FortifyInstallers/tomcat-native-latest.tar.gz 02-fortify-scancentral-sast/setup/FortifyInstallers/

    mv FortifyInstallers/${FILE_SCANCENTRAL_CLIENT} FortifyInstallers/Fortify_ScanCentral_Client_Latest_x64.zip

    mkdir -p work/sca-linux/
    mkdir -p 03-fortify-sca-linux/setup/FortifyInstallers
    if [ -f "FortifyInstallers/${FILE_SCA_PATCH_LINUX}" ]; then
        unzip -qq FortifyInstallers/${FILE_SCA_PATCH_LINUX} -d work/sca-linux/
    else
        tar -pxzf FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz -C work/sca-linux/ 
    fi
    mv work/sca-linux/${FILE_SCA_LINUX} FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run
    cp FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run 03-fortify-sca-linux/setup/FortifyInstallers/

    mkdir -p work/sca-windows/
    mkdir -p 04-fortify-sca-windows/setup/FortifyInstallers
    if [ -f "FortifyInstallers/${FILE_SCA_PATCH_WINDOWS}" ]; then
        unzip -qq FortifyInstallers/${FILE_SCA_PATCH_WINDOWS} -d work/sca-windows/
    else
        unzip -qq FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Windows.zip -d work/sca-windows/
    fi
    mv work/sca-windows/${FILE_SCA_WINDOWS} FortifyInstallers/Fortify_SCA_Windows_Latest_x64.exe
    cp FortifyInstallers/Fortify_SCA_Windows_Latest_x64.exe 04-fortify-sca-windows/setup/FortifyInstallers/

    if [ -f "FortifyInstallers/${FILE_SCA_PATCH_OSX}" ]; then
        mv FortifyInstallers/${FILE_SCA_PATCH_OSX} FortifyInstallers/Fortify_SCA_OSX_Latest_x64.app.zip
    else
        mkdir -p work/sca-osx/
        tar -pxzf FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Mac.tar.gz -C work/sca-osx/
        mv work/sca-osx/${FILE_SCA_OSX} FortifyInstallers/Fortify_SCA_OSX_Latest_x64.app.zip
    fi

    mv FortifyInstallers/${FILE_LIB_SCANNER} FortifyInstallers/SourceAndLibScanner_Latest_x64.zip
    
    mv FortifyInstallers/Fortify_IntelliJ_Remediation_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip FortifyInstallers/Fortify_IntelliJ_Remediation_Plugin_Latest.zip

    mv FortifyInstallers/Fortify_Eclipse_Remediation_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip FortifyInstallers/Fortify_Eclipse_Remediation_Plugin_Latest.zip

    mv FortifyInstallers/Fortify_SecurityAssistant_Eclipse_Plugin_${FORTIFY_SCA_PLUGINS_MAJOR}.zip FortifyInstallers/Fortify_SecurityAssistant_Eclipse_Plugin_Latest.zip

    mv FortifyInstallers/${FILE_WI} FortifyInstallers/WebInspect_64_Latest.zip

    mv FortifyInstallers/${FILE_SECURITY_TOOLKIT} FortifyInstallers/SecurityToolkit_Latest.zip

    mv FortifyInstallers/${FILE_RUNTIME_AGENT} FortifyInstallers/WebInspectAgent_Latest.zip  

    if [ -f "FortifyInstallers/${FILE_SSC_PATCH}" ]; then
        mv FortifyInstallers/${FILE_SSC_PATCH} FortifyInstallers/Fortify_Latest_Server_WAR_Tomcat.zip
    else
        mkdir -p work/ssc/
        unzip -qq FortifyInstallers/Fortify_SSC_Server_${FORTIFY_SCA_MAJOR}.zip -d work/ssc/
        mv work/ssc/Fortify_${FORTIFY_SSC_MAJOR}_Server_WAR_Tomcat.zip FortifyInstallers/Fortify_Latest_Server_WAR_Tomcat.zip
    fi

    cp -rf FortifyInstallers 01-fortify-ssc/setup/

    mkdir -p /opt/fortify
    cp FortifyInstallers/${FILE_FORTIFY_LICESE} /opt/fortify/fortify.license
    touch /opt/fortify/fortify.license
    mv 01-fortify-ssc/setup/FortifyInstallers/${FILE_FORTIFY_LICESE} 01-fortify-ssc/setup/FortifyInstallers/fortify.license
    cp /opt/fortify/fortify.license 03-fortify-sca-linux/setup/FortifyInstallers/
    cp /opt/fortify/fortify.license 04-fortify-sca-windows/setup/FortifyInstallers/

    if [ ! -f "/opt/mysql/config/my.cnf" ]; then 
        mkdir -p /opt/mysql/config
        mkdir -p /opt/mysql/data
        if [ -f "01-fortify-ssc/setup/FortifyInstallers/my.cnf" ]; then 
            cp 01-fortify-ssc/setup/FortifyInstallers/my.cnf /opt/mysql/config/
        else
            echo "***WARNING! MySQL requires additional configuration at /opt/mysql/config/my.cnf"
            touch /opt/mysql/config/my.cnf
        fi
    fi

    echo "          "
    echo "Prepare finished"
    echo "          "
}

    install > ./prepare-install.log