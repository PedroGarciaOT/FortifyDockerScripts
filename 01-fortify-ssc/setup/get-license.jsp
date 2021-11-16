<%@ page import="java.io.*" %><%
String home = System.getProperty("user.home");
String licensePath = ".fortify" + File.separator + "fortify.license";
File licenseFile = new File(home, licensePath);
if (licenseFile.exists()) { 
    response.setContentType ("application/txt");
    response.setHeader ("Content-Disposition", "attachment; filename="+licenseFile.getName()+"");

	LineNumberReader reader = null;
    try {
    	reader = new LineNumberReader(new FileReader(licenseFile));

        String line = null;        
        while ((line = reader.readLine()) != null) {
        	out.println(line);
        }        
    }catch(IOException exp) {
%>

Error downloading license file:

<%=exp.getLocalizedMessage()%>

<%
    } finally {
        if(reader != null) {
        	reader.close();
        }
    }
}else{
%>

    Error: License not available!

<%
}
%>