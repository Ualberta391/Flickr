<!-- Specifies a form for the current user to input new data for their
     personal information -->
<!DOCTYPE html>
<html>
<head>
    <title>Edit Personal Information</title>
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    <script>
        function isNumberKey(evt){
            // Javascript to prevent non-numbers from being input into 
            // the phone number field
            var charCode = (evt.which)? evt.which : event.keyCode
            if(charCode>31 && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }
    </script>
</head>
<body> 
    <%@ page import="java.sql.*" %>
    <%@ page import="java.util.*" %>
    <%@include file="../util/addHeader.jsp"%>
    <div id="container">
        <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
        <%@include file="../util/dbLogin.jsp"%>
        <% 
           String firstName = "";
           String lastName = "";
           String address = "";
           String email = "";
           String phone = "";
           String sql = ("select first_name, last_name, address, email, " +
                         "phone from persons where user_name='"+session_user+"'");
           // Select the current information of the user to populate the form
           try {
               Statement stmt = conn.createStatement();
               ResultSet personalInfoSet = stmt.executeQuery(sql);
               if (personalInfoSet.next()){
                   firstName = personalInfoSet.getString(1);
                   lastName = personalInfoSet.getString(2);
                   address = personalInfoSet.getString(3);
                   email = personalInfoSet.getString(4);
                   phone = String.valueOf(personalInfoSet.getInt(5));
               }
           } catch(Exception ex) {
               out.println("<hr>" + ex.getMessage() + "<hr>");
           }
           String encodeUpdateInfo = response.encodeURL("/proj1/user_management/updateInfo.jsp");
           String encodeChangePwd = response.encodeURL("/proj1/user_management/changePassword.jsp");
       %>
    <%@include file="../util/dbLogout.jsp"%>

    <div id="subContainer" style="width:350px">
        <div id="edit">
            <form NAME="EditForm" ACTION="<%=encodeUpdateInfo%>" METHOD="post">
            <Fieldset>
            <legend>Edit Your Personal Information</legend>
            <TABLE>
                <TR VALIGN=TOP ALIGN=LEFT>
                    <TD><B>First Name:</B></TD>
                    <TD><INPUT TYPE="text" NAME="first" MAXLENGTH="24" VALUE="<%=firstName%>"><BR></TD>
                </TR>
                <TR VALIGN=TOP ALIGN=LEFT>
                    <TD><B>Last Name:</B></TD>
                    <TD><INPUT TYPE="text" NAME="last" MAXLENGTH="24" VALUE="<%=lastName%>"></TD>
                </TR>
                <TR VALIGN=TOP ALIGN=LEFT>
                    <TD><B>Address:</B></TD>
                    <TD><INPUT TYPE="text" NAME="address" MAXLENGTH="24" VALUE="<%=address%>"></TD>
                </TR>
                <TR VALIGN=TOP ALIGN=LEFT>
                    <TD><B>Email:</B></TD>
                    <TD><INPUT TYPE="text" NAME="email" MAXLENGTH="24" VALUE="<%=email%>"></TD>
                </TR>
                <TR VALIGN=TOP ALIGN=LEFT>
                    <TD><B>Phone:</B></TD>
                    <TD><INPUT TYPE="number" NAME="phone" MAXLENGTH="128" VALUE="<%=phone%>" onkeypress="return isNumberKey(event)"></TD>
                </TR>
            </TABLE>
                <INPUT TYPE="submit" ID="buttonstyle" NAME="updateSubmit" VALUE="Update Information">
            </Fieldset>
            </form>
        </div>
    </div>
    <div id="subContainer" style="width:350px">
        <div id="edit">
        <form NAME="PasswordForm" ACTION='<%=encodeChangePwd%>' METHOD="post">
        <Fieldset>
        <legend>Change Your Password</legend>
        <table>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Current Password:</B></TD>
                <TD><INPUT TYPE="password" NAME="current_pwd" MAXLENGTH="24" VALUE=""></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>New Password:</B></TD>
                <TD><INPUT TYPE="password" NAME="new_pwd" MAXLENGTH="24" VALUE=""></TD>
            </TR>
            <TR VALIGN=TOP ALIGN=LEFT>
                <TD><B>Confirm Password:</B></TD>
                <TD><INPUT TYPE="password" NAME="confirm_pwd" MAXLENGTH="24" VALUE=""></TD>
            </TR>
        </table>
            <INPUT TYPE="submit" ID="buttonstyle" NAME="updatePassword" VALUE="Update Password">
        </Fieldset>
        </form>
    </div>
    </div>
    </div>
</BODY>
</HTML>
