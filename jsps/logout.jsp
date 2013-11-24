<html>
    <head>
        <title>Logout</title>
    </head>
    <body>
        <%@ page import="java.sql.*" %>
        
        <%
            //If a user enters this page, it will invalidate the session and then 
            //redirect user to main.jsp
            session.removeAttribute("username");
            session.invalidate();
            response.sendRedirect("main.jsp");
    %>
    </body>
</html>
