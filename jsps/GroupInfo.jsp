<!DOCTYPE html>
<!-- Displays the relevant groups for the current user -->
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="mystyle.css">
</head>
<body> 
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@include file="db_login.jsp"%> 
<%@include file="add_header.jsp"%>
<% 
    String encodeCreateGroup = response.encodeURL("createGroup.jsp");
    ArrayList<String> created_groups = new ArrayList<String>();
    ArrayList<String> friend_of_groups = new ArrayList<String>();

    // Get the list of groups that the user has created
    String sql = "select group_name from groups where user_name='" + session_user + "'";
    try {
        Statement stmt = conn.createStatement();

        //Execute the select statement
        ResultSet groupSet = stmt.executeQuery(sql);
        while (groupSet.next())
            created_groups.add(groupSet.getString(1));
    } catch(Exception ex) {
        out.println("<hr>" + ex.getMessage() + "<hr>");
        out.println("List of groups could not be shown");
    }
     
    // Get the group_ids of the groups that the user is a part of
    sql = ("select g.group_name from groups g, group_lists gl " +
           "where g.group_id = gl.group_id " +
           "and friend_id='" + session_user + "'");
    try { 
        Statement stmt = conn.createStatement();
        ResultSet groupIdSet = stmt.executeQuery(sql);
        while (groupIdSet.next()) 
            friend_of_groups.add(groupIdSet.getString(1));
    } catch (Exception ex) {

    }
%>
<div id="container">
    <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
    <div id="subContainer" style="width:500px">
        <center>
        <TABLE border='1'>
        <TR VALIGN=TOP ALIGN=LEFT>
            <TD>List of Groups You Created</TD>
        </TR>
        <% for (String created_group_name : created_groups) {
               String friends = "viewOrAddFriends.jsp?group=" + created_group_name;
               String encodeAddFriends = response.encodeURL(friends); %>
               <TR VALIGN=TOP ALIGN=LEFT>
                   <TD><a href='<%=encodeAddFriends%>'><%=created_group_name%></a></TD>
               </TR>
        <%}%>
        </TABLE>

        <TABLE border='1'>
        <TR VALIGN=TOP ALIGN=Right>
            <TD>List of Groups you are a part of</TD>
        </TR>
        <% for (String group_name : friend_of_groups) {
               String friend_groups = "showNotice.jsp?group=" + group_name;
               String encodeSeeNotices = response.encodeURL(friend_groups); %>
               <TR VALIGN=TOP ALIGN=LEFT>
                   <TD><a href='<%=encodeSeeNotices%>'><%=group_name%></a></TD>
               </TR>
        <%}%>
        </center>
    </div>
    <form NAME='GroupForm' ACTION='<%=encodeCreateGroup%>' METHOD='post'>
        <TABLE>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Create a new group:</B></TD>
                <TD><INPUT TYPE='text' NAME='groupname' MAXLENGTH='24' VALUE='Group name'><BR></TD>
            </TR>
        </TABLE>
        <INPUT TYPE='submit' NAME='cSubmit' VALUE='Submit'>
    </form>
    <%@include file="db_logout.jsp"%>
    </div>
</body>
</html>
