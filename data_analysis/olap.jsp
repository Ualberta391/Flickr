<!DOCTYPE html>
<html>
    <head>
        <title>OLAP</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
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
                    
                    String encode = response.encodeURL("/proj1/user_management/logout.jsp");
                    out.println("<A id='signout' href='"+response.encodeURL (encode)+"'>(Logout)</a>");
                    
                }
                //If user entered this page without logging in or after logging out, redirect user back to main.jsp
                else{
                    response.sendRedirect("/proj1/main.jsp");
                }
            %>
        </div>
        
        <div id="container">
            <%@include file="../util/dbLogin.jsp"%>
            <%
            ResultSet rset1 = null;
            
            //To store the list of users
            ArrayList<String> list_of_users = new ArrayList<String>();
            
            try{
                Statement stmt = conn.createStatement();
                rset1 = stmt.executeQuery("select user_name from users");
            }catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
            
            //Get the list of users
            while(rset1.next()){
                list_of_users.add(rset1.getString(1));
            }
            
            if(request.getParameter("dataSubmit") != ""){
                /*PreparedStatement doSearch = conn.prepareStatement("select i.timing, i.owner_name, i.subject from images i group by cube(i.timing, i.owner_name,i.subject)");
                ResultSet rset = doSearch.executeQuery();
                out.println("<TABLE border='1'>");
                
                while(rset.next()){
                    out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                    out.println("<TD>");
                    out.println("<p>"+rset.getDate(1)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(2)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(3)+"</p>");
                    out.println("</TD>");
                    out.println("</TR>");
                }
                out.println("</TABLE>");
                */
                
                PreparedStatement doSearch = conn.prepareStatement("select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name)");
                ResultSet rset = doSearch.executeQuery();
                out.println("<TABLE border='1'>");
                
                while(rset.next()){
                    out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                    out.println("<TD>");
                    out.println("<p>"+rset.getDate(1)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(2)+"</p>");
                    out.println("</TD>");
                    
                    out.println("<TD>");
                    out.println("<p>"+rset.getString(3)+"</p>");
                    out.println("</TD>");
                    out.println("</TR>");
                }
                out.println("</TABLE>");
                
            }
            
            out.println("<form action='"+response.encodeURL("/proj/data_analysis/data.jsp")+"' method='post'>");
            //This gives the admin the option of selecting what data he/she wants to see
            out.println("<h3>Display the number of images for each subject :");
            out.println("<INPUT TYPE='text' NAME='subject' VALUE='subject'>");
            out.println(" for each user :");
            out.println("<select name='users'>");
            out.println("<option value=''></option>");
            for(int i=0;i<list_of_users.size();i++){
                out.println("<option value='"+list_of_users.get(i)+"'>"+list_of_users.get(i)+"</option>");
            }
            out.println("</select>");
            out.println("by");
            out.println("<select name='time'>");
            out.println("<option value=''></option>");
            out.println("<option value='year'>Year</option>");
            out.println("<option value='month'>Month</option>");
            out.println("<option value='week'>Week</option>");
            out.println("</select>");
            out.println("</h3>");
            out.println("<input type='submit' name='olapSubmit' value='Search'>");
            out.println("</form>");
            %>
            <%@include file="../util/dbLogout.jsp"%>
        </div>
    </body>
</html>
