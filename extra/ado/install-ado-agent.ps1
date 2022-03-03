$adopat="<your token>"
$adourl="https://dev.azure.com/<your organization>"
$adopool="<your self-host agent pool>" 
$adoagent="<your agent name>"

New-Item -Path "C:\ADO-Agent" -Force -ItemType "directory"
Set-Location -Path "C:\ADO-Agent"
#Download Agent
Invoke-WebRequest -Uri "https://vstsagentpackage.azureedge.net/agent/2.200.2/vsts-agent-win-x64-2.200.2.zip" -OutFile "C:\ADO-Agent\vsts-agent-win-x64.zip"
#Unzip Agent
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("C:\ADO-Agent\vsts-agent-win-x64.zip", "$PWD")
#Config Agent
Start-Process -FilePath "cmd.exe" -ArgumentList "config.cmd", "--unattended", "--url", $adourl, "--auth", "pat", "--token", $adopat, "--pool", $adopool, "--agent", $adoagent, "--replace", "--runAsService" -Wait -WorkingDirectory "C:\ADO-Agent"

Remove-Item -Path "C:\ADO-Agent\vsts-agent-win-x64.zip"