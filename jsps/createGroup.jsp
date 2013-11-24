<!-- Script to create a group contained in a jsp.  If successful, 
     redirect to GroupInfo.jsp -->
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@include file="db_login.jsp"%>
<% 
    if(request.getParameter("cSubmit") != "") {
        String group_name = (request.getParameter("groupname")).trim();
        String session_user = String.valueOf(session.getAttribute("username"));

        java.util.Date utilDate = new java.util.Date();
        java.sql.Date date = new java.sql.Date(utilDate.getTime());
        String sql = ("Insert into groups values (group_seq.NEXTVAL,'" + session_user + 
                      "','" + group_name + "', DATE'" + date + "')");

        Statement stmt = conn.createStatement();
        
        //Execute update into the database
        try {
            stmt.executeUpdate(sql);
        } catch(Exception ex) {
            // Group may have already been created
            response.sendRedirect("duplicate_group.jsp");
            return;
        }
        response.sendRedirect("GroupInfo.jsp");
    }
    %>
<%@include file="db_logout.jsp"%>
