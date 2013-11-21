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
		String groupName = "";
		String friendToAdd = "";
		int groupID = 0;
		groupName = String.valueOf(session.getAttribute("groupname")); 
		
		if(request.getParameter("cSubmit") != ""){
		    //int i = 1;
		    //group_id = i;
		    
		    groupName = (request.getParameter("groupname")).trim();
		    out.println("<p>You have successfully create the group '"+ groupName +"'</p>");
		    
		    java.util.Date utilDate = new java.util.Date();
		    java.sql.Date date = new java.sql.Date(utilDate.getTime());
		    
		    Statement stmt = null;
		    
		    //Encode the viewOrAddFriends.jsp page
		    String friends = "viewOrAddFriends.jsp"+"?group="+groupName;
		    String encodeAddFriends = response.encodeURL(friends);
		    
		    //Encode the CreateGroup.jsp page
		    String encodeCreateGroup = response.encodeURL("CreateGroup.jsp");
		    
		    String sql = "Insert into groups values (group_seq.NEXTVAL,'"+username+"','"+groupName+"', DATE'"+date+"')";
		    try{
			stmt = conn.createStatement();
			
			//Execute update into the database
			stmt.executeUpdate(sql);
			out.println("<p><a href = '"+encodeAddFriends+"'>Click here to add friends to this group</a></p>");
			out.println("<p><a href = '"+encodeCreateGroup+"'>Click here to create another group</a></p>");
		    }
		    catch(Exception ex){
			out.println("You couldn't create a group.  You already have a group with that name.");
		    }
		session.setAttribute("groupname",groupName);
		}
	    %>
	    <%@include file="db_logout.jsp"%>
	    </div>
	</div>
    </BODY>
</HTML>
