<!-- Displays the home module, which shows all actions 
     available to the user in a convenient menu form -->
<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="util/addHeader.jsp"%>
    <div id="container">
        <div id="subContainer">
        <Fieldset>
        <legend>Actions</legend>
        
        <%
        String groupInfo = response.encodeURL("/proj1/security/groupInfo.jsp");
        String upload = response.encodeURL("/proj1/uploading/uploadImage.jsp");
        String view = response.encodeURL("/proj1/display/pictureBrowse.jsp");
        String search = response.encodeURL("/proj1/search/search.jsp");
        String data = response.encodeURL("/proj1/data_analysis/olap.jsp");
        String edit = response.encodeURL("/proj1/user_management/editPersonalInformation.jsp");
        %>
        <TABLE>
            <TR VALIGN=TOP ALIGN=LEFT><TD>
                <form ACTION='<%= groupInfo %>' METHOD='link'>
                    <INPUT TYPE='submit' ID="buttonstyle" VALUE='Group Info'>
                </form>
            </TD></TR>
            <TR VALIGN=TOP ALIGN=LEFT><TD>      
                <form ACTION='<%= upload %>' METHOD='link'>
                    <INPUT TYPE='submit' ID="buttonstyle" VALUE='Upload Pictures'>
                </form>
            </TD></TR>
            <TR VALIGN=TOP ALIGN=LEFT><TD>
                <form ACTION='<%= view %>' METHOD='link'>
                    <INPUT TYPE='submit' ID="buttonstyle" VALUE='View Pictures'>
                </form>
            </TD></TR>
            <TR VALIGN=TOP ALIGN=LEFT><TD>            
                <form ACTION='<%= search %>' METHOD='link'>
                    <INPUT TYPE='submit' ID="buttonstyle" VALUE='Search Pictures'>
                </form>
            </TD></TR>
            <TR VALIGN=TOP ALIGN=LEFT><TD>            
                <form ACTION='<%= edit %>' METHOD='link'>
                    <INPUT TYPE='submit' ID="buttonstyle" VALUE='Edit Personal Info'>
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
