<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
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
		String group = "";
		int groupID = 0;
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
	    <div id="subContainer" style="width:300px">
            <%@include file="db_login.jsp"%>
	    <%

		String groupName = String.valueOf(session.getAttribute("groupname"));
		String groupIdString = "" + session.getAttribute("groupID");
		Integer groupId = Integer.valueOf(groupIdString);
		
		Statement stmt = conn.createStatement();
		
		String sql = "delete from group_lists where group_id = '"+groupId+"'"; 
		stmt.executeUpdate(sql);
		
		sql = "delete from groups where group_name = '"+groupName+"' and user_name = '"+username+"'";
		stmt.executeUpdate(sql);

		out.println("group deleted");
		out.println("<br>");
                String encode = response.encodeURL("GroupInfo.jsp");
                out.println("<A id='delete' href='"+response.encodeURL (encode)+"'>Go back to group page</a>");
	    %>
	    <%@include file="db_logout.jsp"%>
	    </div>
        </div>
    </body>
</html>
