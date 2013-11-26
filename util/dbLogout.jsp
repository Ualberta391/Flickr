<!-- Script to run to close the connection object, logging out of the database.
     Extracting this logic to dbLogout.jsp reduces code duplication -->
<%
    try {
        conn.close();
    } catch (SQLException ex) {
        out.println(ex.getMessage());
    }
%>
