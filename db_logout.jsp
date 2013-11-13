<%
    try {
        conn.close();
    } catch (SQLException ex) {
        out.println(ex.getMessage());
    }
%>
