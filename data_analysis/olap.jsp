<!DOCTYPE html>
<html>
    <head>
        <title>DATA CUBE</title>
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
            <%@ page import="java.sql.*, java.text.*, java.util.*" %>
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
            <div id="subContainer" style="width:300px">
            <%@include file="db_login.jsp"%>
            <%
            ResultSet rset1 = null;
            ResultSet rset2 = null;
            ResultSet rset3 = null;
            
            //To store the list of users
            ArrayList<String> list_of_users = new ArrayList<String>();
            
            //To store the list of all possible years
            ArrayList<String> list_years = new ArrayList<String>();
            
            //To store the list of all possible subjects
            ArrayList<String> list_subjects = new ArrayList<String>();
            
            Statement stmt = null;
            try{
                stmt = conn.createStatement();
                rset1 = stmt.executeQuery("select user_name from users");
                
                //Get the list of users
                while(rset1.next()){
                    list_of_users.add(rset1.getString(1));
                }
            }catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
            
            try{
                stmt = conn.createStatement();
                rset2 = stmt.executeQuery("select extract(year from timing) \"year\" from images group by extract(year from timing)");
                
                //Get the list of years
                while(rset2.next()){
                   list_years.add(rset2.getString(1));
                }
            }catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
            
            try{
                stmt = conn.createStatement();
                rset3 = stmt.executeQuery("select distinct(subject) from images");
                
                //Get the list of years
                while(rset3.next()){
                   list_subjects.add(rset3.getString(1));
                }
            }catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
            
            
            if(request.getParameter("dataSubmit") != ""){
                //Displaying the data cube for the admin    
                PreparedStatement doSearch = conn.prepareStatement("select i.timing, i.owner_name, i.subject, count(*)"+
                "from images i group by cube(i.timing, i.owner_name,i.subject) ");
                    
                ResultSet rset = doSearch.executeQuery();
                %>
                out.println("<TABLE border='1'>");
                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                out.println("<TD>");
                out.println("<p>Date</p>");
                out.println("</TD>");
                out.println("<TD>");
                out.println("<p>Owner</p>");
                out.println("</TD>");
                out.println("<TD>");
                out.println("<p>Subject</p>");
                out.println("</TD>");
                out.println("<TD>");
                out.println("<p>Count(*)</p>");
                out.println("</TD>");
                
                <% while(rset.next()){ %>
                    out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                    out.println("<TD>");
                    out.println("<p><%=rset.getDate(1)></p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(2)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(3)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(4)+"</p>");
                    out.println("</TD>");
                    out.println("</TR>");
                <% } %>
                out.println("</TABLE>");
            }
            out.println("</div>");
            out.println("<p>&nbsp;</p>");
            
            out.println("<div id='data'>");
            out.println("<div id='subContainer' style='width:350px'>");
            out.println("<form action='"+response.encodeURL("data2.jsp")+"' method='post'>");
            
            //This gives the admin the option of selecting what data he/she wants to see
            out.println("<B>Display the number of images for</B>");
            out.println("<TABLE>");
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>subject</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("<select name='subject'>");
            out.println("<option value=''></option>");
            out.println("<option value='ALL SUBJECTS'>ALL SUBJECTS</option>");
            for (int i =0;i< list_subjects.size();i++){
                out.println("<option value='"+list_subjects.get(i)+"'>"+list_subjects.get(i)+"</option>");
            }
            out.println("</select>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>user</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("<select name='users'>");
            out.println("<option value=''></option>");
            out.println("<option value='ALL USERS'>ALL USERS</option>");
            for(int i=0;i<list_of_users.size();i++){
                out.println("<option value='"+list_of_users.get(i)+"'>"+list_of_users.get(i)+"</option>");
            }
            out.println("</select>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>from</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("<input type='text' id='from' name='from'/>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>to</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("<input type='text' id='to' name='to'/>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>group by</B>");
            out.println("</TD>");
            out.println("</TR>");
            
            //Print out all available years
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>Year</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("<select name='timeYear'>");
            out.println("<option value=''></option>");
            out.println("<option value='ALL YEARS'>ALL YEARS</option>");
            for (int i =0;i< list_years.size();i++){
                out.println("<option value='"+list_years.get(i)+"'>"+list_years.get(i)+"</option>");
            }
            out.println("</select>");
            out.println("</TD>");
            out.println("</TR>");
            
            //Print out all months
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>Month</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("</select>");
            out.println("<select name='timeMonth'>");
            out.println("<option value=''></option>");
            out.println("<option value='ALL MONTHS'>ALL MONTHS</option>");
            out.println("<option value='1'>JAN</option>");
            out.println("<option value='2'>FEB</option>");
            out.println("<option value='3'>MAR</option>");
            out.println("<option value='4'>APR</option>");
            out.println("<option value='5'>MAY</option>");
            out.println("<option value='6'>JUN</option>");
            out.println("<option value='7'>JUL</option>");
            out.println("<option value='8'>AUG</option>");
            out.println("<option value='9'>SEP</option>");
            out.println("<option value='10'>OCT</option>");
            out.println("<option value='11'>NOV</option>");
            out.println("<option value='12'>DEC</option>");
            out.println("</select>");
            out.println("</TD>");
            out.println("</TR>");
            
            //Print out list of weeks
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<B>Week</B>");
            out.println("</TD>");
            out.println("<TD>");
            out.println("</select>");                    
            out.println("<select name='timeWeek'>");
            out.println("<option value=''></option>");
            out.println("<option value='ALL WEEKS'>ALL WEEKS</option>");
            out.println("<option value='1'>Week 1</option>");
            out.println("<option value='2'>Week 2</option>");
            out.println("<option value='3'>Week 3</option>");
            out.println("<option value='4'>Week 4</option>");
            out.println("<option value='5'>Week 5</option>");
            out.println("</select>");
            out.println("</TD>");
            out.println("</TR>");
            
            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
            out.println("<TD>");
            out.println("<input type='submit' name='olapSubmit' value='Search'>");
            out.println("</TD>");
            out.println("</TR>");
            out.println("</form>");
            %>
            <%@include file="db_logout.jsp"%>
            </div>
            </div>
        </div>
    </body>
</html>
