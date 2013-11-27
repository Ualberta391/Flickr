<!-- Module used to handle the registering of a new user -->
<!DOCTYPE html>
<html>
    <head>
        <title>Register</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>

    <body> 
        <div id = "header">
            <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
            <marquee behavior="scroll" direction="left"><h4>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</h4></marquee>
	</div>
	<div id="container">
	<%@ page import="java.sql.*" %>
	<%@ page import="java.util.*"%>
	<%@ include file="../util/dbLogin.jsp"%>
	<% String encodeMain = response.encodeURL("/proj1/user_management/main.jsp");
        
        if(request.getParameter("aSubmit") != ""){
            // Get the register parameters from the request object
            String username = (request.getParameter("username")).trim();
            String password = (request.getParameter("password")).trim();
            String firstName = (request.getParameter("first")).trim();
            String lastName = (request.getParameter("last")).trim();
            String address = (request.getParameter("address")).trim();
            String email = (request.getParameter("email")).trim();
            String phone = (request.getParameter("phone")).trim();
            
            Statement stmt = null;
            
            //Fetch current date
            java.util.Date utilDate = new java.util.Date();
            java.sql.Date date = new java.sql.Date(utilDate.getTime());
            
            String sql1 = ("Insert into Users values('" + username + 
                           "','" + password + "',date'" + date + "')");

            String sql2 = ("Insert into Persons values ('" + username + 
                           "','" + firstName + "','" + lastName + "','" + address +
                           "','" + email + "'," + phone + ")");
            
            //Attempting to execute both SQL statements
            //If username or email has been taken, it will notifty the user
            try {
                stmt = conn.createStatement();
                //Update the table Users
                stmt.executeUpdate(sql1);
                stmt.executeUpdate("commit");
                try {
                    //Update the table Persons
                    stmt.executeUpdate(sql2);
                    stmt.executeUpdate("commit");
                    //Set username attribute to session
                    session.setAttribute("username",username);
                    String encode = response.encodeURL("/proj1/home.jsp");
                    
                    //After the user has successfully registered an account with us, 
                    //we will redirect the user to his homepage
                    response.sendRedirect(encode);
                } catch(Exception ex) { 
                    //Display to the user an error if he provided an email 
                    //or username that has already been taken %>
                    <div id='error'>
                    <Fieldset>
                        <legend>Actions</legend>
                        Sorry, the email you provided have been used.
                        Please select a different one.
                        <br><a href='<%= encodeMain %>' id="buttonstyle">Back to Login</a>
                    </Fieldset>
                    </div>
                <%
                //If entered this loop, it means the username the user provided 
                //was valid but the email isnt. Have to roll back to prevent 
                // values being incorrectly entered in the database
                    sql1 = "Delete from Users where user_name='"+username+"'";
                    stmt.executeUpdate(sql1);
                    stmt.executeUpdate("commit");
                }
            } catch(Exception ex) {
            //Display to the user an error if he provided an email or 
            //username that has already been taken %>
            <div id='error'>
            <Fieldset>
                <legend>Actions</legend>
                Sorry, the username you provided have been used.
                Please select a different one.
                <br><a href='<%= encodeMain %>' id="buttonstyle">Back to Login</a>
            </Fieldset>
            </div>
           <% 
            }
        }%>
        <%@ include file="../util/dbLogout.jsp"%>
	</div>
    </BODY>
</HTML>
