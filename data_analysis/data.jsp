<!-- This module displays the -->
<!DOCTYPE html>
<html>
    <head>
        <title>Main</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body>
        <%@include file="../util/addHeader.jsp"%>
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
            <div id="subContainer" style="width:300px">
            <%@ page import="java.sql.*, java.text.*, java.util.*" %>
            <%@include file="../util/dbLogin.jsp"%>
            <%
                String user="";
                String subject="";
                String timeYear="";
                String timeMonth="";
                String timeWeek="";
                String startTime="";
                String endTime="";
                
                //Flags for specific selection by admin
                int userFlag=0;
                int subjectFlag=0;
                int yearFlag=0;
                int monthFlag=0;
                int weekFlag=0;
                int startEndFlag=0;
                
                //Flags to count how many columns to print
                int columnNumber=1;
                
                if(request.getParameter("olapSubmit")!=""){
                    user = request.getParameter("users");
                    subject = request.getParameter("subject");
                    timeYear = request.getParameter("timeYear");
                    timeMonth = request.getParameter("timeMonth");
                    timeWeek = request.getParameter("timeWeek");
                    if(request.getParameter("from")!="" && request.getParameter("to")!=""){
                        startTime = request.getParameter("from");
                        endTime = request.getParameter("to");
                        
                        //Convert date format to correct date format for comparison
                        SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
                        java.util.Date parsedF = format.parse(startTime);
                        java.util.Date parsedT = format.parse(endTime);
                        DateFormat df = new SimpleDateFormat("dd-MMM-yy");
                        startTime = df.format(parsedF);
                        endTime = df.format(parsedT);
                    }
                    
                    //If admin selects user component
                    if(!user.equals("")){
                        //If the admin selects "ALL USERS"
                        if(user.equals("ALL USERS")){
                            userFlag=1;
                        }
                        //If admin selects a specific user
                        else if(!user.equals("ALL USERS")){
                            userFlag=2;
                        }
                    }
                    //If admin selects subject component
                    if(!subject.equals("")){
                        //If the admin selects "ALL SUBJECTS"
                        if(subject.equals("ALL SUBJECTS")){
                            subjectFlag=1;
                        }
                        //If admin selects a specific subject
                        else if(!subject.equals("ALL USERS")){
                            subjectFlag=2;
                        }
                    }
                    //If admin selects time period component only
                    if(!startTime.equals("") && !endTime.equals("") ){
                        startEndFlag=1;
                    }
                    //If admin selects time component without period
                    if(startTime.equals("") && endTime.equals("")){
                        startEndFlag = 0;
                        
                        //If admin selects specific year
                        if(!timeYear.equals("ALL YEARS") && !timeYear.equals("")){
                            startEndFlag = 2;
                            
                            //If admin selects specific month within that year
                            if(!timeMonth.equals("ALL MONTHS") && !timeMonth.equals("")){
                                startEndFlag =3;
                                
                                //If admin selects specific week within that month
                                if(!timeWeek.equals("ALL WEEKS") && !timeWeek.equals("")){
                                    startEndFlag = 4;
                                }
                                
                                //If admin selects all weeks within that month
                                if(timeWeek.equals("ALL WEEKS") && !timeWeek.equals("")){
                                    startEndFlag = 6;
                                }
                            }
                            
                            //If admin selects all months within that year
                            else if(timeMonth.equals("ALL MONTHS") && !timeMonth.equals("")){
                                startEndFlag = 5;
                            }
                        }
                        //If admin selects all year
                        else if(timeYear.equals("ALL YEARS") && !timeYear.equals("")){
                            startEndFlag = 7;
                            
                            //If admin selects all months within that year
                            if(timeMonth.equals("ALL MONTHS") && !timeMonth.equals("")){
                                startEndFlag = 8;
                                
                                //If admin selects all weeks within that month
                                if(timeWeek.equals("ALL WEEKS") && !timeWeek.equals("")){
                                    startEndFlag = 9;
                                }
                            }
                        }
                    }
                    
                    //Getting the correct string for query
                    String query = "select ";
                    
                    //Setting up first part of query which is the "SELECT" section
                    if(startEndFlag==1){
                        query=query+"timing,";
                        columnNumber+=1;
                    }else if(startEndFlag==2 || startEndFlag==7){
                        query=query+"trunc(timing, 'yy') year,";
                        columnNumber+=1;
                    }else if(startEndFlag==3 || startEndFlag==5 || startEndFlag==8){
                        query=query+"trunc(timing, 'mm') month,";
                        columnNumber+=1;
                    }else if(startEndFlag==4 || startEndFlag==6 || startEndFlag==9){
                        query=query+"trunc(timing, 'w') week,";
                        columnNumber+=1;
                    }
                    if(userFlag!=0){
                        query=query+" owner_name,";
                        columnNumber+=1;
                    }
                    if(subjectFlag!=0){
                        query=query+"subject,";
                        columnNumber+=1;
                    }
                    query=query+" count(*) from images ";
                    
                    //Setting up second part of query which is the "CONDITIONAL" section
                    if(startEndFlag==1){
                        query=query+"where (timing between '"+startTime+"' and '"+endTime+"')";
                    }
                    else if(startEndFlag==2 || startEndFlag==5){
                        query=query+"where(extract(year from trunc(timing,'yy'))='"+timeYear+"')";
                    }
                    else if(startEndFlag==3 || startEndFlag==6){
                        query=query+"where (extract(year from trunc(timing,'yy'))='"+timeYear+"') "+
                        "AND (extract(month from trunc(timing,'mm'))='"+timeMonth+"')";
                    }else if(startEndFlag==4){
                        query=query+"where (extract(year from trunc(timing,'yy'))='"+timeYear+"') "+
                        "AND (extract(month from trunc(timing,'mm'))='"+timeMonth+"' "+
                        ") AND to_number(to_char(to_date(timing, 'dd-MM-yy'), 'W'))='"+timeWeek+"'";
                    }
                    if(userFlag==2){
                        if(startEndFlag==0 || startEndFlag==7 || startEndFlag==8 || startEndFlag==9){
                            query = query+" where owner_name='"+user+"'";  
                        }
                        else if(startEndFlag==1 || startEndFlag==2 || startEndFlag==3 || startEndFlag==4 || startEndFlag==5 || startEndFlag==6){
                            query=query+"and owner_name='"+user+"'";
                        }
                    }
                    if(subjectFlag==2){
                        if(userFlag==0 || userFlag==1){
                            if(startEndFlag==0 || startEndFlag==7 || startEndFlag==8 || startEndFlag==9){
                                query=query+" where subject='"+subject+"'";
                            }else if(startEndFlag==1 || startEndFlag==2 || startEndFlag==3 || startEndFlag==4 || startEndFlag==5 || startEndFlag==6){
                                query=query+"and subject='"+subject+"'";
                            }
                        }
                        else if(userFlag==2){
                            query = query+"AND subject='"+subject+"'";
                        }
                    }
                    
                    //Setting up the third part of the query which is the "GROUP" section
                    query=query+" group by(";
                    if(startEndFlag==1){
                        query=query+"timing";
                    }else if(startEndFlag==2 || startEndFlag==7){
                        query=query+"trunc(timing,'yy')";
                    }else if(startEndFlag==3 || startEndFlag==5 || startEndFlag==8){
                        query=query+"trunc(timing,'mm')";
                    }else if(startEndFlag==4 || startEndFlag==6 || startEndFlag==9){
                        query=query+"trunc(timing,'w')";
                    }
                    if(userFlag!=0){
                        if(startEndFlag!=0){
                            query=query+",owner_name";
                        }else if(startEndFlag==0){
                            query=query+"owner_name";
                        }
                    }
                    if(subjectFlag!=0){
                        if(userFlag==0){
                            if(startEndFlag==0){
                                query=query+"subject";
                            }
                            else if(startEndFlag!=0){
                                query=query+",subject";
                            }
                        }else if(userFlag!=0){
                            query=query+",subject";
                        }
                    }
                    query=query+")";
                    
                    //Setting up the forth part of the query which is the "ORDER" section
                    query=query+" order by ";
                    if(startEndFlag==1){
                        query=query+"timing asc";
                    }else if(startEndFlag==2 || startEndFlag==7){
                        query=query+"trunc(timing,'yy') asc";
                    }else if(startEndFlag==3 || startEndFlag==5 || startEndFlag==8){
                        query=query+"trunc(timing,'mm') asc";
                    }else if(startEndFlag==4 || startEndFlag==6 || startEndFlag==9){
                        query=query+"trunc(timing,'w') asc";
                    }
                    if(userFlag!=0){
                        if(startEndFlag!=0){
                            query=query+",nlssort(owner_name,'NLS_SORT=BINARY_CI') asc";
                        }else if(startEndFlag==0){
                            query=query+"nlssort(owner_name,'NLS_SORT=BINARY_CI') asc";
                        }
                    }
                    if(subjectFlag!=0){
                        if(userFlag==0){
                            if(startEndFlag==0){
                                query=query+"nlssort(subject,'NLS_SORT=BINARY_CI') asc";
                            }
                            else if(startEndFlag!=0){
                                query=query+",nlssort(subject,'NLS_SORT=BINARY_CI') asc";
                            }
                        }else if(userFlag!=0){
                            query=query+",nlssort(subject,'NLS_SORT=BINARY_CI') asc";
                        }
                    }
                    
                    //Actualy query processing
                    PreparedStatement doSearch= conn.prepareStatement(query);
                    
                    //Start printing results in a table %>
                    <TABLE border='1'>
                        <TR VALIGN=TOP ALIGN=LEFT>
                    <% if(startEndFlag==1){ %>
                        <TD><p>Time Period</p></TD>
                    <% }else if(startEndFlag==2 || startEndFlag==7){ %>
                        <TD><p>Year</p></TD>
                    <% }else if(startEndFlag==3 || startEndFlag==5 || startEndFlag==8){ %>
                        <TD><p>Month</p> </TD>
                    <% }else if(startEndFlag==4 || startEndFlag==6 || startEndFlag==9){ %>
                        <TD><p>Week</p></TD>
                    <%}
                    
                    if(userFlag!=0){ %>
                        <TD><p>User</p></TD>
                    <%}
                    if(subjectFlag!=0){ %>
                        <TD><p>Subject</p></TD>
                    <%}%>
                    <TD><p>Number of Images</p></TD>
                    </TR>
                    
                    <%try{
                        ResultSet rset = doSearch.executeQuery();
                        while(rset.next()){
                            out.println("<TR VALIGN=TOP ALIGN=LEFT>");
                            if(startEndFlag!=0 && userFlag==0 && subjectFlag==0){ %>
                                <TD><p><%=rset.getDate(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                            <%} else if(startEndFlag==0 && userFlag!=0 && subjectFlag==0){ %>
                                <TD><p><%=rset.getString(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                            <%} else if(startEndFlag==0 && userFlag==0 && subjectFlag!=0){ %>
                                <TD><p><%=rset.getString(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                            <%} else if(startEndFlag!=0 && userFlag!=0 && subjectFlag==0){ %>
                                <TD><p><%=rset.getDate(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                                <TD><p><%=rset.getString(3)%></p></TD>
                            <%} else if(startEndFlag==0 && userFlag!=0 && subjectFlag!=0){ %>
                                <TD><p><%=rset.getString(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                                <TD><p><%=rset.getString(3)%></p></TD>
                            <%} else if(startEndFlag!=0 && userFlag==0 && subjectFlag!=0){ %>
                                <TD><p><%=rset.getDate(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                                <TD><p><%=rset.getString(3)%></p></TD>
                            <%} else if(startEndFlag!=0 && userFlag!=0 && subjectFlag!=0){ %>
                                <TD><p><%=rset.getDate(1)%></p></TD>
                                <TD><p><%=rset.getString(2)%></p></TD>
                                <TD><p><%=rset.getString(3)%></p></TD>
                                <TD><p><%=rset.getString(4)%></p></TD>
                            <%} 
                            out.println("</TR>");
                        }
                    }catch(Exception ex){
                        out.println("SQLException: "+ex.getMessage());
                    }
                }
            %>
            <%@include file="../util/dbLogout.jsp"%>
            </div>
        </div>
    </body>
</html>
