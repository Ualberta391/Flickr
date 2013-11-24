<!DOCTYPE html>
<html>
    <head>
        <title>Creating a group</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
	<%@ page import="java.sql.*" %>
	<%@ page import="java.util.*" %>
        <div id = "header">
           <!--Dont worry about the code below (its for testing)-->
            <p>&nbsp;</p>
            
            <%
		String username = "";
		//If there is such attribute as username, this means the user entered this page through
		//correct navigation (logging in) and is suppose to be here
		if(request.getSession(false).getAttribute("username") != null){
		    username = String.valueOf(session.getAttribute("username"));
		    out.println("<p id='username'>You are logged in as "+username+"</p>");
		    
		    String encode = response.encodeURL("logout.jsp");
		    out.println("<A id='signout' href='"+response.encodeURL (encode)+"'>(Logout)</a>");
		    
		}
		//If user entered this page without logging in or after logging out, redirect user back to main.jsp
		else{
		    response.sendRedirect("main.jsp");
		}
		//Encode the homePage link
		String encodeHomePage = response.encodeURL("home.jsp");
            %>
        </div>
        
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
	<div id="subContainer" style="width:400px">
	    <%@include file="db_login.jsp"%>
	    <% 
		String firstName = "";
		String lastName = "";
		String address = "";
		String email = "";
		int phone = 0;
		String sql = "select first_name, last_name, address, email, phone from persons where user_name = '"+username+"'";
		try{
		    Statement stmt = conn.createStatement();
		    ResultSet personalInfoSet = stmt.executeQuery(sql);
		    if (personalInfoSet.next()){
			firstName = personalInfoSet.getString(1);
			lastName = personalInfoSet.getString(2);
			address = personalInfoSet.getString(3);
			email = personalInfoSet.getString(4);
			phone = personalInfoSet.getInt(5);
		     }
		}catch(Exception ex){
		    	out.println("<hr>" + ex.getMessage() + "<hr>");
		    	out.println("List of the groups you are a part of could not be shown");
		}

		String encodeUpdateInfo = response.encodeURL("UpdateInfo.jsp");

	   %>

<div id="container">
            <div id="edit">
                <form NAME="EditForm" ACTION=<%=encodeUpdateInfo%> METHOD="post">
                    <Fieldset>
                    <legend>Edit</legend>
                    <TABLE>
                        <TR VALIGN=TOP ALIGN=LEFT>
                            <TD><B>First Name:</B></TD>
                            <TD><INPUT TYPE="text" NAME="first" MAXLENGTH="24" VALUE=<%=firstName%>><BR></TD>
                        </TR>
                        <TR VALIGN=TOP ALIGN=LEFT>
                            <TD><B>Last Name:</B></TD>
                            <TD><INPUT TYPE="text" NAME="last" MAXLENGTH="24" VALUE=<%=lastName%>></TD>
                        </TR>
                        <TR VALIGN=TOP ALIGN=LEFT>
                            <TD><B>Address:</B></TD>
                            <TD><INPUT TYPE="text" NAME="address" MAXLENGTH="24" VALUE=<%=address%>></TD>
                        </TR>
                        <TR VALIGN=TOP ALIGN=LEFT>
                            <TD><B>Email:</B></TD>
                            <TD><INPUT TYPE="text" NAME="email" MAXLENGTH="24" VALUE=<%=email%>></TD>
                        </TR>
                        <TR VALIGN=TOP ALIGN=LEFT>
                            <TD><B>Phone:</B></TD>
                            <TD><INPUT TYPE="number" NAME="phone" MAXLENGTH="128" VALUE=<%=phone%> onkeypress="return isNumberKey(event)"></TD>
                        </TR>
                    </TABLE>
                        <INPUT TYPE="submit" ID="buttonstyle" NAME="updateSubmit" VALUE="Update">
                    </Fieldset>
                </form>
            </div>
	    <%@include file="db_logout.jsp"%>
	    </div>
	</div>
    </BODY>
</HTML>
