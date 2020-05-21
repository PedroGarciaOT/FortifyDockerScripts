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
export FORTIFY_SCA_MAJOR=19.2.3

function install { 
    DEBUG="true"
    DOWNLOAD_SCA_OPTIONS="false"

    echo "*** Starting Installation " 
    URL_SCA_UPDATE_SITE=http://172.50.0.1:8180/ssc
    URL_SCA_DOWNLOAD_SITE=${URL_SCA_UPDATE_SITE}/downloads
    URL_SCA_LICENSE=${URL_SCA_DOWNLOAD_SITE}/fortify.license
    FILE_SCA_LINUX=Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_linux_x64.run
    URL_SCA_LINUX=${URL_SCA_DOWNLOAD_SITE}/${FILE_SCA_LINUX}
    FILE_SCA_LINUX_OPTIONS=${FILE_SCA_LINUX}.options
    URL_SCA_LINUX_OPTIONS=${URL_SCA_DOWNLOAD_SITE}/${FILE_SCA_LINUX_OPTIONS}
    FILE_JDK11=jdk-11.0.6_linux-x64_bin.tar.gz
    # http://ftp.unicamp.br/pub/apache/ant/binaries/apache-ant-1.9.14-bin.tar.gz
    FILE_ANT=apache-ant-1.10.7-bin.tar.gz
    URL_ANT=http://mirror.nbtelecom.com.br/apache/ant/binaries/${FILE_ANT}
    FILE_MAVEN=apache-maven-3.6.3-bin.tar.gz
    URL_MAVEN=http://mirror.nbtelecom.com.br/apache/maven/maven-3/3.6.3/binaries/${FILE_MAVEN}
    GRADLE_VERSION=4.10.2
    FILE_GRADLE=gradle-${GRADLE_VERSION}-bin.zip
    URL_GRADLE=https://downloads.gradle-dn.com/distributions/${FILE_GRADLE}
    FILE_ANDROID_TOOLS=commandlinetools-linux-6200805_latest.zip
    URL_ANDROID_TOOLS=https://dl.google.com/android/repository/${FILE_ANDROID_TOOLS}

    mkdir -p /home/microfocus/.fortify/
    chown -R microfocus:microfocus /home/microfocus/.fortify/

    echo "*** Creating required folders "
    mkdir -p ${FORTIFY_HOME}
    mkdir -p ${ANT_HOME}
    mkdir -p ${MAVEN_HOME}
    mkdir -p ${MAVEN_USER_HOME}
    mkdir -p ${JDK11_HOME}
    mkdir -p ${ANDROID_HOME}/platforms
    mkdir -p ${ANDROID_HOME}/tools/bin
    mkdir -p ${ANDROID_HOME}/platform-tools
    mkdir -p /CloudscanWorkdir
    mkdir -p work/sca-linux/
    mkdir -p FortifyInstallers

    if [ -f "FortifyInstallers/${FILE_JDK11}" ]; then
        tar -pxzf FortifyInstallers/${FILE_JDK11} -C ${JDK11_HOME}/ --strip-components=1
    fi
    chown -R microfocus:microfocus ${JDK11_HOME}

    if [ ! -f "FortifyInstallers/${FILE_ANT}" ]; then
        echo "*** Downloading ${URL_ANT} "
        wget -q ${URL_ANT} -P FortifyInstallers/
    fi
    tar -pxzf FortifyInstallers/${FILE_ANT} -C ${ANT_HOME}/ --strip-components=1
    chown -R microfocus:microfocus ${ANT_HOME}

    if [ ! -f "FortifyInstallers/${FILE_MAVEN}" ]; then
        echo "*** Downloading ${URL_MAVEN} "
        wget -q ${URL_MAVEN} -P FortifyInstallers/
    fi
    tar -pxzf FortifyInstallers/${FILE_MAVEN} -C ${MAVEN_HOME}/ --strip-components=1
    mv ${MAVEN_HOME}/conf/settings.xml ${MAVEN_HOME}/conf/settings.bkp
    mv settings.xml ${MAVEN_HOME}/conf/
    chown -R microfocus:microfocus ${MAVEN_HOME}
    chown -R microfocus:microfocus ${MAVEN_USER_HOME}

    if [ ! -f "FortifyInstallers/${FILE_GRADLE}" ]; then
        echo "*** Downloading ${URL_GRADLE} "
        wget -q ${URL_GRADLE} -P FortifyInstallers/
    fi
    unzip -qq FortifyInstallers/gradle-${GRADLE_VERSION}-bin.zip -d work/
    mv work/gradle-${GRADLE_VERSION} $GRADLE_HOME
    mkdir -p ${GRADLE_USER_HOME}
    mv init.gradle ${GRADLE_USER_HOME}/
    chown -R microfocus:microfocus ${GRADLE_HOME}
    chown -R microfocus:microfocus ${GRADLE_USER_HOME}

    if [ ! -f "FortifyInstallers/${FILE_ANDROID_TOOLS}" ]; then
        echo "*** Downloading ${URL_ANDROID_TOOLS} "
        wget -q ${URL_ANDROID_TOOLS} -P FortifyInstallers/
    fi
    unzip -qq FortifyInstallers/${FILE_ANDROID_TOOLS} -d ${ANDROID_HOME}
    mv android-packages.txt ${ANDROID_HOME}
    chown -R microfocus:microfocus ${ANDROID_HOME}

    if [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz" ]; then
        echo "*** Extracting FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz to work/sca-linux/ " 
        tar -pxzf FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.tar.gz -C work/sca-linux/ 
    elif [ -f "FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip" ]; then
        echo "*** Unziping FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip to work/sca-linux/ " 
        unzip -qq FortifyInstallers/Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_Linux.zip -d work/sca-linux/ 
    elif [ -f "FortifyInstallers/${FILE_SCA_LINUX}" ]; then 
        echo "*** Moving FortifyInstallers/${FILE_SCA_LINUX} to work/sca-linux/" 
        mv FortifyInstallers/${FILE_SCA_LINUX} work/sca-linux/ 
    else
        echo "*** Downloading ${URL_SCA_LINUX} "
        wget -q ${URL_SCA_LINUX} -P work/sca-linux/
        if [ ${DOWNLOAD_SCA_OPTIONS} = true ]; then 
            echo "*** Downloading ${URL_SCA_LINUX_OPTIONS} "
            wget -q ${URL_SCA_LINUX_OPTIONS} -P work/sca-linux/
        fi
        echo "*** Downloading ${URL_SCA_LICENSE} "
        wget -q ${URL_SCA_LICENSE} -P work/sca-linux/
    fi

    echo "*** Checking work/sca-linux/${FILE_SCA_LINUX_OPTIONS} "
    if [ ! -f "work/sca-linux/${FILE_SCA_LINUX_OPTIONS}" ]; then 
        mv Fortify_SCA_Linux.options work/sca-linux/${FILE_SCA_LINUX_OPTIONS}
    fi
    echo "*** Checking work/sca-linux/fortify.license "
    if [ ! -f "work/sca-linux/fortify.license" ]; then 
        mv FortifyInstallers/fortify.license work/sca-linux/
    fi
    chmod a+x work/sca-linux/*.run
    echo "*** Unattended SCA Installation "
    ./work/sca-linux/${FILE_SCA_LINUX} --mode unattended

    mv cloudscan.properties ${FORTIFY_HOME}/Core/config/
    mv worker.properties ${FORTIFY_HOME}/Core/config/
    mv startsensor.sh ${FORTIFY_HOME}/bin/startsensor
    chmod a+x ${FORTIFY_HOME}/bin/startsensor

    echo "*** Setting ownership o microfocus:microfocus "
    chown -R microfocus:microfocus ${FORTIFY_HOME}
    chown -R microfocus:microfocus /CloudscanWorkdir

    echo "*** Updating SCA rulepack "
    fortifyupdate -acceptKey -acceptSSLCertificate -url ${URL_SCA_UPDATE_SITE}

    echo "*** Installing Fortify Maven Plugin "
    cd ${FORTIFY_HOME}/plugins/maven
    tar -pxzf maven-plugin-bin.tar.gz
    mkdir src
    tar -pxzf maven-plugin-src.tar.gz -C src
    cd ${FORTIFY_HOME}/plugins/maven/src
    mvn clean install

    echo "*** Intalling Android SDK platform-tools."
    cd ${ANDROID_HOME}/tools/bin
    yes | sdkmanager --licenses
    sdkmanager "platform-tools" "ndk-bundle" 
    
    if [ -f "${ANDROID_HOME}/android-packages.txt" ]; then 
        echo "*** Intalling Android SDK packages "
        cat ${ANDROID_HOME}/android-packages.txt
        echo "          "
        sdkmanager --package_file=${ANDROID_HOME}/android-packages.txt
    fi
    
    echo "*** Removing unnecessary content "  
    yum clean all

    echo "*** Finalizing installation " 
}

install > /install.log

