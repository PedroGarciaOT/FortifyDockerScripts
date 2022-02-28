docker pull fortifydocker/lim:21.2

New-Item -Path "c:\" -Name "lim" -ItemType "directory"

Copy-Item -Path .\05-fortify-lim\LimDocker.env -Destination C:\lim\

docker run -d -p 80:80 --restart always --env-file c:\lim\LimDocker.env -m=4g --cpus=2 --name fortify-lim  -v c:/lim:c:/lim fortifydocker/lim 
