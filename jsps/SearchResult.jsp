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
                //imgOption=0 represents "default display image option"
                //imgOption=1 represents "most recent first"
                //imgOption=2 represents "most recent last"
                int imgOption=0;
                
                //dateFlag is 0 if the user did not specify a time constraint in the search
                //dateFlag is 1 if the user did specify a time constraint in the search
                int dateFlag=0;
                
                String dFrom="";
                String dTo="";
                String from="";
                String to="";
                
                //Check for empty query and empty time constraint
                int check=0;
                
                //If the user did enter a time constraint
                if(request.getParameter("from")!="" && request.getParameter("to")!=""){
                    dateFlag=1;
                    dFrom = request.getParameter("from");
                    dTo = request.getParameter("to");
                    
                    //Convert string to java.util.date format and then back into the correct string date format for comparison
                    SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
                    java.util.Date parsedf = format.parse(dFrom);
                    java.util.Date parsedt = format.parse(dTo);
                    DateFormat df = new SimpleDateFormat("dd-MMM-yy");  
                    from = df.format(parsedf);
                    to = df.format(parsedt);
                }
                out.println("<p class='homePage'>Go back to <A class='homePage' href='"+response.encodeURL("home.jsp")+"'>Home Page</a></p>");
                out.println("<center>");
                out.println("<h2>Search Result of '"+request.getParameter("query")+"'</h2>");
                
                //Attempting to search for the pictures
                try{
                    //If the user clicked the button search
                    if(request.getParameter("dateSubmit") != ""){
                        
                        PreparedStatement doSearch=null;
                        
                        //Checking what display image option the user chose
                        String displayImgValue = request.getParameter("rank");
                        if(displayImgValue.equals("Default")){
                            imgOption=0;
                        }else if(displayImgValue.equals("Most Recent First")){
                            imgOption=1;
                        }else if(displayImgValue.equals("Most Recent Last")){
                            imgOption=2;
                        }
                        
                        //If user entered something to query and a time period constraint
                        if(!(request.getParameter("query").equals("")) && dateFlag==1){
                            //If the user selected "default"
                            if(imgOption==0){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0) WHERE (timing between ? and ?)  ORDER BY RANK DESC");
                            }
                            //If the user selected "most recent first"
                            else if(imgOption==1){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0) WHERE (timing between ? and ?)  ORDER BY TIMING DESC");
                            }
                            //If the user selected "most recent last"
                            else if(imgOption==2){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0) WHERE (timing between ? and ?)  ORDER BY TIMING ASC");
                            }
                            
                            doSearch.setString(1, request.getParameter("query"));
                            doSearch.setString(2, request.getParameter("query"));
                            doSearch.setString(3, request.getParameter("query"));
                            doSearch.setString(4, from);
                            doSearch.setString(5, to);
                            
                            check=1;
                        }
                        //If the user entered something to query but not a time period constraint
                        else if(!(request.getParameter("query").equals("")) && dateFlag==0){
                            //If the user selected "default"
                            if(imgOption==0){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0)  ORDER BY RANK DESC");
                            }
                            //If the user selected "most recent first"
                            else if(imgOption==1){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0)  ORDER BY TIMING DESC");
                            }
                            //If the user selected "most recent last"
                            else if(imgOption==2){
                                doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0)  ORDER BY TIMING ASC");
                            }
                            
                            doSearch.setString(1, request.getParameter("query"));
                            doSearch.setString(2, request.getParameter("query"));
                            doSearch.setString(3, request.getParameter("query"));
                            
                            check=1;
                        }
                        //If the user did not enter anything to query but entered a time period constraint
                        else if((request.getParameter("query").equals("")) && dateFlag==1){
                            //If the user selected "default"
                            if(imgOption==0){
                                doSearch = conn.prepareStatement("SELECT permitted, subject,description,place,timing,photo_id FROM images i where i.timing BETWEEN ? AND ? ORDER BY RANK DESC");
                            }
                            //If the user selected "most recent first"
                            else if(imgOption==1){
                                doSearch = conn.prepareStatement("SELECT permitted, subject,description,place,timing,photo_id FROM images i where i.timing BETWEEN ? AND ? ORDER BY TIMING DESC");
                            }
                            //If the user selected "most recent last"
                            else if(imgOption==2){
                                doSearch = conn.prepareStatement("SELECT permitted, subject,description,place,timing,photo_id FROM images i where i.timing BETWEEN ? AND ? ORDER BY TIMING ASC");
                            }
                            
                            doSearch.setString(1, from);
                            doSearch.setString(2, to);
                            
                            check =1;
                        }
                        //If the user did not enter any query or time period constraint
                        else{
                            out.println("Please enter either a query or time period");
                        }
                            
                            
                        //If the user did not enter a query or time period constraint, cannot enter this loop
                        if(check==1){
                            ResultSet rset2 = doSearch.executeQuery();
                            
                            String p_id = "";
                            
                            while(rset2.next()){
                                p_id = (rset2.getObject(6)).toString();
                                //Encode display.jsp link
                                String encodeDisplay1 = response.encodeURL("DisplayImage.jsp");
                                String encodeDisplay2 = "/proj1/"+encodeDisplay1+"?id="+p_id;
                                out.println("<a href='"+encodeDisplay2+"'>");
                                
                                //Encode the servlet GetOnePic
                                String encodeOne1 = response.encodeURL("GetOnePic");
                                String encodeOne2 = "/proj1/"+encodeOne1+"?"+p_id;
                                out.println("<img src='"+encodeOne2+"'></a>");
                                
                                out.println("score "+rset2.getObject(1).toString());
                            } 
                            out.println("</center>");
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
