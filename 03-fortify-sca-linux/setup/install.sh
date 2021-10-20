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

function install { 
    DEBUG="true"
    DOWNLOAD_SCA_OPTIONS="false"
    DOWNLOAD_FORTIFY_LICESE="false"
    UPDATE_RULEPACK_FROM_SSC="false"

    echo "*** Starting Installation " 
    URL_SCA_UPDATE_SITE=http://fortify-ssc:8080/ssc
    URL_SCA_DOWNLOAD_SITE=${URL_SCA_UPDATE_SITE}/downloads
    URL_SCA_LICENSE=${URL_SCA_DOWNLOAD_SITE}/fortify.license

    mkdir -p /home/microfocus/.fortify/
    chown -R microfocus:microfocus /home/microfocus/.fortify/

    echo "*** Creating required folders "
    # Creating the FORTIFY_SCA_HOME env variable folder
    mkdir -p ${FORTIFY_SCA_HOME}
    mkdir -p /ScanCentralWorkdir    

    echo "*** Checking Fortify Installers "
    if [ ! -f "FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run" ]; then
        mkdir -p FortifyInstallers
        echo "*** Downloading SCA "
        wget -q ${URL_SCA_DOWNLOAD_SITE}/Fortify_SCA_Linux_Latest_x64.run -P FortifyInstallers/
        if [ ${DOWNLOAD_SCA_OPTIONS} = true ]; then 
            wget -q ${URL_SCA_DOWNLOAD_SITE}/Fortify_SCA_Linux_Latest_x64.run.options -P FortifyInstallers/
        fi
        if [ ${DOWNLOAD_FORTIFY_LICESE} = true ]; then 
            wget -q ${URL_SCA_LICENSE} -P FortifyInstallers/
        fi
    fi

    if [ ! -f "FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run.options" ]; then 
        mv Fortify_SCA_Linux.options FortifyInstallers/Fortify_SCA_Linux_Latest_x64.run.options
    fi

    chmod a+x FortifyInstallers/*.run
    echo "*** Unattended SCA Installation "
    cd FortifyInstallers
    ./Fortify_SCA_Linux_Latest_x64.run --mode unattended
    cd ..

    mv client.properties ${FORTIFY_SCA_HOME}/Core/config/
    mv worker.properties ${FORTIFY_SCA_HOME}/Core/config/
    mv startsensor.sh ${FORTIFY_SCA_HOME}/bin/startsensor

    chmod a+x ${FORTIFY_SCA_HOME}/bin/startsensor

    echo "*** Setting ownership o microfocus:microfocus "
    chown -R microfocus:microfocus ${FORTIFY_SCA_HOME}
    chown -R microfocus:microfocus /ScanCentralWorkdir

    ${FORTIFY_SCA_HOME}/jre/bin/keytool -alias fortify -importcert -trustcacerts -cacerts -file /home/microfocus/FortifyCert.cer -storepass changeit -noprompt

    echo "*** Updating SCA rulepack "
    if [ ${UPDATE_RULEPACK_FROM_SSC} = true ]; then 
        echo "*** Updating rulepack from SSC"
        fortifyupdate -acceptKey -acceptSSLCertificate -url ${URL_SCA_UPDATE_SITE}
    else
        fortifyupdate -acceptKey -acceptSSLCertificate -url https://update.fortify.com
    fi

    echo "*** Removing unnecessary content "  
    yum clean all

    echo "*** Finalizing installation " 
}

install > ./install-sca-linux.log
