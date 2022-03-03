FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

COPY setup C:\\setup

WORKDIR C:\\setup

ENV FORTIFY_SCA_MAJOR=21.2.3 \
    FORTIFY_SSC_URL=http://srv-ftfy-x001:8180/ssc \
    FORTIFY_SCANCENTRAL_URL=http://srv-ftfy-x001:8280/scancentral-ctrl \
    FORTIFY_SCA_HOME=C:\\Tools\\Fortify\\SCA

RUN powershell .\\install.ps1

RUN powershell Get-Content -Path InstallFortify.log

WORKDIR C:\\ScanCentralWorkdir

RUN rmdir /Q /S C:\\setup

VOLUME "C:\\ScanCentralWorkdir" 

CMD ["startsensor.cmd"]
