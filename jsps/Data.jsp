<!DOCTYPE html>
<html>
    <head>
        <title>Main</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>
    <body>
        <div id="container">
            <%@ page import="java.sql.*" %>
            <%@include file="db_login.jsp"%>
            <%
                String user="";
                String subject="";
                String time="";
                
                if(request.getParameter("olapSubmit")!=""){
                    user = request.getParameter("users");
                    subject = request.getParameter("subject");
                    time = request.getParameter("time");
                    /*
                    //If the admin requested "Display number of images for each user" but left the time field empty
                    if(!user.equals("") && time.equals("")){
                        
                        PreparedStatement doSearch = conn.prepareStatement("select owner_name, count(*)"+
                        "from (select i.subject, i.owner_name from images i group by rollup(i.subject, i.owner_name))"+
                        "where owner_name <> 'null' group by owner_name");
                        
                        ResultSet rset=null;
                        try{
                            rset = doSearch.executeQuery();
                        }catch(Exception ex){
                            out.println("SQLException: "+ex.getMessage());
                        }
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        while(rset.next()){
                            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                            out.println("<TD>");
                            out.println("<p>"+rset.getString(1)+"</p>");
                            out.println("</TD>");
                            
                            out.println("<TD>");
                            out.println("<p>"+rset.getString(2)+"</p>");
                            out.println("</TD>");
                            out.println("</TR>");
                        }
                        out.println("</TABLE>");
                    }
                    //If the admin requested "Display number of images for each user for each time"
                    if(!time.equals("") && !user.equals("")){
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        
                        PreparedStatement doSearch = null;
                        if(time.equals("year")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'yy') year,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null'"+
                            "group by trunc(timing,'yy'), owner_name");
                            out.println("<p>Year</p>");
                        }
                        else if(time.equals("month")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'mm') month,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null'"+
                            "group by trunc(timing,'mm'), owner_name");
                            out.println("<p>Month</p>");
                        }
                        else if(time.equals("week")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'ww') week,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null'"+
                            "group by trunc(timing,'ww'), owner_name");
                            out.println("<p>Week</p>");
                        }
                        
                        ResultSet rset1 = null;
                        try{
                            rset1 = doSearch.executeQuery();
                        }catch(Exception ex){
                            out.println("SQLException: "+ex.getMessage());
                        }

                        
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        while(rset1.next()){
                            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                            out.println("<TD>");
                            out.println("<p>"+rset1.getDate(1)+"</p>");
                            out.println("</TD>");
                            
                            out.println("<TD>");
                            out.println("<p>"+rset1.getString(2)+"</p>");
                            out.println("</TD>");
                            
                            out.println("<TD>");
                            out.println("<p>"+rset1.getString(3)+"</p>");
                            out.println("</TD>");
                            out.println("</TR>");
                        }
                        out.println("</TABLE>");
                    }*/
                    //If the admin requested "subject"
                    if(!subject.equals("")){
                        PreparedStatement doSearch = conn.prepareStatement("select subject, count(*)"+
                        "from (select i.subject, i.owner_name from images i group by rollup(i.subject, i.owner_name))"+
                        "where owner_name <> 'null' group by subject");
                        
                        ResultSet rset=null;
                        try{
                            rset = doSearch.executeQuery();
                        }catch(Exception ex){
                            out.println("SQLException: "+ex.getMessage());
                        }
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        out.println("<p>Subject</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        while(rset.next()){
                            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                            out.println("<TD>");
                            out.println("<p>"+rset.getString(1)+"</p>");
                            out.println("</TD>");
                            
                            out.println("<TD>");
                            out.println("<p>"+rset.getString(2)+"</p>");
                            out.println("</TD>");
                            out.println("</TR>");
                        }
                        out.println("</TABLE>");
                    }
                }
            %>
            <%@include file="db_logout.jsp"%>
        </div>
    </body>
</html>
