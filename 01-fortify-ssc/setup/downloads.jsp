<%@ page import="java.io.*" %>
<!doctype html>
<html>
	<head>
		<title>Downloads</title>
	</head>
	<body>
For Updates:
<ul>
	<li><a href="../update-site/eclipse/remediation">Eclipse Remediotion Plug-in Update Site</a></li>
	<li><a href="../update-site/eclipse/security-assistant">Eclipse Security Assistant Update Site</a></li>
	<li><a href="../update-site/installers">Audit Workbench Update Site</a></li>
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
	</body>
</html>
