<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>
    <body> 
    <%@include file="add_header.jsp"%>
    <div id="container">
        <div id="subContainer">
        <Fieldset>
        <legend>Actions</legend>
        
        <%
        String groupInfo = response.encodeURL("GroupInfo.jsp");
        String upload = response.encodeURL("UploadImage.jsp");
        String view = response.encodeURL("PictureBrowse.jsp");
        String search = response.encodeURL("Search.jsp");
        String data = response.encodeURL("olap.jsp");
        String edit = response.encodeURL("EditPersonalInformation.jsp");
        %>
        <TABLE>
        
        <TR VALIGN=TOP ALIGN=LEFT><TD>
        <form ACTION='<%= groupInfo %>' METHOD='link'>
        <INPUT TYPE='submit' ID="buttonstyle" NAME='createSubmit' VALUE='Group Info'>
        </form>
        </TD></TR>
        
        <TR VALIGN=TOP ALIGN=LEFT><TD>      
        <form ACTION='<%= upload %>' METHOD='link'>
        <INPUT TYPE='submit' ID="buttonstyle" NAME='uploadSubmit' VALUE='Upload Pictures'>
        </form>
        </TD></TR>
        
        <TR VALIGN=TOP ALIGN=LEFT><TD>
        <form ACTION='<%= view %>' METHOD='link'>
        <INPUT TYPE='submit' ID="buttonstyle" NAME='viewSubmit' VALUE='View Pictures'>
        </form>
        </TD></TR>
        
        <TR VALIGN=TOP ALIGN=LEFT><TD>            
        <form ACTION='<%= search %>' METHOD='link'>
        <INPUT TYPE='submit' ID="buttonstyle" NAME='searchSubmit' VALUE='Search Pictures'>
        </form>
        </TD></TR>

        <TR VALIGN=TOP ALIGN=LEFT><TD>            
        <form ACTION='<%= edit %>' METHOD='link'>
        <INPUT TYPE='submit' ID="buttonstyle" NAME='personalInfo' VALUE='Edit Personal Info'>
        </form>
        </TD></TR>

        <% if((String.valueOf(session.getAttribute("username"))).equals("admin")){ %>
            <TR VALIGN=TOP ALIGN=LEFT><TD>
            <form ACTION='<%= data %>' METHOD='link'>
            <INPUT TYPE='submit' ID="buttonstyle" NAME='dataSubmit' VALUE='View Data'>
            </form>
            </TD></TR>
        <% } %>
        </TABLE>
        </fieldset>
        </div>
    </div>
    </body>
</html>
