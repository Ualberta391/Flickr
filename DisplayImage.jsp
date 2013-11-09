<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Image Display</title>
<% String photo_id = request.getParameter("id"); 
//       String username = String.valueOf(session.getAttribute("username"));
%>
<%@ page import="java.sql.*" %>

<% Connection conn = null;

   String driverName = "oracle.jdbc.driver.OracleDriver";
   String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

   try {
       //load and register the driver
       Class drvClass = Class.forName(driverName);
       DriverManager.registerDriver((Driver) drvClass.newInstance());
   }
   catch(Exception ex) {
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }
   try {
       //establish the connection
       conn = DriverManager.getConnection(dbstring,"vrscott","radiohead7");
       conn.setAutoCommit(false);
   }
   catch(Exception ex) {
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }
   // TODO: Verify group access

   String sql = "select * from images where photo_id=" + photo_id;
   Statement stmt = null;
   ResultSet rset = null;
   
   String description = "";
   String place = "";
   String owner_name = "";
   String subject = "";
   String when = "";
   String permitted = "";

   try {
       stmt = conn.createStatement();
       rset = stmt.executeQuery(sql);
   } catch (Exception ex) {
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }
       
   if (rset.next()) {
       description = rset.getString("DESCRIPTION");
       place = rset.getString("PLACE");
       owner_name = rset.getString("OWNER_NAME");
       subject = rset.getString("SUBJECT");
       when = rset.getString("WHEN");
       permitted = rset.getString("PERMITTED");
   } 
   else
       response.sendRedirect("img_not_found.html");

   try {
       conn.close();
   } catch (SQLException ex) {
       out.println("<hr>" + ex.getMessage() + "</hr>");
   }
%>

<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link rel="stylesheet" type="text/css" href="mystyle.css">
<style>
   body { font-size: 62.5%; }
   label, input { display:block; }
   input.text { margin-bottom:12px; width:95%; padding: .4em; }
   fieldset { padding:0; border:0; margin-top:25px; }
   h1 { font-size: 1.2em; margin: .6em 0; }
   .ui-dialog .ui-state-error { padding: .3em; }
   .intro { border: 1px solid transparent; padding: 0.3em; }
</style>
<script>
 $(function() {
     var description = $("#description_field"),
     groups = $("#groups_field"),
     place = $("#place_field"),
     subject = $("#subject_field"),
     time = $("#time_field"),
     tips = $(".intro");

     $( "#edit-form" ).dialog({
         autoOpen: false,
         height: 300,
         width: 350,
         modal: true,
         buttons: {
             "Update Information": function() {
                 // Do stuff here
                 $(this).dialog( "close" );
             },
             Cancel: function() {
                 $(this).dialog( "close" );
             }
         },
         close: function() {
             <% out.println("$(\"#description_field\").val('"+description+"');"); %>
             <% out.println("$(\"#groups_field\").val('"+permitted+"');"); %>
             <% out.println("$(\"#place_field\").val('"+place+"');"); %>
             <% out.println("$(\"#subject_field\").val('"+subject+"');"); %>
             <% out.println("$(\"#time_field\").val('"+when+"');"); %>
         }
     });
     $( "#edit-info" )
     .button()
     .click(function() {
         $( "#edit-form" ).dialog( "open" );
     });
 });
</script>
</head>
<body>
<center>
       <%
       out.println("<img src=\"/proj1/GetOnePic?big"+photo_id+"\">");
       out.println("<p>Description: "+description);
       out.println("<br>Place: "+place);
       out.println("<br>Owner: "+owner_name);
       out.println("<br>Subject: "+subject);
       out.println("<br>Groups: "+permitted);
       out.println("<br>Time photo taken: "+when+"</p>");
       %>
<button id=edit-info>Edit Photo Information</button>
</center>
<div id="edit-form" title="Edit Photo Information">
    <p class="intro">Edit any of the fields and click 'submit'.</p>
    <form method="POST" action="EditData">
    <fieldset>
        <label for="description_field">Description</label>
        <% out.println("<input type='text' name='description_field' id='description_field' value='"+description+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="place_field">Place</label>
        <% out.println("<input type='text' name='place_field' id='place_field' value='"+place+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="subject_field">Subject</label>
        <% out.println("<input type='text' name='subject_field' id='subject_field' value='"+subject+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="groups_field">Groups</label>
        <% out.println("<input type='text' name='groups_field' id='groups_field' value='"+permitted+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="time_field">Time photo taken</label>
        <% out.println("<input type='text' name='time_field' id='time_field' value='"+when+"' class='text ui-widget-content ui-corner-all' />"); %>
    </fieldset>
    </form>
</div>
</body>
</html>
