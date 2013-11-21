<!DOCTYPE html>
<html>
    <head>
        <title>Search Result</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
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
            <%@include file="db_login.jsp"%>
            <%
                out.println("<p class='homePage'>Go back to <A class='homePage' href='"+response.encodeURL("home.jsp")+"'>Home Page</a></p>");
                
                String dFrom = request.getParameter("from");
                String dTo = request.getParameter("to");
                
                //Convert string to java.util.date format and then back into the correct string date format for comparison
                SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
                java.util.Date parsedf = format.parse(dFrom);
                java.util.Date parsedt = format.parse(dTo);
                DateFormat df = new SimpleDateFormat("dd-MMM-yy");  
                String from = df.format(parsedf);
                String to = df.format(parsedt);
                
                out.println(".......from "+from+" to "+to);
                
                //Attempting to search for the pictures
                try{
                    //If the user clicked the button search
                    if(request.getParameter("dateSubmit") != ""){
                        //If user entered something to query
                        if(!(request.getParameter("query").equals(""))){
                            PreparedStatement doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0) WHERE (timing between ? and ?)  ORDER BY RANK DESC");
                            
                            doSearch.setString(1, request.getParameter("query"));
                            doSearch.setString(2, request.getParameter("query"));
                            doSearch.setString(3, request.getParameter("query"));
                            doSearch.setString(4, from);
                            doSearch.setString(5, to);
                            
                            ResultSet rset2 = doSearch.executeQuery();
                            
                            //Printing the result table for confirmation
                            out.println("<table border=1>");
                            out.println("<tr>");
                            out.println("<th>Subject</th>");
                            out.println("<th>Description</th>");
                            out.println("<th>Place</th>");
                            out.println("<th>Time</th>");
                            out.println("<th>Score</th>");
                            out.println("</tr>");
                            
                            while(rset2.next()){
                                   
                                    out.println("<tr>");
                                    out.println("<td>"); 
                                    out.println(rset2.getString(2));
                                    out.println("</td>");
                                    out.println("<td>"); 
                                    out.println(rset2.getString(3)); 
                                    out.println("</td>");
                                    out.println("<td>"); 
                                    out.println(rset2.getString(4)); 
                                    out.println("</td>");
                                    out.println("<td>"); 
                                    out.println(rset2.getDate(5)); 
                                    out.println("</td>");
                                    out.println("<td>");
                                    out.println(rset2.getObject(1));
                                    out.println("</td>");
                                    out.println("</tr>");
                                
                            } 
                            out.println("</table>");
                        }
                        else{
                            out.println("<br><b>Please enter text for quering</b>");
                        }
                    }
                }catch(SQLException e){
                    out.println("SQLException: " +
                    e.getMessage());
                    conn.rollback();
                }
            %>
            <%@include file="db_logout.jsp"%>
        </div>
    </body>
</html>
