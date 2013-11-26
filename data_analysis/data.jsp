<!DOCTYPE html>
<html>
    <head>
        <title>Data Analysis</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body>
        <div id="container">
            <%@ page import="java.sql.*" %>
            <%@include file="../util/dbLogin.jsp"%>
            <%
                String user="";
                String subject="";
                String time="";
                
                if(request.getParameter("olapSubmit")!=""){
                    user = request.getParameter("users");
                    subject = request.getParameter("subject");
                    subject = subject.trim();
                    time = request.getParameter("time");
                    
                    //If the admin requested "Display number of images for each user" but left the time field and subject field empty
                    if(!user.equals("") && time.equals("") && subject.equals("")){
                        
                        PreparedStatement doSearch = conn.prepareStatement("select owner_name, count(*)"+
                        "from (select i.subject, i.owner_name from images i group by rollup(i.subject, i.owner_name))"+
                        "where owner_name <> 'null' group by owner_name order by nlssort(owner_name,'NLS_SORT=BINARY_CI') asc");
                        
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset=null;
                        try{
                            rset = doSearch.executeQuery();
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
                        }catch(Exception ex){
                            out.println("SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin requested "Display number of images for each user for each time" but left the subject field empty
                    if(!time.equals("") && !user.equals("") && subject.equals("")){
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        
                        PreparedStatement doSearch = null;
                        if(time.equals("year")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'yy') year,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing,'yy'), owner_name)"+
                            " order by year asc, nlssort(owner_name,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Year</p>");
                        }
                        else if(time.equals("month")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'mm') month,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing,'mm'), owner_name)"+
                            " order by month asc, nlssort(owner_name,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Month</p>");
                        }
                        else if(time.equals("week")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'ww') week,  owner_name, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing,'ww'), owner_name)"+
                            " order by week asc, nlssort(owner_name,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Week</p>");
                        }
                        
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset1 = null;
                        try{
                            rset1 = doSearch.executeQuery();
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
                            
                        }catch(Exception ex){
                            out.println("SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin requested "subject" but left time and user field empty
                    else if(!subject.equals("") && time.equals("") && user.equals("")){
                        PreparedStatement doSearch = conn.prepareStatement("select subject, count(subject)"+
                        "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                        "where owner_name <> 'null' group by (subject) order by nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                        
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        out.println("<p>Subject</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset2=null;
                        try{
                            rset2 = doSearch.executeQuery();
                            while(rset2.next()){
                                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                                out.println("<TD>");
                                out.println("<p>"+rset2.getString(1)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset2.getString(2)+"</p>");
                                out.println("</TD>");
                                out.println("</TR>");
                            }
                            out.println("</TABLE>");
                            
                        }catch(Exception ex){
                            out.println("1SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin select "subject" and "users" but left timing period empty
                    else if(!subject.equals("") && time.equals("") && !user.equals("")){
                        PreparedStatement doSearch = conn.prepareStatement("select owner_name, subject, count(*)"+
                        "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                        "where owner_name <> 'null' group by (owner_name, subject)"+
                        "order by nlssort(owner_name,'NLS_SORT=BINARY_CI') asc, nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                        
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Subject</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset3=null;
                        try{
                            rset3 = doSearch.executeQuery();
                            while(rset3.next()){
                                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                                out.println("<TD>");
                                out.println("<p>"+rset3.getString(1)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset3.getString(2)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset3.getString(3)+"</p>");
                                out.println("</TD>");
                                out.println("</TR>");
                            }
                            out.println("</TABLE>");
                            
                        }catch(Exception ex){
                            out.println("1SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin select "timing" only
                    else if(subject.equals("") && !time.equals("") && user.equals("")){
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        
                        PreparedStatement doSearch = null;
                        if(time.equals("year")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'yy') year, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'yy'))"+
                            "order by year asc");
                            out.println("<p>Year</p>");
                        }
                        else if(time.equals("month")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'mm') month, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'mm'))"+
                            "order by month asc");
                            out.println("<p>Month</p>");
                        }
                        else if(time.equals("week")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'ww') week, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'ww'))"+
                            "order by week asc");
                            out.println("<p>Week</p>");
                        }
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset4=null;
                        try{
                            rset4 = doSearch.executeQuery();
                            while(rset4.next()){
                                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                                out.println("<TD>");
                                out.println("<p>"+rset4.getDate(1)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset4.getString(2)+"</p>");
                                out.println("</TD>");
                                out.println("</TR>");
                            }
                            out.println("</TABLE>");
                            
                        }catch(Exception ex){
                            out.println("1SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin selects "timing" and "subject" but left the users field empty
                    else if(!subject.equals("") && !time.equals("") && user.equals("")){
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        
                        PreparedStatement doSearch = null;
                        if(time.equals("year")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'yy') year,subject,count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'yy'), subject)"+
                            "order by year asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Year</p>");
                        }
                        else if(time.equals("month")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'mm') month, subject, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'mm'), subject)"+
                            "order by month asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Month</p>");
                        }
                        else if(time.equals("week")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'ww') week, subject, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'ww'), subject)"+
                            "order by week asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Week</p>");
                        }
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Subject</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset5=null;
                        try{
                            rset5 = doSearch.executeQuery();
                            while(rset5.next()){
                                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                                out.println("<TD>");
                                out.println("<p>"+rset5.getDate(1)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset5.getString(2)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset5.getString(3)+"</p>");
                                out.println("</TD>");
                                out.println("</TR>");
                            }
                            out.println("</TABLE>");
                            
                        }catch(Exception ex){
                            out.println("1SQLException: "+ex.getMessage());
                        }
                    }
                    //If the admin selects all "timing", "subject" & "users"
                    else if(!subject.equals("") && !time.equals("") && !user.equals("")){
                        out.println("<TABLE border='1'>");
                        out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                        out.println("<TD>");
                        
                        PreparedStatement doSearch = null;
                        if(time.equals("year")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'yy') year, owner_name, subject, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'yy'), owner_name, subject)"+
                            "order by year asc,nlssort(owner_name,'NLS_SORT=BINARY_CI') asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Year</p>");
                        }
                        else if(time.equals("month")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'mm') month, owner_name, subject, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'mm'), owner_name, subject)"+
                            "order by month asc,nlssort(owner_name,'NLS_SORT=BINARY_CI') asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Month</p>");
                        }
                        else if(time.equals("week")){
                            doSearch = conn.prepareStatement("select trunc(timing, 'ww') week, owner_name, subject, count(*)"+
                            "from (select  i.timing,i.subject, i.owner_name from images i group by rollup(i.timing, i.subject, i.owner_name))"+
                            "where owner_name <> 'null' group by (trunc(timing, 'ww'), owner_name, subject)"+
                            "order by week asc,nlssort(owner_name,'NLS_SORT=BINARY_CI') asc,nlssort(subject,'NLS_SORT=BINARY_CI') asc");
                            out.println("<p>Week</p>");
                        }
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Users</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p>Subject</p>");
                        out.println("</TD>");
                        out.println("<TD>");
                        out.println("<p># of Images</p>");
                        out.println("</TD>");
                        out.println("</TR>");
                        
                        ResultSet rset5=null;
                        try{
                            rset5 = doSearch.executeQuery();
                            while(rset5.next()){
                                out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                                out.println("<TD>");
                                out.println("<p>"+rset5.getDate(1)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset5.getString(2)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset5.getString(3)+"</p>");
                                out.println("</TD>");
                                
                                out.println("<TD>");
                                out.println("<p>"+rset5.getString(4)+"</p>");
                                out.println("</TD>");
                                out.println("</TR>");
                            }
                            out.println("</TABLE>");
                            
                        }catch(Exception ex){
                            out.println("1SQLException: "+ex.getMessage());
                        }
                    }
                }
            %>
            <%@include file="../util/dbLogout.jsp"%>
        </div>
    </body>
</html>
