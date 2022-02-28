<%@ page import="java.io.*" %>
<!doctype html>
<html>
	<head>
		<title>Downloads</title>
	</head>
	<body>
For IDE Plug-ins, AWB Updates and Utilities:
<ul>
	<li><a href="../update-site/eclipse/remediation">Eclipse Remediotion Plug-in Update Site</a></li>
	<li><a href="../update-site/eclipse/security-assistant">Eclipse Security Assistant Update Site</a></li>
	<li><a href="../update-site/installers">Audit Workbench Update Site</a></li>
	<li><a href="https://plugins.jetbrains.com/plugin/18406-fortify-security-assistant" target="_blank">Fortify Security Assistant for ItelliJ</a></li>
	<li><a href="https://marketplace.visualstudio.com/items?itemName=fortifyvsts.fortify-security-assistant-visual-studio" target="_blank">Fortify Security Assistant for Visual Studio</a></li>
	<li><a href="https://marketplace.visualstudio.com/items?itemName=fortifyvsts.fortify-extension-for-vs-code" target="_blank">Fortify Extension for Visual Studio Code</a></li>
	<li><a href="https://hub.docker.com/r/fortifydocker/fortify-ci-tools" target="_blank">Fortify CI Tools - Docker Container</a></li>	
	<li><a href="https://marketplace.visualstudio.com/items?itemName=fortifyvsts.hpe-security-fortify-vsts" target="_blank">Azure DevOps Plug-in</a></li>
	<li><a href="https://plugins.jenkins.io/fortify/" target="_blank">Jenkins Plugin</a></li>
	<!--li><a href="https://github.com/fortify-ps/fortify-integration-sonarqube" target="_blank">Fortify SonarQube Plugin</a></li-->
</ul>
For License File:
<ul>
	<li><a href="../get-license">Fortify License File (requires authentication)</a></li>
</ul>
For Downloads:
<ul>
<% 
String file = application.getRealPath("/downloads");
File f = new File(file);
String [] fileNames = f.list();
File [] fileObjects= f.listFiles();
for (int i = 0; i < fileObjects.length; i++) {
	if(!fileObjects[i].isDirectory()){
		String fname = fileNames[i];
		if (!fname.equals("readme.txt") && !fname.endsWith(".jsp")){
%>
			<li><a href="<%=fileNames[i]%>"><%=fileNames[i]%></a></li>
<%
		}
	}
}
%>
</ul>
For Additional Information: 
<ul>
	<li><a href="https://marketplace.microfocus.com/fortify/category/all" target="_blank">Fortify Marketplace</a></li>
	<li><a href="https://www.microfocus.com/fortify-integrations" target="_blank">Fortify Integration Ecosystem</a></li>
	<li><a href="https://www.youtube.com/c/FortifyUnplugged" target="_blank">Fortify Unplugged</a></li>
	<li><a href="https://www.microfocus.com/fortify-languages" target="_blank">Fortify Language Coverage</a></li>
	<li><a href="https://www.microfocus.com/documentation/fortify-software-security-center" target="_blank">Fortify Software Security Center online documentation</a></li>
	<li><a href="https://www.microfocus.com/documentation/fortify-static-code-analyzer-and-tools" target="_blank">Fortify Static Code Analyzer online documentation</a></li>
	<li><a href="https://www.microfocus.com/documentation/fortify-webinspect" target="_blank">Fortify WebInspect online documentation</a></li>
	<li><a href="https://www.microfocus.com/documentation/fortify-ScanCentral-DAST" target="_blank">Fortify ScanCentral DAST online documentation</a></li>
	<li><a href="https://vulncat.fortify.com/" target="_blank">Fortify Taxonomy</a></li>
</ul>
	</body>
</html>
