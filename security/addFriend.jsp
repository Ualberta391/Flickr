<!-- Script to create a group contained in a jsp.  If successful, 
     redirect to groupInfo.jsp -->
<%@ page import="java.sql.*, java.util.*" %>
<%@include file="../util/dbLogin.jsp"%>
<% 
    if(request.getParameter("cSubmit") != "") {
        int group_id = 0;
        String group_name = (request.getParameter("group")).trim();
        String friend_name = (request.getParameter("friend")).trim();
        String notice = (request.getParameter("notice")).trim();
        String session_user = String.valueOf(session.getAttribute("username"));

        if (friend_name.equals("")) {
            response.sendRedirect("/proj1/security/viewOrAddFriends.jsp?group=" + group_name);
            return;
        }

        if (friend_name.equals(session_user)) {
            response.sendRedirect("/proj1/error/invalidFriend.jsp");
            return;
        }

        java.util.Date utilDate = new java.util.Date();
        java.sql.Date date = new java.sql.Date(utilDate.getTime());

        Statement stmt = null;
        String sql = "";

        // Get group ID
        sql = "select group_id from groups where group_name='" + group_name + "'";
        try {
            stmt = conn.createStatement();
            ResultSet group_id_rset = stmt.executeQuery(sql);
            if (group_id_rset.next())
                group_id = group_id_rset.getInt(1);
        } catch(Exception ex) {
            response.sendRedirect("/proj1/error/invalidFriend.jsp");
            return;
        }

        // Check if friend_name actually exists in persons table
        sql = ("select user_name from persons where user_name='" + friend_name + "'");
        try {
            stmt = conn.createStatement();
            ResultSet friend_rset = stmt.executeQuery(sql);
            if (!friend_rset.next()) {
                response.sendRedirect("/proj1/error/invalidFriend.jsp");
                return;
            }
        } catch(Exception ex) {
            response.sendRedirect("/proj1/error/invalidFriend.jsp");
            return;
        }

        sql = ("Insert into group_lists values (" + group_id + ",'" + friend_name +
               "', DATE'" + date + "', '" + notice + "')");
        try {
            stmt = conn.createStatement();
            stmt.executeUpdate(sql);
        } catch(Exception ex) {
            // Friend may have already been added
            response.sendRedirect("/proj1/error/invalidFriend.jsp");
            return;
        }
        response.sendRedirect("/proj1/security/viewOrAddFriends.jsp?group=" + group_name);
    }
    %>
<%@include file="../util/dbLogout.jsp"%>
