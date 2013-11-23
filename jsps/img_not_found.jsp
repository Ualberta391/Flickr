<!DOCTYPE html>
<html>
    <head>
        <title>Image Not Found</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
        <div id = "header">
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
                String encodePictureBrowse = response.encodeURL("PictureBrowse.jsp");
            %>
        </div>
        
        <div id="container">
            <div id="error">
                <Fieldset>
                    <legend>Error</legend>
                    <h2><b>Image not found!</b></h2>
                    <form action=<%=encodePictureBrowse%>>
                        <input type='submit' value='Back to Picture List'>
                    </form>
                </Fieldset>
            </div>
        </div>
    </body>
</html>
