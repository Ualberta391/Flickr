<!-- Displays the relevant groups for the current user as two tables:
     one table for the groups that the user has created, and one table
     for the groups that the user is a part of, but did not create -->
<!DOCTYPE html>
<html>
<head>
    <title>Group Information</title>
    <%@ page import="java.sql.*, java.util.*, java.text.*" %>
    <%@include file="../util/dbLogin.jsp"%> 
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
<% 
    String current_user = String.valueOf(session.getAttribute("username"));
    ArrayList<String> created_groups = new ArrayList<String>();
    ArrayList<String> friend_of_groups = new ArrayList<String>();

    String encodeGroupInfo = response.encodeURL("/proj1/security/groupInfo.jsp");
    String encodeDuplicateGroup = response.encodeURL("/proj1/error/duplicateGroup.jsp");

    // Get the list of groups that the user has created
    String sql = "select group_name from groups where user_name='" + current_user + "'";
    try {
        Statement stmt = conn.createStatement();

        //Execute the select statement
        ResultSet groupSet = stmt.executeQuery(sql);
        while (groupSet.next())
            created_groups.add(groupSet.getString(1));
    } catch(Exception ex) {
        out.println("<hr>" + ex.getMessage() + "<hr>");
    }
     
    // Get the group_names of the groups that the user is a part of
    sql = ("select g.group_name from groups g, group_lists gl " +
           "where g.group_id = gl.group_id " +
           "and friend_id='" + current_user + "'");
    try { 
        Statement stmt = conn.createStatement();
        ResultSet group_friend_set = stmt.executeQuery(sql);
        while (group_friend_set.next()) 
            friend_of_groups.add(group_friend_set.getString(1));
    } catch (Exception ex) {
        out.println("<hr>" + ex.getMessage() + "<hr>");
    }
%>
<script>
//Javascript for creating a group, using the CreateGroup servlet
function createGroup() {
    var group_name = $("#group_field").val();
    if (group_name.length > 0) {
        $.ajax({url: '/proj1/security/CreateGroup',
                data: {"group_name": group_name,
                       "user_name": "<%= current_user %>"},
                async: false,
                type: 'POST',
                success: function(data) { 
                    window.location.replace("<%= encodeGroupInfo %>");
                },
                error: function(data) {
                    window.location.replace("<%= encodeDuplicateGroup %>");
                }
               });
    }
}
</script>
</head>
<body> 
<%@include file="../util/addHeader.jsp"%>
<div id="container">
    <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
    <div id="subContainer" style="width:500px">
        <center>
        <TABLE border='1'>
        <TR VALIGN=TOP ALIGN=LEFT>
            <TD>List of Groups You Created</TD>
        </TR>
        <% for (String created_group_name : created_groups) {
               String friends = "/proj1/security/viewOrAddFriends.jsp?group=" + created_group_name;
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
               String friend_groups = "/proj1/security/showNotice.jsp?group=" + group_name;
               String encodeSeeNotices = response.encodeURL(friend_groups); %>
               <TR VALIGN=TOP ALIGN=LEFT>
                   <TD><a href='<%=encodeSeeNotices%>'><%=group_name%></a></TD>
               </TR>
        <%}%>
        </center>
    </div>
    <TABLE>
        <TR VALIGN=TOP ALIGN=LEFT>
            <TD><B>Create a new group:</B></TD>
            <TD><INPUT TYPE='text' NAME='group_field' id='group_field'  MAXLENGTH='24' VALUE='New Group Name'><BR></TD>
        </TR>
    </TABLE>
    <!-- Selecting this button creates the group using the name found in the group_field text input -->
    <button ID="buttonstyle" onclick="createGroup()">Create Group</button>
    <%@include file="../util/dbLogout.jsp"%>
    </div>
</body>
</html>
