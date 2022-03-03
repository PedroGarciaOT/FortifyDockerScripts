function PrepareInstall { 
    Set-ExecutionPolicy unrestricted -Force

    $FILE_JDK = "jdk-11.0.14_windows-x64_bin.exe"
    $FILE_FORTIFY_LICESE = "Fortify_2022.license"

    $FORTIFY_SCA_MAJOR = "21.2.3"
    
    $FILE_SCA_WINDOWS = "Fortify_SCA_and_Apps_${FORTIFY_SCA_MAJOR}_windows_x64.exe"
    $FILE_SCA_PATCH_WINDOWS = "Fortify_SCA_and_Apps_21.2.3_Windows.zip"
    
    mkdir work\sca-windows\
    mkdir 04-fortify-sca-windows\setup\FortifyInstallers

    Move-Item -Path "FortifyInstallers\$FILE_JDK" -Destination "04-fortify-sca-windows\setup\FortifyInstallers\jdk-11_latest_windows-x64_bin.exe" 
    Move-Item -Path "FortifyInstallers\$FILE_FORTIFY_LICESE" -Destination "04-fortify-sca-windows\setup\FortifyInstallers\fortify.license" 

    if (Test-Path -Path "FortifyInstallers\$FILE_SCA_PATCH_WINDOWS" -PathType Leaf) {
        Write-Output "== *** Unziping Patch $($FILE_SCA_PATCH_WINDOWS) to work\sca-windows " 
        Expand-Archive -Path "FortifyInstallers\$($FILE_SCA_PATCH_WINDOWS)" -DestinationPath ".\work\sca-windows"
    } else {
        Write-Output "== *** Unziping Major Release Fortify_SCA_and_Apps_$($FORTIFY_SCA_MAJOR)_Windows.zip to work\sca-windows " 
        Expand-Archive -Path "FortifyInstallers/Fortify_SCA_and_Apps_$($FORTIFY_SCA_MAJOR)_Windows.zip" -DestinationPath ".\work\sca-windows"
    }

    Move-Item -Path "work\sca-windows\$FILE_SCA_WINDOWS" -Destination "04-fortify-sca-windows\setup\FortifyInstallers\Fortify_SCA_Windows_Latest_x64.exe"
}

PrepareInstall > ./prepare-install.log