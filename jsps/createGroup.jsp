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
            
           <% 
	    Connection conn = null;
	
	    String driverName = "oracle.jdbc.driver.OracleDriver";
            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	    try{
		//load and register the driver
        	Class drvClass = Class.forName(driverName); 
	        DriverManager.registerDriver((Driver) drvClass.newInstance());
            }
	    catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	    }
	
            try{
	        //establish the connection 
		conn = DriverManager.getConnection(dbstring,"vsawyer1","toffees1");
        	conn.setAutoCommit(false);
	    }
            catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
            }
 	    
	    // listing the groups of the user
	    String sql = "select group_name from groups where '"+username+"' = user_name";

            try{
	    	Statement stmt = conn.createStatement();
		String viewOrAddFriends = response.encodeURL("viewOrAddFriends.jsp");  
		//Execute the select statement
		ResultSet groupSet = stmt.executeQuery(sql);
       		while (groupSet.next()){
  			String groupName = groupSet.getString(1);
			session.setAttribute("groupName", groupName);
			out.println("<a href = 'viewOrAddFriends.jsp?group="+groupName+"'>"+groupName+"</a>");
           
            		//out.println("</form>");
		}
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("List of groups could not be shown");
            	}

		
            String group = response.encodeURL("group.jsp");  
            out.println("<form NAME='GroupForm' ACTION='"+group+"' METHOD='post'>");
            out.println("<TABLE>");
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD><B>Create a new group:</B></TD>");
            out.println("<TD><INPUT TYPE='text' NAME='groupname' MAXLENGTH='20' VALUE='Group name'><BR></TD>");
            out.println("</TR>");
	
            out.println("</TABLE>");
            out.println("<INPUT TYPE='submit' NAME='cSubmit' VALUE='Submit'>");
	
	
            out.println("</form>");

	    // listing the groups the user is a part of
	    /*String sql = "select group_id from groups_list where '"+username+"' = user_name"; 
	    
	    try{
	    	Statement stmt = conn.createStatement();
		String viewOrAddFriends = response.encodeURL("viewOrAddFriends.jsp");  
		//Execute the select statement
		ResultSet groupSet = stmt.executeQuery(sql);
       		while (groupSet.next()){
  			String groupName = groupSet.getString(1);
			session.setAttribute("groupName", groupName);
			out.println("<a href = 'viewOrAddFriends.jsp?group="+groupName+"'>"+groupName+"</a>");
           
            		//out.println("</form>");
		}
		}catch(Exception ex){
			out.println("<hr>" + ex.getMessage() + "<hr>");
			out.println("List of groups could not be shown");
            	}*/



%>
            
        </div>
    </body>
</html>
