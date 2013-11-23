<html>
<head>
<title>Photo List</title>
<link rel='stylesheet' type='text/css' href='mystyle.css'>
<%@include file="db_login.jsp"%>
<%
    List<String> valid_ids = new ArrayList<String>();
    String encodeUpload = response.encodeURL("UploadImage.jsp");

    String username = String.valueOf(session.getAttribute("username"));
    String pic_id = "";
    String owner_name = "";
    int permitted = 0;
    boolean is_friend = false;

    Statement stmt1 = conn.createStatement();
    Statement stmt2 = conn.createStatement();
    ResultSet rset = stmt1.executeQuery("select photo_id from images");
    while (rset.next()) {
        pic_id = rset.getObject(1).toString();
        ResultSet rset2 = stmt2.executeQuery("select owner_name, permitted from images where photo_id="+pic_id);
        if (rset2.next()) {
            owner_name = rset2.getString(1);
            permitted = rset2.getInt(2);
        }

        ResultSet rset3 = stmt2.executeQuery("select friend_id from group_lists where group_id="+permitted);
        while (rset3.next()) {
            if (rset3.getString(1).equals(username))
                is_friend = true;
        }
        if (owner_name.equals(username) || permitted == 1 || username.equals("admin") || is_friend)
            valid_ids.add(pic_id);
    }
    stmt1.close();
    stmt2.close();
%>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<%@include file="db_logout.jsp"%>
</head>
<body>
    <div id='header'>
    <p>&nbsp;</p>
    <% if (request.getSession(false).getAttribute("username") != null) {
           out.println("<p id='username'>You are logged in as "+username+"</p>");

           String encode = response.encodeURL("logout.jsp");
           out.println("<A id='signout' href='"+response.encodeURL (encode)+"'>(Logout)</a>");
       } else {
           response.sendRedirect("main.jsp");
       }
       String encodeHomePage = response.encodeURL("home.jsp");
    %>
    </div>

<div id="container">
<p class='homePage'>Go back to <A class='homePage' href='<%= encodeHomePage %>'>Home Page</a></p>
<center>
<h3> Top 5 Images </h3>
<h3> All Images </h3>
<% for (String p_id : valid_ids) { 
    // Encode DisplayImage.jsp link
    String encodeDisplay1 = response.encodeURL("DisplayImage.jsp");    
    String encodeDisplay2 = encodeDisplay1+"?id="+p_id;
    out.println("<a href='"+encodeDisplay2+"'>");

    // Encode the GetOnePic servlet
    String encodeGet1 = response.encodeURL("GetOnePic");
    String encodeGet2 = encodeGet1+"?"+p_id;
    out.println("<img src='"+encodeGet2+"'></a>");
    }
%>
<form action="<%= encodeUpload %>">
<input type="submit" value="Add More Photos">
</form>
</center>
</div>
</body>
</html>
