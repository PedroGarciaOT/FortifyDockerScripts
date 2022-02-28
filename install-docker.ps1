function InstallDocker { 

    Write-Output "========== Install Docker =========="

    Set-ExecutionPolicy unrestricted -Force

    #FIXME Configure Firewall insteal of removing Windows-Defender
    Uninstall-WindowsFeature Windows-Defender

    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    choco install Containers Microsoft-Hyper-V --source windowsfeatures

    choco install docker-engine docker-cli -y

    choco install docker-compose -y

    Restart-Computer -Force
}

InstallDocker >> .\InstallFortify.log -Append