<!-- Takes in the form data from EditPersonalInformation.jsp and updates the database -->
<!DOCTYPE html>
<html>
<head>
    <title>Update Your Personal Information</title>
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
</head>
<body> 
<%@ page import="java.sql.*, java.util.*" %>
<%@include file="../util/addHeader.jsp"%>
<div id="container">
    <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
<div id="subContainer" style="width:400px">
<%@include file="../util/dbLogin.jsp"%>
<% 
   String encode = response.encodeURL("/proj1/home.jsp");
   if(request.getParameter("updateSubmit") != ""){
       //Get the user input from the EditPersonalInformation page
       String first_name = (request.getParameter("first")).trim();
       String last_name = (request.getParameter("last")).trim();
       String address = (request.getParameter("address")).trim();
       String email = (request.getParameter("email")).trim();
       String phone = (request.getParameter("phone")).trim();

       String sql = ("update persons set first_name='" + first_name +
                     "',last_name='" + last_name + "',address='" + address +
                     "',email='" + email + "',phone='" + phone + "' where " +
                     "user_name='" + session_user + "'");
       //If email has been taken, it will notifty the user
       try {
           Statement stmt = conn.createStatement();
           //Update the table persons
           stmt.executeUpdate(sql);
           //After the user has successfully registered an account with us, 
           //we will redirect the user to his homepage
           response.sendRedirect(encode);
       } catch(Exception ex) {
        //Display to the user an error if he provided an email
        //that has already been taken %>
        <div id='error'>
            <Fieldset>
                <legend>Failure</legend>
                Sorry, the email you provided has been used.
                <br>Email: <%=email%>
                <br>Please select a different one.
                <br><a id="buttonstyle" href=<%=encode %>>Back to Home</a>
            </Fieldset>
        </div>
    <%}}%>
    <%@ include file="../util/dbLogout.jsp"%>
</div>
</BODY>
</HTML>
