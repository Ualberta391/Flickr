<!DOCTYPE html>
<html>
    <head>
        <title>DATA CUBE</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
        
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
    </head>

    <body> 
        <%@ page import="java.sql.*, java.text.*, java.util.*" %>
        <%@include file="../util/addHeader.jsp"%>
        <div id="container">
            <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
            <div id="subContainer" style="width:300px">
            <%@include file="../util/dbLogin.jsp"%>
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
                <TABLE border='1'>
                   <TR VALIGN=TOP ALIGN=LEFT>
                       <TD><p>Date</p></TD>
                       <TD><p>Owner</p></TD>
                       <TD><p>Subject</p></TD>
                       <TD><p>Count(*)</p></TD>
                <% while(rset.next()){ %>
                    <TR VALIGN=TOP ALIGN=LEFT>
                        <TD><p><%=rset.getDate(1)%></p></TD>
                        <TD><p><%=rset.getString(2)%></p></TD>
                        <TD><p><%=rset.getString(3)%></p></TD>
                        <TD><p><%=rset.getString(4)%></p></TD>
                    </TR>
                <% } %>
                </TABLE>
            <%} %>
            </div>
            <p>&nbsp;</p>
            <div id='data'>
                <div id='subContainer' style='width:350px'>
                    <form action='<%=response.encodeURL("data.jsp")%>' method='post'>
                        <B>Display the number of images for</B>
                        <TABLE>
                            <TR VALIGN=TOP ALIGN=LEFT>
                                <TD><B>subject</B></TD>
                                <TD><select name='subject'>
                                <option value=''></option>
                                <option value='ALL SUBJECTS'>ALL SUBJECTS</option>
                             <% for (int i =0;i < list_subjects.size();i++){ %>
                                <option value='<%=list_subjects.get(i)%>'><%=list_subjects.get(i)%></option>
                             <%} %>
                                </select></TD>
                            </TR>
                            <TR VALIGN=TOP ALIGN=LEFT>
                                <TD><B>User</B></TD>
                                <TD><select name='users'>
                                <option value=''></option>
                                <option value='ALL USERS'>ALL USERS</option>
                             <% for (int i=0; i < list_of_users.size();i++) { %>
                                <option value='<%=list_of_users.get(i)%>'><%=list_of_users.get(i)%></option>
                             <%} %>   
                                </select></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>From</B></TD>
                                 <TD><input type='text' id='from' name='from'/></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>To</B></TD>
                                 <TD><input type='text' id='to' name='to'/></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>Group By</B></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>Year</B></TD>
                                 <TD><select name='timeYear'>
                                      <option value=''></option>
                                      <option value='ALL YEARS'>ALL YEARS</option>
                                  <% for (int i=0; i < list_years.size(); i++) { %>
                                      <option value='<%=list_years.get(i)%>'><%=list_years.get(i)%></option>
                                  <%}%>
                                     </select></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>Month</B></TD>
                                 <TD><select name='timeMonth'>
                                    <option value=''></option>
                                    <option value='ALL MONTHS'>ALL MONTHS</option>
                                    <option value='1'>JAN</option>
                                    <option value='2'>FEB</option>
                                    <option value='3'>MAR</option>
                                    <option value='4'>APR</option>
                                    <option value='5'>MAY</option>
                                    <option value='6'>JUN</option>
                                    <option value='7'>JUL</option>
                                    <option value='8'>AUG</option>
                                    <option value='9'>SEP</option>
                                    <option value='10'>OCT</option>
                                    <option value='11'>NOV</option>
                                    <option value='12'>DEC</option>
                                 </select></TD>
                             </TR>
                             <TR VALIGN=TOP ALIGN=LEFT>
                                 <TD><B>Week</B></TD>
                                 <TD><select name='timeWeek'>
                                    <option value=''></option>
                                    <option value='ALL WEEKS'>ALL WEEKS</option>
                                    <option value='1'>Week 1</option>
                                    <option value='2'>Week 2</option>
                                    <option value='3'>Week 3</option>
                                    <option value='4'>Week 4</option>
                                    <option value='5'>Week 5</option>
                                    </select></TD>
                            </TR>
                            <TR VALIGN=TOP ALIGN=LEFT>
                                <TD><input type='submit' name='olapSubmit' value='Search'></TD>
                            </TR>
                    </form>
            <%@include file="../util/dbLogout.jsp"%>
                </div>
            </div>
        </div>
    </body>
</html>
