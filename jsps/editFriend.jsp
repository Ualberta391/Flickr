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
	    String friend = "";
	    String sql = "";
            String groupIdString = "";
	    Integer groupId;
	    // If the user entered a new notice
	    if(request.getParameter("noticeSubmit") != null){
	        friend = String.valueOf(session.getAttribute("friend")); 
		groupIdString = "" + session.getAttribute("groupID");
		groupId = Integer.valueOf(groupIdString);
		Statement stmt = conn.createStatement();
		String notice = (request.getParameter("notice")).trim();
                
		sql = "update group_lists set notice = '" + notice + "' where group_id = '"+groupId+"' and friend_id = '"+friend+"'";
		stmt.executeUpdate(sql);
		out.println("notice updated");
	    }
	    else
	       friend = request.getParameter("friend");
	    out.println("Friend name: " + friend);
	    out.println("<br>");
	    session.setAttribute("friend", friend);
	    String delete = response.encodeURL("deleteFriend.jsp");
            out.println("<form ACTION='"+delete+"' METHOD='link'>");
            out.println("<INPUT TYPE='submit' NAME='fromeditFriend' VALUE='Delete friend'>");
            out.println("</form>");        
	    groupIdString = "" + session.getAttribute("groupID");
	    groupId = Integer.valueOf(groupIdString);
	    sql = "select notice from group_lists where group_id = '"+ groupId + "' and friend_id = '" + friend +"'";
	    try{
		    Statement stmt = conn.createStatement();
		    ResultSet noticeSet = stmt.executeQuery(sql);
		    while(noticeSet.next()){
			String notice = noticeSet.getString(1);
			out.println("notice you sent to your friend: " + notice);
			out.println("<br>");
		    }
	     }catch(Exception ex){
		    out.println("<hr>" + ex.getMessage() + "<hr>");
		    out.println("could not display notice");
	     }
	     out.println("<form method=get target=_self>");  
	     out.println("Enter a new notice to show your friend: <input type=text name=notice maxlength=24><br>");             
	     out.println("<input type=submit value=Submit name = noticeSubmit>");
	
	    %>
	    <%@include file="db_logout.jsp"%>
	    </div>
        </div>
    </body>
</html>
