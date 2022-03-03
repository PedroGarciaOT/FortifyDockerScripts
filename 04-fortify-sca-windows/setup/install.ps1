function InstallSCA { 
    Write-Output "################################################################################"
    Write-Output "################################################################################"
    Write-Output "#          "
    Write-Output "#          Install Fortify SCA Windows as ScanCentral Sensor " 
    Write-Output "#          "
    Write-Output "################################################################################"
    Write-Output "################################################################################"

    Set-ExecutionPolicy unrestricted -Force

    Write-Output "=== Installing MSBuild"

    $msBuildPath = "C:\Tools\MSBuild"
    $jdkPath = "C:\Tools\Java\jdk-11"
    $fortifyPath = "C:\Tools\Fortify\SCA"
    $updateFromSSCFlag=$false

    # Download the Build Tools bootstrapper.
    Invoke-WebRequest "https://aka.ms/vs/16/release/vs_buildtools.exe" -OutFile "C:\setup\vs_buildtools.exe" 

    #Options for: vs_buildtools.exe --quiet --wait --norestart --force --all --includeRecommended --includeOptional --downloadThenInstall --installPath $msBuildPath
    Start-Process -FilePath "C:\setup\vs_BuildTools.exe" -ArgumentList "--quiet", "--wait", "--norestart", "--nocache", "--downloadThenInstall", "--installPath", $msBuildPath -Wait

    Remove-Item "C:\setup\vs_BuildTools.exe"
    
    Start-Process -FilePath "C:\setup\FortifyInstallers\jdk-11_latest_windows-x64_bin.exe" -ArgumentList "/s", "INSTALLDIR=$jdkPath", "REBOOT=Disable" -Wait

    mkdir "C:\ScanCentralWorkdir"

    Move-Item -Path "C:\setup\Fortify_SCA_Windows_Latest_x64.exe.options" -Destination "C:\setup\FortifyInstallers\Fortify_SCA_Windows_Latest_x64.exe.options"

    Start-Process -FilePath "C:\setup\FortifyInstallers\Fortify_SCA_Windows_Latest_x64.exe" -ArgumentList "--mode", "unattended" -Wait -WorkingDirectory "C:\setup\FortifyInstallers"

    Move-Item -Path "C:\setup\client.properties" -Destination "$fortifyPath\Core\config\" -Force
    Move-Item -Path "C:\setup\worker.properties" -Destination "$fortifyPath\Core\config\" -Force
    Move-Item -Path "C:\setup\startsensor.cmd" -Destination "$fortifyPath\bin\"

    Write-Output "=== Updating System Path"

    $registryPath = "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
    $oldPath = (Get-ItemProperty -Path $registryPath -Name PATH).path
    $newPath = "$oldpath;$msBuildPath;$jdkPath\bin;$fortifyPath\bin"
    Set-ItemProperty -Path "$registryPath" -Name PATH -Value "$newPath"

    Set-ItemProperty -Path $registryPath -Name "JAVA_TOOL_OPTIONS" -Value "-Dfile.encoding=windows-1252"
    
    #TODO Configure Certificate $fortifyPath\jre\bin\keytool -alias fortify -importcert -trustcacerts -cacerts -file FortifyCert.cer -storepass changeit -noprompt

    Write-Output "=== Updating SCA rulepack "
    if ( $updateFromSSCFlag ) {
        Write-Output "=== Updating rulepack from SSC"
        $updateSite = Get-ItemProperty -Path $registryPath -Name "FORTIFY_SSC_URL" 
        Start-Process -FilePath "$fortifyPath\bin\fortifyupdate.cmd" -ArgumentList "-acceptKey", "-acceptSSLCertificate", "-url", "$updateSite" -Wait
    } else {
        Write-Output "=== Updating rulepack from https://update.fortify.com"
        Start-Process -FilePath "$fortifyPath\bin\fortifyupdate.cmd" -ArgumentList "-acceptKey", "-acceptSSLCertificate", "-url", "https://update.fortify.com" -Wait
    }

    #FIXME Fix java output encoding 

    Write-Output "################################################################################"
    Write-Output "################################################################################"
    Write-Output "#          "
    Write-Output "#          Finalizing Fortify SCA Windows " 
    Write-Output "#          "
    Write-Output "################################################################################"
    Write-Output "################################################################################"    
}

InstallSCA >> .\InstallFortify.log
