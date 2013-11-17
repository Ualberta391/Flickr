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
            <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
            <marquee behavior="scroll" direction="left"><h4>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</h4></marquee>
             
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

            %>
        </div>
        
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href="home.jsp">Home Page</a></p>

    <!--The user can create a group
	@author  Valerie Sawyer
    -->
	<%@include file="db_login.jsp"%>
	<% 
	String groupName = "";
	String friendToAdd = "";
	int groupID = 0;
	groupName = String.valueOf(session.getAttribute("groupname")); 
	
	 if(request.getParameter("cSubmit") != ""){
           // int i = 1;
	    //group_id = i;
	    //get the user input from the login page
	    username = String.valueOf(session.getAttribute("username")); 
	    session.setAttribute("username",username);
            groupName = (request.getParameter("groupname")).trim();
            out.println("<p>Group name is "+ groupName +"</p>");

	    java.util.Date utilDate = new java.util.Date();
            java.sql.Date date = new java.sql.Date(utilDate.getTime());
          
            Statement stmt = null;
 
            String sql = "Insert into groups values (group_seq.NEXTVAL,'"+username+"','"+groupName+"', DATE'"+date+"')";
	    try{
		stmt = conn.createStatement();
		
		//Execute update into the database
		stmt.executeUpdate(sql);
		out.println("\nYou have successfully created a group");
		out.println("<a href = 'viewOrAddFriends.jsp?group="+groupName+"'>Add friends</a>");
            }
	    catch(Exception ex){
		out.println("You couldn't create a group.  You already have a group with that name.");
            }
            session.setAttribute("groupname",groupName);

        }%>
        <%@include file="db_logout.jsp"%>
    </BODY>
</HTML>
