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
            <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
            <marquee behavior="scroll" direction="left"><h4>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</h4></marquee>
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

            %>
        </div>
        
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href="home.jsp">Home Page</a></p>
            <%@include file="db_login.jsp"%>
	<%

	if(request.getParameter("dsubmit") != null){
		int skip = 0;
		String friend = (request.getParameter("friends")).trim();
                username = String.valueOf(session.getAttribute("username")); 
	        String groupName = String.valueOf(session.getAttribute("groupname")); 
		String friendToAdd = "";

	    	java.util.Date utilDate = new java.util.Date();
            	java.sql.Date date = new java.sql.Date(utilDate.getTime());

		Statement stmt = null;
            	
		String sql = "select user_name from persons where '"+friend+"' = user_name AND '"+friend+"' != '"+username+"'";
            	try{
			stmt = conn.createStatement();
		
			//Execute the select statement
			ResultSet friendToAddSet = stmt.executeQuery(sql);
       
        		if (friendToAddSet.next())
  				friendToAdd = friendToAddSet.getString(1);
			else{
				skip = 1;
				if(friend.equals(username))
					out.println("Cannot add yourself as a friend");
				else{
					out.println(friend + " does not exist");
				}
				out.println("<form method=get target=_self>");            
		    		out.println("Add a new friend: <input type=text name=friends maxlength=20><br>");         
            			out.println("<input type=submit value=Submit name = dsubmit>");
			}
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("Friend cannot be added");
            	}
                // getting the group_id of the user who wants to add a friend to their group
	    	if(skip == 0){
	    		sql = "select group_id from groups where '"+username+"' = user_name AND '"+groupName+"' = group_name";

		    	try{
				stmt = conn.createStatement();
		
				//Execute the select statement
				ResultSet groupIDSet = stmt.executeQuery(sql);
	       
				if (groupIDSet.next())
	  				groupID = groupIDSet.getInt(1);
				else
					out.println("group id could not be found");
	
			 }catch(Exception ex){
					out.println("<hr>" + ex.getMessage() + "<hr>");
					out.println("Friend cannot be added because group id is invalid");
		    		}	
		
			// Attempt to add the friend to the group
			out.println("Friend to add: " + friendToAdd + "</p>");
			sql = "Insert into group_lists values ('"+groupID+"','"+friendToAdd+"', DATE'"+date+"', 'notice')";
			try{
				stmt = conn.createStatement();
				//Execute update into the database
				stmt.executeUpdate(sql);
				out.println("\nYou have successfully added " + friend + " to your group"+"</p>");
				out.println("<a href = 'viewOrAddFriends.jsp?group="+groupName+"'>Go back to friends page</a>");
				
		    	} catch(Exception ex){
					out.println("You couldn't add a friend.  Perhaps they were too awesome");
					out.println("<form method=get target=_self>");            
			    		out.println("Add a new friend: <input type=text name=friends maxlength=20><br>");         
		    			out.println("<input type=submit value=Submit name = dsubmit>");
		    		}
		 
		}  
		
		}
	else{
	 if(request.getParameter("cSubmit") != ""){


	    String groupName = request.getParameter("group");
            out.println("Group name: " + groupName);

	    // getting the group_id of the group selected

	   String sql = "select group_id from groups where group_name = '"+groupName+"' AND user_name = '"+username+"'";

	   try{
	    	Statement stmt = conn.createStatement();
		
		//Execute the select statement
		ResultSet groupIDSet = stmt.executeQuery(sql);
       		if (groupIDSet.next()){
  			groupID = groupIDSet.getInt(1);
 
		}
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("could not get group id");
            	}

	
	    // listing the friends the user added to their group
	    sql = "select friend_id from group_lists where '"+groupID+"' = group_id";
	    
            try{
	    	Statement stmt = conn.createStatement();

		//Execute the select statement
		ResultSet friendSet = stmt.executeQuery(sql);
		out.println("<table border='1'>");
	    	out.println("<tr>");
		
		if(friendSet.next()){
			out.println("<th>friends</th>");
            		out.println("</tr>");
			out.println("<tr>");
  			String friendName = friendSet.getString(1);
			out.println("<td>" + friendName + "</td>");
     			out.println("</tr>");
			while (friendSet.next()){
				out.println("<tr>");
  				friendName = friendSet.getString(1);
				out.println("<td>" + friendName + "</td>");
				out.println("</tr>");
			}
		}
		else
	    		out.println("<th>You have no friends in this group</th>");
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
            	}
	    out.println("</table>");
            session.setAttribute("groupname",groupName);
	    out.println("<form method=get target=_self>");            
            out.println("Add a new friend: <input type=text name=friends maxlength=20><br>");         
            out.println("<input type=submit value=Submit name = dsubmit>");
	}
}
%>
<%@include file="db_logout.jsp"%>

        </div>
    </body>
</html>
