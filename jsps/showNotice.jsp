<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
	<%@ page import="java.sql.*" %>
	<%@ page import="java.util.*" %>
    <%@include file="add_header.jsp"%>
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
	    <div id="subContainer" style="width:300px">
            <%@include file="db_login.jsp"%>
	    <%
		Statement stmt = conn.createStatement();
   		String groupIdString = request.getParameter("group");
		int groupId = Integer.valueOf(groupIdString);
		String sql = "select notice from group_lists where '"+groupId+"' = group_id and '"+session_user+"' = friend_id";
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
