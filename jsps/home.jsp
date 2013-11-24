<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
        <div id = "header">
            <!--Dont worry about the code below (its for testing)-->
            <p>&nbsp;</p>
             
            <%
                //If there is such attribute as username, this means the user entered this page through
                //correct navigation (logging in) and is suppose to be here
                if(request.getSession(false).getAttribute("username") != null){
                    String username = String.valueOf(session.getAttribute("username"));
                    out.println("<p id='username'>You are logged in as "+username+"</p>");
                    
                    String encode = response.encodeURL("logout.jsp");
                    out.println("<A id='signout' href='"+response.encodeURL (encode)+"'>(Logout)</a>");
                    
                }
                //If user entered this page without logging in or after logging out, redirect user back to main.jsp
                else{
                    response.sendRedirect("main.jsp");
                }
            %>
        </div>
        
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
            <INPUT TYPE='submit' ID="buttonstyle" NAME='personalInfo' VALUE='Edit Personal Information'>
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
