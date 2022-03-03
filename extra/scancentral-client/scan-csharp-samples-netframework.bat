cls
Echo "*** "
Echo "*** Starting CSharp Sample version VS2019-.NetFramework4.8"
cd C:\Tools\Fortify\SCA\Samples\advanced\csharp\VS2019\.NetFramework4.8\Sample1 
scancentral -url http://srv-ftfy-x001:8280/scancentral-ctrl/ -ssctoken b95e4457-2157-4f86-864f-00f08f1e022b start -bt msbuild -bf Sample1.sln -bc "/t:Rebuild /p:Configuration=Debug" --application "CSharp Sample" --application-version "VS2019-.NetFramework4.8" --upload-to-ssc --ssc-upload-token b95e4457-2157-4f86-864f-00f08f1e022b
Echo "*** Finishing CSharp Sample version VS2019-.NetFramework4.8"
Echo "*** "
pause