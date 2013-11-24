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
	    //
	    if(request.getParameter("dsubmit") != null){
		int skip = 0;
		String friend = (request.getParameter("friends")).trim();
		String notice = (request.getParameter("notice")).trim();
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
			
        	    if (friendToAddSet.next()){
  		    	friendToAdd = friendToAddSet.getString(1);
		    }
		    else{
			skip = 1;
			if(friend.equals(username)){
				out.println("Cannot add yourself as a friend");
			}
			else{
			    out.println(friend + " does not exist");
			}
			out.println("<form method=get target=_self>");            
		    	out.println("Add a new friend: <input type=text name=friends maxlength=24><br>");   
			out.println("Type a notice: <input type=text name=notice maxlength=24><br>");         
            		out.println("<input type=submit value=Submit name = dsubmit>");
		    }
		}catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		    out.println("Friend cannot be added");
            	}
                //Getting the group_id of the user who wants to add a friend to their group
	    	if(skip == 0){
	    	    sql = "select group_id from groups where '"+username+"' = user_name AND '"+groupName+"' = group_name";
			
		    try{
			stmt = conn.createStatement();
			
			//Execute the select statement
			ResultSet groupIDSet = stmt.executeQuery(sql);
			if (groupIDSet.next()){
	  		    groupID = groupIDSet.getInt(1);
			}
			else{
			    out.println("group id could not be found");
			}
		    }catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("Friend cannot be added because group id is invalid");
		    }	
			
		    // Attempt to add the friend to the group
		    out.println("Friend to add: " + friendToAdd + "</p>");
		    
		    //Encode the viewOrAddFriends.jsp page
		    String friends = "viewOrAddFriends.jsp"+"?group="+groupName;
		    String encodeAddFriends = response.encodeURL(friends);
		    
		    sql = "Insert into group_lists values ('"+groupID+"','"+friendToAdd+"', DATE'"+date+"', '"+notice+"')";
		    try{
			stmt = conn.createStatement();
			//Execute update into the database
			stmt.executeUpdate(sql);
			out.println("\nYou have successfully added " + friend + " to your group"+"</p>");
			out.println("<a href = '"+encodeAddFriends+"'>Go back to friends page</a>");
		    } catch(Exception ex){
			out.println("You couldn't add a friend.  Perhaps they were too awesome or they are already your friend");
			out.println("<form method=get target=_self>");            
			out.println("Add a new friend: <input type=text name=friends maxlength=24><br>");  
			out.println("Enter a notice to show your friend: <input type=text name=notice maxlength=24><br>");             
		    	out.println("<input type=submit value=Submit name = dsubmit>");
		    }
		}  
	    }
	    else if(request.getParameter("cSubmit") != ""){
		String groupName = request.getParameter("group");
		String delete = response.encodeURL("deleteGroup.jsp");
		out.println("Group name: " + groupName);

            	out.println("<form ACTION='"+delete+"' METHOD='link'>");
           	out.println("<INPUT TYPE='submit' NAME='fromviewOrAddFriends' VALUE='Delete group'>");
            	out.println("</form>");            

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
		session.setAttribute("groupID", groupID);
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
			out.println("<td>");
			String friendName = friendSet.getString(1);
			String encodeFriend = "editFriend.jsp"+"?friend="+friendName;
		        String encodeFriendURL = response.encodeURL(encodeFriend);
		        out.println("<a href = '"+encodeFriendURL+"'>"+friendName+"</a>");
			out.println("</td>");
			out.println("</tr>");
			while (friendSet.next()){
			    out.println("<tr>");
			    out.println("<td>");
			    friendName = friendSet.getString(1);
		            encodeFriend = "editFriend.jsp"+"?friend="+friendName;
		            encodeFriendURL = response.encodeURL(encodeFriend);
		            out.println("<a href = '"+encodeFriendURL+"'>"+friendName+"</a>");
			    out.println("</td>");
			    out.println("</tr>");
			}
		    }
		    else{
			out.println("<th>You have no friends in this group</th>");
		    }
		}catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		}
		
		out.println("</table>");
		session.setAttribute("groupname",groupName);
		out.println("<form method=get target=_self>");            
		out.println("Add a new friend: <input type=text name=friends maxlength=20><br>");      
		out.println("Type a notice: <input type=text name=notice maxlength=24><br>");      
		out.println("<input type=submit value=Submit name = dsubmit>");
		out.println("<br>");
                String encode = response.encodeURL("GroupInfo.jsp");
                out.println("<A id='delete' href='"+response.encodeURL (encode)+"'>Go back to group page</a>");
	    }
	    %>
	    <%@include file="db_logout.jsp"%>
	    </div>
        </div>
    </body>
</html>
