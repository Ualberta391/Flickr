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
            
            String createGroup = response.encodeURL("CreateGroup.jsp");
            String upload = response.encodeURL("UploadImage.jsp");
            String view = response.encodeURL("PictureBrowse");
            String search = response.encodeURL("Search.jsp");
            String data = response.encodeURL("Data.jsp");
            
            
            out.println("<TABLE>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<form ACTION='"+createGroup+"' METHOD='link'>");
            out.println("<INPUT TYPE='submit' NAME='createSubmit' VALUE='Create group'>");
            out.println("</form>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");            
            out.println("<TD>");            
            out.println("<form ACTION='"+upload+"' METHOD='link'>");
            out.println("<INPUT TYPE='submit' NAME='uploadSubmit' VALUE='Upload Pictures'>");
            out.println("</form>");
            out.println("</TD>");            
            out.println("</TR>");            
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");            
            out.println("<TD>");            
            out.println("<form ACTION='"+view+"' METHOD='link'>");
            out.println("<INPUT TYPE='submit' NAME='viewSubmit' VALUE='View Pictures'>");
            out.println("</form>");
            out.println("</TD>");
            out.println("</TR>");            
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");            
            out.println("<TD>");            
            out.println("<form ACTION='"+search+"' METHOD='link'>");
            out.println("<INPUT TYPE='submit' NAME='searchSubmit' VALUE='Search Pictures'>");
            out.println("</form>");
            out.println("</TD>");
            out.println("</TR>");            
            
            if((String.valueOf(session.getAttribute("username"))).equals("admin")){
                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                out.println("<TD>");                
                out.println("<form ACTION='"+data+"' METHOD='link'>");
                out.println("<INPUT TYPE='submit' NAME='dataSubmit' VALUE='View Data'>");
                out.println("</form>");
                out.println("</TD>");
                out.println("</TR>");                
            }
            out.println("</TABLE>");
            %>
            

            </fieldset>
            </div>
        </div>
    </body>
</html>
