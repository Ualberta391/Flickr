<!DOCTYPE html>
<html>
<head>
<title>Creating a group</title>
<link rel="stylesheet" type="text/css" href="mystyle.css">
<script>
    function isNumberKey(evt){
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
<%@include file="add_header.jsp"%>
<div id="container">
    <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
<div id="subContainer" style="width:400px">
    <%@include file="db_login.jsp"%>
    <% 
    String firstName = "";
    String lastName = "";
    String address = "";
    String email = "";
    String phone = "";
    String sql = ("select first_name, last_name, address, email, " +
                  "phone from persons where user_name='"+session_user+"'");
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
        out.println("List of the groups you are a part of could not be shown");
    }
    String encodeUpdateInfo = response.encodeURL("UpdateInfo.jsp");
   %>

<div id="container">
    <div id="edit">
        <form NAME="EditForm" ACTION=<%=encodeUpdateInfo%> METHOD="post">
        <Fieldset>
        <legend>Edit</legend>
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
            <INPUT TYPE="submit" ID="buttonstyle" NAME="updateSubmit" VALUE="Update">
        </Fieldset>
        </form>
    </div>
<%@include file="db_logout.jsp"%>
</div>
</div>
</BODY>
</HTML>
