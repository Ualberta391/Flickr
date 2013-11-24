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
            <div id="subContainer" style="width:500px">
	    <center>
	    <%@include file="db_login.jsp"%> 
	    <% 
		String otherGroupName = "";
		String otherGroups = "";
		// listing the groups of the user
		String sql = "select group_name from groups where '"+username+"' = user_name";
		
		try{
		    Statement stmt = conn.createStatement();
		    
		    //Execute the select statement
		    ResultSet groupSet = stmt.executeQuery(sql);
		    out.println("<TABLE border='1'>");
		    out.println("<TR VALIGN=TOP ALIGN=LEFT>");
		    out.println("<TD>");
		    out.println("List of Groups you created");
		    out.println("</TD>");
		    out.println("</TR>");
		    while (groupSet.next()){
  			String groupName = groupSet.getString(1);
			session.setAttribute("groupName", groupName);
			
			//Encode the viewOrAddFriends.jsp page
			String friends = "viewOrAddFriends.jsp"+"?group="+groupName;
			String encodeAddFriends = response.encodeURL(friends);
			
			out.println("<TR VALIGN=TOP ALIGN=LEFT>");
			out.println("<TD>");
			out.println("<a href = '"+encodeAddFriends+"'>"+groupName+"</a>");
			out.println("</TD>");
			out.println("</TR>");
		    }
		    out.println("</TABLE>");
		}catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		    out.println("List of groups could not be shown");
            	}


		// Getting the group_ids of the groups the user is a part of
		sql = "select group_id from group_lists where '"+username+"' = friend_id"; 
	        ArrayList<Integer> groupIdArray = new ArrayList<Integer>();
		
		try{
		    Statement stmt = conn.createStatement();
		    //Execute the select statement
		    ResultSet groupIdSet = stmt.executeQuery(sql);
		    while (groupIdSet.next()){
  			Integer groupId = groupIdSet.getInt(1);
			groupIdArray.add(groupId);
	
		    }
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("group ids could not be added to array");
            	}

		// displaying the groups the user is a part of
		out.println("<TABLE border='1'>");
		out.println("<TR VALIGN=TOP ALIGN=Right>");
		out.println("<TD>");
		out.println("List of Groups you are a part of");
		out.println("</TD>");
		out.println("</TR>");
		
		for(Integer groupId: groupIdArray){
			sql = "select group_name from groups where '"+groupId+"' = group_id";
			try{
		    		Statement stmt = conn.createStatement();
				ResultSet groupNameSet = stmt.executeQuery(sql);
		    		if (groupNameSet.next())
					otherGroupName = groupNameSet.getString(1);
				else 
					out.println("no group name found with group id " + groupId);
				String groupNameString = groupId.toString();		
				otherGroups = "showNotice.jsp"+"?group="+groupNameString;
				String encodeAddGroups = response.encodeURL(otherGroups);							
				out.println("<TR VALIGN=TOP ALIGN=LEFT>");
				out.println("<TD>");
				out.println("<a href = '"+encodeAddGroups+"'>"+otherGroupName+"</a>");
				out.println("</TD>");
				out.println("</TR>");
			}catch(Exception ex){
		    		out.println("<hr>" + ex.getMessage() + "<hr>");
		    		out.println("List of the groups you are a part of could not be shown");}
		}
		out.println("</center>");
	        out.println("</div>");
		
		String encodeGroup = response.encodeURL("createGroup.jsp");  
		out.println("<form NAME='GroupForm' ACTION='"+encodeGroup+"' METHOD='post'>");
		out.println("<TABLE>");
		out.println("<TR VALIGN=TOP ALIGN=LEFT>");
		out.println("<TD><B>Create a new group:</B></TD>");
		out.println("<TD><INPUT TYPE='text' NAME='groupname' MAXLENGTH='24' VALUE='Group name'><BR></TD>");
		out.println("</TR>");
		out.println("</TABLE>");
		out.println("<INPUT TYPE='submit' NAME='cSubmit' VALUE='Submit'>");
		out.println("</form>");

	    %>
	    <%@include file="db_logout.jsp"%>
        </div>
    </body>
</html>
