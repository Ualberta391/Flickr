<!-- Specifies a form for uploading images to the database -->
<!DOCTYPE html>
<html>
<head>
    <title>Upload images to online storage!</title>
    <%@ page import="java.util.*" %>
    <%@ page import="java.sql.*" %>
    <%@include file="../util/dbLogin.jsp"%>
    <%
        String encodeUpload = response.encodeURL("/proj1/uploading/UploadImage");
        String username = String.valueOf(session.getAttribute("username"));
        ResultSet rset = null;
        
        ArrayList<String> group_names = new ArrayList<String>();
        ArrayList<String> group_ids = new ArrayList<String>();
        group_ids.add("1");
        group_ids.add("2");
        group_names.add("public");
        group_names.add("private");

        String sql = ("select g.group_id, g.group_name " +
                      "from groups g, group_lists gl " +
                      "where g.group_id = gl.group_id " +
                      "and (g.user_name = '" + username +
                      "' or gl.friend_id = '" + username + "')");
        try {
            Statement stmt = conn.createStatement();
            rset = stmt.executeQuery(sql);
        } catch (Exception ex) {
            out.println("<hr>" + ex.getMessage() + "<hr>");
        }
        
        while (rset.next()) {
            group_ids.add(rset.getString("GROUP_ID"));
            group_names.add(rset.getString("GROUP_NAME"));
        }
    %>
    <%@include file="../util/dbLogout.jsp"%>
    
    <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
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
<%@include file="../util/addHeader.jsp"%>
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
                    for (int i = 0; i < group_ids.size(); i += 1) { %>
                        <option value='<%=group_ids.get(i)%>'><%=group_names.get(i)%></option>
                    <%}%>
                </select></td>
            </tr>
            <tr>
                <th>Date: </th>
                <td><input id="time" name="time" type="textfield" value=""></td>
            </tr>
            <tr>
                <td><input type="submit" ID="buttonstyle" name=".submit" value="Upload"></td>
            </tr>
            </table>
            </form>
        </fieldset>
    </div>
</div>
</body>
</html>
