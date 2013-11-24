<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@include file="db_login.jsp"%>
<%
    String groupName = String.valueOf(session.getAttribute("groupname"));
    String groupIdString = "" + session.getAttribute("groupID");
    Integer groupId = Integer.valueOf(groupIdString);

    Statement stmt = conn.createStatement();

    String sql = "delete from group_lists where group_id = '"+groupId+"'"; 
    stmt.executeUpdate(sql);

    sql = "delete from groups where group_name = '"+groupName+"' and user_name = '"+session_user+"'";
    stmt.executeUpdate(sql);

    out.println("group deleted");
    out.println("<br>");
            String encode = response.encodeURL("GroupInfo.jsp");
        out.println("<A id='delete' href='"+response.encodeURL (encode)+"'>Go back to group page</a>");
%>
<%@include file="db_logout.jsp"%>
