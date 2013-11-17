<!DOCTYPE html>

<html>
<head>
    <title>Main</title>
    <link rel="stylesheet" type="text/css" href="mystyle.css">
</head>

<body>
    
    <div id="container">
    <div id = "header">
        <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
        <marquee behavior="scroll" direction="left">Creators: Scott Vig, Valerie Sawyer, Zhan Yap</marquee>
    </div>
    
    <div id="register">
    <form NAME="RegisterForm" ACTION="register.jsp" METHOD="post">
        <Fieldset>
        <legend>Sign Up</legend>
        <TABLE>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Username:</B></TD>
                <TD><INPUT TYPE="text" NAME="username" MAXLENGTH="20" VALUE="Username"><BR></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Password:</B></TD>
                <TD><INPUT TYPE="password" NAME="password" MAXLENGTH="20" VALUE="Password"></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>First Name:</B></TD>
                <TD><INPUT TYPE="text" NAME="first" MAXLENGTH="20" VALUE="First Name"></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Last Name:</B></TD>
                <TD><INPUT TYPE="text" NAME="last" MAXLENGTH="20" VALUE="Last Name"></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Address:</B></TD>
                <TD><INPUT TYPE="text" NAME="address" MAXLENGTH="20" VALUE="Address"></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Email:</B></TD>
                <TD><INPUT TYPE="text" NAME="email" MAXLENGTH="20" VALUE="Email"></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Phone:</B></TD>
                <TD><INPUT TYPE="text" NAME="phone" MAXLENGTH="10" VALUE="Phone"></TD>
            </TR>

        </TABLE>
        <INPUT TYPE="submit" NAME="aSubmit" VALUE="REGISTER">
        </Fieldset>
    </form>
    </div>
    
    <div id="login">
    <form NAME="LoginForm" ACTION="authentication.jsp" METHOD="post">
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
        <INPUT TYPE="submit" NAME="bSubmit" VALUE="LOGIN">
        </Fieldset>
    </form>
    </div>
    </div>
    
    <%@ page import="java.sql.*" %>
    <%
        //Testing for specific attribute (username) in session, if it is a new session or not
        if(request.getSession(false).getAttribute("username")!= null){
            String encode = response.encodeURL("home.jsp");
            response.sendRedirect(encode);  
        }
        else{
            out.println("Index : session is new");
        }
    %>
    
    
</body>
</html>
