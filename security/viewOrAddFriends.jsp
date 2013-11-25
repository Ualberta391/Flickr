<!DOCTYPE html>
<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <%@ page import="java.sql.*, java.util.*, java.test.*" %>
    <%@include file="../util/dbLogin.jsp"%>
    <% 
       int group_id = 0;
       String group_name = request.getParameter("group");
       String group_owner = "";
       String username = String.valueOf(session.getAttribute("username"));
       String sql = "";

       String encodeGroupInfo = response.encodeURL("/proj1/security/groupInfo.jsp");
       String encodeAddFriend = response.encodeURL("/proj1/security/addFriend.jsp?group=" + group_name);

       java.util.Date utilDate = new java.util.Date();
       java.sql.Date date = new java.sql.Date(utilDate.getTime());
       ArrayList<String> friends = new ArrayList<String>();

       // Get the group_id and group owner associated with the group
       sql = "select group_id, user_name from groups where group_name='" + group_name + "'";
       try {
           Statement stmt = conn.createStatement();
           ResultSet group_id_rset = stmt.executeQuery(sql);
           if (group_id_rset.next()) {
               group_id = group_id_rset.getInt(1);
               group_owner = group_id_rset.getString(2);
           }
       } catch(Exception ex) {
           out.println("<hr>" + ex.getMessage() + "</hr>");
       }

       // Get the current friends associated with the group
       sql = "select friend_id from group_lists where group_id=" + group_id;
       try {
           Statement stmt = conn.createStatement();
           ResultSet friend_rset = stmt.executeQuery(sql);
           while (friend_rset.next())
               friends.add(friend_rset.getString(1));
       } catch(Exception ex) {
           out.println("<hr>" + ex.getMessage() + "</hr>");
       }
    %>
    <%@include file="../util/dbLogout.jsp"%>

<script>
// Javascript for deleting a group, using the DeleteGroup servlet
function deleteGroup() {
    if (confirm("Are you sure you want to delete this group?") == true) {
        $.ajax({url: '/proj1/security/DeleteGroup',
                data: {"id": <%= group_id %>},
                async: false,
                type: 'POST'
               });
        window.location.replace("/proj1/security/groupInfo.jsp");
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
    Group Name: <%=group_name%>
    <TABLE border='1'>
        <TR VALIGN=TOP ALIGN=LEFT>
            <TD>List of Friends</TD>
        </TD>
        <% for (String friend_name : friends) {
               String edit_friend = ("/proj1/security/editFriend.jsp?friend=" + friend_name + 
                                     "&groupID=" + group_id);
               String encodeFriendURL = response.encodeURL(edit_friend); %>
               <TR VALIGN=TOP ALIGN=LEFT>
                   <TD><a href='<%=encodeFriendURL%>'><%=friend_name%></a></TD>
               </TR>
        <%}%>
    </TABLE>
    <form NAME='GroupForm' ACTION='<%=encodeAddFriend%>' METHOD='post'>
        <table>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Add a new friend:</B></TD>
                <TD><INPUT TYPE='text' NAME='friend' MAXLENGTH='24' VALUE=''><BR></TD>
            </TR>
             <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Enter a notice:</B></TD>
                <TD><INPUT TYPE='text' NAME='notice' MAXLENGTH='24' VALUE=''><BR></TD>
            </TR>
        </table>
        <input id="buttonstyle" type='submit' NAME='cSubmit' VALUE='Submit'>
    </form>
    <br>
    <% if (session_user.equals(group_owner)) {%>
        <button id="buttonstyle" onclick="deleteGroup()">Delete Group</button><br><br>
    <%}%>
    <a id='buttonstyle' href='<%=response.encodeURL(encodeGroupInfo)%>'>Back to Groups</a>
    </div>
</div>
</body>
</html>
