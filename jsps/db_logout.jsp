<!-- Script to run to close the connection object, logging out of the database -->
<%
    try {
        conn.close();
    } catch (SQLException ex) {
        out.println(ex.getMessage());
    }
%>
