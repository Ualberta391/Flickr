<!DOCTYPE html>
<html>
    <head>
        <title>Creating a group</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
	<%@ page import="java.sql.*" %>
	<%@ page import="java.util.*" %>
    <%@include file="add_header.jsp"%>
    <div id="container">
        <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
	<div id="subContainer" style="width:400px">
    <%@include file="db_login.jsp"%>
	<% if(request.getParameter("updateSubmit") != ""){
	    //get the user input from the login page
	    String firstName = (request.getParameter("first")).trim();
	    String lastName = (request.getParameter("last")).trim();
	    String address = (request.getParameter("address")).trim();
	    String email = (request.getParameter("email")).trim();
	    String phone = (request.getParameter("phone")).trim();
	    
	    //Print for verification
        out.println("<p>Your input First Name is "+firstName+"</p>");
        out.println("<p>Your input Last Name is "+lastName+"</p>");
	    out.println("<p>Your input Address is "+address+"</p>");
        out.println("<p>Your input Email is "+email+"</p>");
	    out.println("<p>Your input Phone is "+phone+"</p>");
	    

        Statement stmt = null;
	    String encode = response.encodeURL("home.jsp");
	    String sql = "update persons set first_name = '"+firstName+"',last_name ='"+lastName+"',address='"+address+"',email = '"+email+"', phone = '"+phone+"' where user_name = '"+ session_user+"'";
	    //Attempting to execute both SQL statements
	    //If username or email has been taken, it will notifty the user
            try{
		stmt = conn.createStatement();
		//Update the table persons
		stmt.executeUpdate(sql);
   		//After the user has successfully registered an account with us, we will redirect the user to his homepage
		response.sendRedirect(encode);
		}catch(Exception ex){
		    //Display to the user an error if he provided an email or username that has already been taken
		    out.println("<div id='error'>");
		    out.println("<Fieldset>");
		    out.println("<legend>Actions</legend>");
		    out.println("Sorry, the email you provided has been used or your phone number is not a number.");
		    out.println("Please select a different one.");
		    out.println("<br><a href='main.jsp'>back</a>");
		    out.println("</Fieldset>");
		    out.println("</div>");}

        }%>
        <%@ include file="db_logout.jsp"%>
            
            <!--Code from http://jsfiddle.net/viralpatel/nSjy7/ -->
            <script>
            function isNumberKey(evt){
                var charCode = (evt.which)? evt.which : event.keyCode
                if(charCode>31 && (charCode < 48 || charCode > 57))
                    return false;
                return true;
            }
            </script>
	
	</div>
    </BODY>
</HTML>