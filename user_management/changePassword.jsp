<!-- Takes in the form data from EditPersonalInformation.jsp and updates the 
     users password in the database, if appropriate.  If the password update
     fails (new != confirm, or current != stored), then we display the failure
     to the user.  If the password change is accepted, then we redirect back to
     the home page. -->
<!DOCTYPE html>
<html>
<head>
    <title>Changing Your Password Failed!</title>
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
   String encodeEditInfo = response.encodeURL("/proj1/user_management/editPersonalInformation.jsp");
   if(request.getParameter("updatePassword") != ""){
       //Get the user input from the EditPersonalInformation page
       String stored_pwd = "";
       String current_pwd = (request.getParameter("current_pwd")).trim();
       String new_pwd = (request.getParameter("new_pwd")).trim();
       String confirm_pwd = (request.getParameter("confirm_pwd")).trim();

       // Get our stored value of the password
       String sql = "select password from users where user_name='" + session_user + "'";
       try {
           Statement stmt = conn.createStatement();
           ResultSet rset = stmt.executeQuery(sql);
           if (rset.next())
               stored_pwd = rset.getString(1);
       } catch (Exception ex) {
           System.out.println(ex.getMessage());
       }

       if (!current_pwd.equals(stored_pwd)) {
           // User must prove that they are the current user %>
           <div id='error' style="width:350px">
               <Fieldset>
                   <legend>Failure</legend>
                    Sorry, the password you entered<br>
                    does not match our records.<br>
                    Please try again<br>
                    <a id="buttonstyle" href="<%=encodeEditInfo%>">Back to Edit</a>
                </Fieldset>
            </div>
       <%} else if (!new_pwd.equals(confirm_pwd)) {
           // User must enter the same password twice to prevent mistype problems %>
           <div id='error' style="width:350px">
               <Fieldset>
                   <legend>Failure</legend>
                    Sorry, the new password and<br>
                    confirmed password do not match.<br>
                    Please try again<br>
                    <a id="buttonstyle" href="<%=encodeEditInfo%>">Back to Edit</a>
                </Fieldset>
            </div>
       <% } else {
              try {
                  Statement stmt = conn.createStatement();
                  stmt.executeUpdate("update users set password='" + new_pwd + 
                                     "' where user_name='" + session_user + "'");

                  // Upon success, go back to home
                  response.sendRedirect(encodeHomePage);
              } catch (Exception ex) {
                  System.out.println(ex.getMessage());
              }
           }
        }%>
        </div>
    <%@ include file="../util/dbLogout.jsp"%>
</div>
</BODY>
</HTML>
