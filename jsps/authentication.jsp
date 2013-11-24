<!-- Authenticates a user -->
<HTML>
<HEAD>
    <TITLE>Your Login Result</TITLE>
</HEAD>
<BODY>
<%@include file="db_login.jsp"%>
<%@ page import="java.sql.*" %>
<% if(request.getParameter("bSubmit") != "") {
       //Get the user input from the login page
       String user_name = (request.getParameter("username"));
       String passwd = (request.getParameter("password"));
       if (user_name == null || passwd == null) {
           response.sendRedirect("main.jsp");
           return;
       }

       ResultSet rset = null;
       String truepwd = "";

       //Select the user table from the underlying db and validate
       //the user name and password
       String sql = "select password from users where user_name='" + user_name + "'";

       try{
           Statement stmt = conn.createStatement();
           rset = stmt.executeQuery(sql);
       } catch(Exception ex) {
           out.println("<hr>" + ex.getMessage() + "<hr>");
       }
    
       //If username and password textbox is not empty when click the button "Login"
       if(!user_name.trim().isEmpty() && !passwd.trim().isEmpty()) {
           if (rset.next()) 
               truepwd = (rset.getString(1)).trim();

           //If the password you provided matches the password in the database 
           //according to the username you provided, can successfully log in
           if(passwd.equals(truepwd)){
               out.println("<p><b>Your Login is Successful!</b></p>");
               out.println("<p>You're logged in as "+user_name+"</p>");
               //Set username attribute to session
               session.setAttribute("username",user_name);
               String encode = response.encodeURL("home.jsp");
               response.sendRedirect(encode);
            } else {
               response.sendRedirect("error.html");
            }
    
       } else {
           //Redirect user to error page
           response.sendRedirect("error.html");
       }
    } %>
    <%@include file="db_logout.jsp"%>
</BODY>
</HTML>
