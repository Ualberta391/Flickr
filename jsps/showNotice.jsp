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
		Statement stmt = conn.createStatement();
   		String groupIdString = request.getParameter("group");
		int groupId = Integer.valueOf(groupIdString);
		String sql = "select notice from group_lists where '"+groupId+"' = group_id and '"+username+"' = friend_id";
		String groupName = request.getParameter("group");

		ResultSet noticeSet = stmt.executeQuery(sql);
		while(noticeSet.next()){
			String notice = noticeSet.getString(1);
			if(notice == null){
				out.println("no notices");
				break;
			}	
			out.println("Notice: " + notice);
		}
                String encode = response.encodeURL("GroupInfo.jsp");
                out.println("<A id='delete' href='"+response.encodeURL (encode)+"'>Go back to group page</a>");
	    %>
	    <%@include file="db_logout.jsp"%>
	    </div>
        </div>
    </body>
</html>
