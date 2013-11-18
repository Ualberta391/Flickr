<!DOCTYPE html>
<html>
    <head>
        <title>Search</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
          
        <!--Got this code from "http://jqueryui.com/datepicker/#date-range" -->    
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
        <link rel="stylesheet" href="/resources/demos/style.css" />
        
        <script>
            $(function() {
                $( "#from" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    onClose: function( selectedDate ) {
                        $( "#to" ).datepicker( "option", "minDate", selectedDate );
                    }
                });
                $( "#to" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                    onClose: function( selectedDate ) {
                        $( "#from" ).datepicker( "option", "maxDate", selectedDate );
                    }
                });
            });
        </script>
        <!------------------------------------------------------------------------>
        
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
            <%
            out.println("<p class='homePage'>Go back to <A class='homePage' href='"+response.encodeURL("home.jsp")+"'>Home Page</a></p>");
            
            String encodeSearch = response.encodeURL("SearchResult.jsp");
            %>
           <div id= 'searching'>
            <form action=<%=encodeSearch%>>  
            
                    <Fieldset>
                        <legend>Search</legend>
                        <TABLE>
                            <TR VALIGN=TOP ALIGN=LEFT>          
                                <TD><B>Search:</B></TD>
                                <TD><INPUT TYPE="text" NAME="query" MAXLENGTH="24"></TD>
                            </TR>
                        
                            <TR VALIGN=TOP ALIGN=LEFT>
                                <TD><B>From:</B></TD>
                                <TD><input type="text" id="from" name="from"/></TD>
                            </TR>
                            
                            <TR VALIGN=TOP ALIGN=LEFT>
                                <TD><B>To:</B></TD>
                                <TD><input type="text" id="to" name="to"/></TD>
                            </TR>  
                        </TABLE>
                        <input type="submit" name="dateSubmit" value="Search">
                    </Fieldset>
                </form>
            </div>
            
        </div>
    </body>
</html>
