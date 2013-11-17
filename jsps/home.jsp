<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body>
        <div id="container">
            <div id = "header">
                <!--<h1 >CMPUT 391</h1>
                <p>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</p>
                -->
                <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
                <marquee behavior="scroll" direction="left">Creators: Scott Vig, Valerie Sawyer, Zhan Yap</marquee>
                
                
                <%
                    //If there is such attribute as username, this means the user entered this page through
                    //correct navigation (logging in) and is suppose to be here
                    if(request.getSession(false).getAttribute("username") != null){
                        String username = String.valueOf(session.getAttribute("username"));
                        out.println("<p id='username'>"+username+"</p>");
                        
                        String encode = response.encodeURL("logout.jsp");
                        out.println("<A id='signout' href='"+response.encodeURL (encode)+"'>Logout</a>");
                    }
                    //If user entered this page without logging in, redirect user back to main.jsp
                    else{
                        response.sendRedirect("main.jsp");
                    }
                %>
                
                
            </div>
            
            <div class="home">
                    <p>You have successfully login</p>
            </div>
        </div>    
    </body>
    
</html>
