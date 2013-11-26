<!-- Script to add a friend contained in a jsp.  If successful, 
     redirect to viewFriends.jsp.  If adding a friend produces an error,
     redirect to error/invalidFriend.jsp

     An error occurs when the attempted friend is:
          * The user himself/herself
          * Already in the group
          * Does not exist in the database
          * Null
-->
<%@ page import="java.sql.*, java.util.*" %>
<%@include file="../util/dbLogin.jsp"%>
<% 
    if(request.getParameter("cSubmit") != "") {
        int group_id = 0;
        String group_name = (request.getParameter("group")).trim();
        String friend_name = (request.getParameter("friend")).trim();
        String notice = (request.getParameter("notice")).trim();
        String session_user = String.valueOf(session.getAttribute("username"));

        // Create URL encodings for success and fail
        String validFriend = "/proj1/security/viewFriends.jsp?group=" + group_name;
        String invalidFriend = "/proj1/error/invalidFriend.jsp?group=" + group_name;
        String encodeValidFriend = response.encodeURL(validFriend);
        String encodeInvalidFriend = response.encodeURL(invalidFriend);

        // If friend_name is null, error out
        if (friend_name.equals("")) {
            response.sendRedirect(encodeValidFriend);
            return;
        }

        // If friend_name is equal to the group owner, error out
        if (friend_name.equals(session_user)) {
            response.sendRedirect(encodeInvalidFriend);
            return;
        }

        java.util.Date utilDate = new java.util.Date();
        java.sql.Date date = new java.sql.Date(utilDate.getTime());

        Statement stmt = null;
        String sql = "";

        // Get group ID from the group_name
        sql = "select group_id from groups where group_name='" + group_name + "'";
        try {
            stmt = conn.createStatement();
            ResultSet group_id_rset = stmt.executeQuery(sql);
            if (group_id_rset.next())
                group_id = group_id_rset.getInt(1);
        } catch(Exception ex) {
            // If accessing the database fails, error out
            response.sendRedirect(encodeInvalidFriend);
            return;
        }

        // Check if friend_name actually exists in persons table
        sql = ("select user_name from persons where user_name='" + friend_name + "'");
        try {
            stmt = conn.createStatement();
            ResultSet friend_rset = stmt.executeQuery(sql);
            if (!friend_rset.next()) {
                // If friend_name does not exist, error out
                response.sendRedirect(encodeInvalidFriend);
                return;
            }
        } catch(Exception ex) {
            // If accessing the database failes, error out
            response.sendRedirect(encodeInvalidFriend);
            return;
        }

        sql = ("Insert into group_lists values (" + group_id + ",'" + friend_name +
               "', DATE'" + date + "', '" + notice + "')");
        try {
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
        } catch(Exception ex) {
            // Friend already exists in the group, raising an integrity
            // constraint error.  Error out
            response.sendRedirect(encodeInvalidFriend);
            return;
        }
        // If we get to this point, the friend was successfully added, redirect 
        // to viewFriends.jsp module
        response.sendRedirect(encodeValidFriend);
    }
    %>
<%@include file="../util/dbLogout.jsp"%>
