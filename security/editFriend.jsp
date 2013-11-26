<!-- Module for editing a friend notice or deleting a friend from a group. -->
<!DOCTYPE html>
<html>
<head>
    <title>Edit a Friend</title>
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <%@ page import="java.sql.*, java.util.*, java.text.*" %>
    <%@include file="../util/dbLogin.jsp"%>
    <%
    String friend = request.getParameter("friend");
    int group_id = Integer.valueOf(request.getParameter("groupID"));
    String group_name = "";
    String group_owner = "";
    String notice = "";
    String sql = "select group_name, user_name from groups where group_id=" + group_id;
    try {
        Statement stmt = conn.createStatement();
        ResultSet group_name_set = stmt.executeQuery(sql);
        if (group_name_set.next()) {
            group_name = group_name_set.getString(1);
            group_owner = group_name_set.getString(2);
        }
    } catch (Exception ex) {
        out.println("<hr>" + ex.getMessage() + "</hr>");
    }

    sql = ("select notice from group_lists where group_id='" + group_id +
           "' and friend_id='" + friend + "'");
    try {
        Statement stmt = conn.createStatement();
        ResultSet notice_set = stmt.executeQuery(sql);
        if (notice_set.next())
            notice = notice_set.getString(1);
    } catch (Exception ex) {
        out.println("<hr>" + ex.getMessage() + "</hr>");
    }

    String encodeGroup = response.encodeURL("/proj1/security/viewFriends.jsp?group=" + group_name);
    %>
    <%@include file="../util/dbLogout.jsp"%>
<script>
// Javascript for deleting a friend, using the DeleteFriend servlet
function deleteFriend() {
    if (confirm("Are you sure you want to delete this friend?") == true) {
        $.ajax({url: '/proj1/security/DeleteFriend',
                data: {"id": <%= group_id %>, "friend": "<%= friend %>"},
                async: false,
                type: 'POST'
               });
        window.location.replace("/proj1/security/viewFriends.jsp?group=<%= group_name %>");
    }
}
// Javascript for editing the notice of a friend, using the EditNotice servlet
function editNotice() {
    var new_notice = $("#notice_field").val();
    if (new_notice.length > 0) {
        $.ajax({url: '/proj1/security/EditNotice',
                data: {"friend": "<%= friend %>",
                       "new_notice": new_notice,
                       "group_id": <%= group_id %>},
                async: false,
                type: 'POST'
               });
        window.location.replace("/proj1/security/editFriend.jsp?friend=<%= friend %>&groupID=<%= group_id %>")
    }
}
</script>
</head>
<body> 
<%@include file="../util/addHeader.jsp"%>
<div id="container">
    <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
    <div id="subContainer" style="width:300px">
    <center>
    <b>Friend: <%= friend %></b><br>
    <b>Group: <%= group_name %></b><br>
    <b>Notice: <%= notice %></b><br>
    </center>
    <% if (session_user.equals(group_owner)) { %>
        <!-- Only allow the group owner to edit notices or delete friends -->
        <TABLE>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Enter a new notice:</B></TD>
                <TD><input type='text' id='notice_field' value=''><BR></TD>
            </TR>
        </TABLE>
        <button id="buttonstyle" onclick="editNotice()">Submit New Notice</button>
        <button id="buttonstyle" onclick="deleteFriend()">Delete Friend</button>
    <% } %>
    <a id='buttonstyle' href='<%=response.encodeUrl(encodeGroup)%>'>Back to Group</a>
    </div>
</div>
</body>
</html>
