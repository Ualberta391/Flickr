<!DOCTYPE html>
<html>
    <head>
        <title>Upload images to online storage!</title>
        <%@ page import="java.util.*" %>
        <%@ page import="java.sql.*" %>
        <%@include file="db_login.jsp"%>
        <%
            ResultSet rset = null;
            
            ArrayList<String> group_names = new ArrayList<String>();
            ArrayList<String> group_ids = new ArrayList<String>();
            
            try {
                Statement stmt = conn.createStatement();
                rset = stmt.executeQuery("select group_id, group_name from groups");
            } catch (Exception ex) {
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
            
            while (rset.next()) {
                group_ids.add(rset.getString("GROUP_ID"));
                group_names.add(rset.getString("GROUP_NAME"));
            }
        %>
        <%@include file="db_logout.jsp"%>
        
        <link rel="stylesheet" type="text/css" href="mystyle.css">
        <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
        <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
        <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
        <link rel="stylesheet" href="/resources/demos/style.css" />
        <script>
            $(function() {
                $( "#time" ).datepicker({
                    defaultDate: "+1w",
                    changeMonth: true,
                    numberOfMonths: 1,
                });
            });
        </script>
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
                
                //Encode the uploadImage servlet
                String encodeUpload = response.encodeURL("UploadImage");
                
                //Encode the homePage link
		String encodeHomePage = response.encodeURL("home.jsp");
            %>
        </div>
        
        <div id="container">
            <div id="subContainer" style="width:400px">
                <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
                <Fieldset>
                    <legend>Upload Image(s)</legend>
                    Please input or select the path of the image(s)
                    <form name="upload-image" method="POST" enctype="multipart/form-data" action=<%=encodeUpload%>>
                        <table>
                            <tr>
                                <th>File path(s): </th>
                                <td><input name="file-path" type="file" size="30" multiple></input></td>
                            </tr>
                            <tr>
                                <th>Description: </th>
                                <td><input name="description" type="textfield" value=""></td>
                            </tr>
                            <tr>
                                <th>Place: </th>
                                <td><input name="place" type="textfield" value=""></td>
                            </tr>
                            <tr>
                                <th>Subject: </th>
                                <td><input name="subject" type="textfield" value=""></td>
                            </tr>
                            <tr>
                                <th>Security: </th>
                                <td><select name="security">
                                <%
                                    for (int i = 0; i < group_ids.size(); i += 1) { 
                                        out.println("<option value='"+group_ids.get(i)+"'>"+group_names.get(i)+"</option>");
                                    }
                                %>
                                </select></td>
                            </tr>
                            <tr>
                                <th>Date: </th>
                                <td><input id="time" name="time" type="textfield" value=""></td>
                            </tr>
                            <tr>
                                <td><input type="submit" name=".submit" value="Upload"></td>
                            </tr>
                        </table>
                    </form>
                </fieldset>
            </div>
        </div>
    </body>
</html>
