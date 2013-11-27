<!-- Login page for the user to register a new account or login with an existing account -->
<!DOCTYPE html>
<html>
<head>
<% String encodeHelp = response.encodeURL("/proj1/util/userdoc.jsp"); %>
<title>Main</title>
<link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
<!--Code from http://jsfiddle.net/viralpatel/nSjy7/ -->
<script>
    function isNumberKey(evt){
        // Prevents the user from filling the phone number field with non-numbers
        var charCode = (evt.which)? evt.which : event.keyCode
        if(charCode>31 && (charCode < 48 || charCode > 57))
            return false;
        return true;
    }
</script>
</head>
<body>
    <div id = "header">
        <marquee behavior="scroll" direction="left"><img src="/proj1/media/stupidKid.jpg"></marquee>
        <marquee behavior="scroll" direction="left"><b><h1>Thumbs-Up Storage</h1></b></marquee>
        <marquee behavior="scroll" direction="left"><h4>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</h4></marquee>
    </div>
    <div id="container">
        <a id='userdoc' href='<%= response.encodeUrl(encodeHelp) %>'>Help Menu</a>
        <div id="register">
            <form NAME="RegisterForm" ACTION="/proj1/user_management/register.jsp" METHOD="post">
                <Fieldset>
                <legend>Sign Up</legend>
                <TABLE>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Username:</B></TD>
                        <TD><INPUT TYPE="text" NAME="username" MAXLENGTH="24" VALUE="Username"><BR></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Password:</B></TD>
                        <TD><INPUT TYPE="password" NAME="password" MAXLENGTH="24" VALUE="Password"></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>First Name:</B></TD>
                        <TD><INPUT TYPE="text" NAME="first" MAXLENGTH="24" VALUE="First Name"></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Last Name:</B></TD>
                        <TD><INPUT TYPE="text" NAME="last" MAXLENGTH="24" VALUE="Last Name"></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Address:</B></TD>
                        <TD><INPUT TYPE="text" NAME="address" MAXLENGTH="128" VALUE="Address"></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Email:</B></TD>
                        <TD><INPUT TYPE="text" NAME="email" MAXLENGTH="128" VALUE="Email"></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Phone:</B></TD>
                        <TD><INPUT TYPE="number" NAME="phone" MAXLENGTH="10" VALUE="000000000" onkeypress="return isNumberKey(event)"></TD>
                    </TR>
                </TABLE>
                    <INPUT TYPE="submit" ID="buttonstyle" NAME="aSubmit" VALUE="Register">
                </Fieldset>
            </form>
        </div>
        
        <div id="login">
            <form NAME="LoginForm" ACTION="/proj1/user_management/authentication.jsp" METHOD="post">
                <Fieldset>
                <legend>Login</legend>
                <TABLE>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Username:</B></TD>
                        <TD><INPUT TYPE="text" NAME="username" VALUE="Username"><BR></TD>
                    </TR>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><B>Password:</B></TD>
                        <TD><INPUT TYPE="password" NAME="password" VALUE="Password"></TD>
                    </TR>
                </TABLE>
                    <INPUT TYPE="submit" ID="buttonstyle" NAME="bSubmit" VALUE="Login">
                </Fieldset>
            </form>
        </div>
        <%@ page import="java.sql.*" %>
        <%
            //Testing for specific attribute (username), if it is a new session or not. 
            //If it is not a new session, return the user the home page, 
            //the user must log out to login under another user
            if(request.getSession(false).getAttribute("username")!= null){
                String encode = response.encodeURL("/proj1/home.jsp");
                response.sendRedirect(encode);  
            }
        %>
    </div>
</body>
</html>
