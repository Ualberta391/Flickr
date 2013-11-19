<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title>Image Display</title>
<% String photo_id = request.getParameter("id");
// String username = String.valueOf(session.getAttribute("username"));
%>
<%@ page import="java.sql.*, java.text.*, java.util.*" %>

<%@include file="db_login.jsp"%>
<%
   ResultSet rset = null;
   ResultSet rset2 = null;
   ResultSet rset3 = null;
   
   String description = "";
   String place = "";
   String owner_name = "";
   String subject = "";
   String timing = "";
   String permitted = "none";
   String group_id = "";

   ArrayList<String> group_names = new ArrayList<String>();
   ArrayList<String> group_ids = new ArrayList<String>();

   try {
       Statement stmt = conn.createStatement();
       rset = stmt.executeQuery("select * from images where photo_id="+photo_id);
   } catch (Exception ex) {
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }
       
   if (rset.next()) {
       description = rset.getString("DESCRIPTION");
       place = rset.getString("PLACE");
       owner_name = rset.getString("OWNER_NAME");
       subject = rset.getString("SUBJECT");
       java.util.Date d_timing = rset.getDate("TIMING");
       SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
       timing = df.format(d_timing);
       group_id = rset.getString("PERMITTED");
   }
   else
       response.sendRedirect("img_not_found.html");

   try {
       Statement permitted_stmt = conn.createStatement();
       rset2 = permitted_stmt.executeQuery("select group_name from groups where group_id="+group_id);
       if (rset2.next()) {
           permitted = rset2.getString("GROUP_NAME");
       }
   } catch (Exception ex) {
       out.println("<hr>" + ex.getMessage() + "<hr>");
   }

   try {
       Statement groups_stmt = conn.createStatement();
       rset3 = groups_stmt.executeQuery("select group_id, group_name from groups");
   } catch (Exception ex) {
       out.println("<hr>" + ex.getMessage() + "</hr>");
   }

   while (rset3.next()) {
       group_ids.add(rset3.getString("GROUP_ID"));
       group_names.add(rset3.getString("GROUP_NAME"));
   }
%>
<%@include file="db_logout.jsp"%>

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
     $( "#edit-form" ).dialog({
         autoOpen: false,
         height: 465,
         width: 350,
         modal: true,
         buttons: {
             "Update Information": function() {
                 // Use ajax to send values to EditData servlet
                 var new_description = $("#description_field").val();
                 var new_groups = $("#groups_field").val();
                 var new_place = $("#place_field").val();
                 var new_subject = $("#subject_field").val();
                 var new_time = $("#time_field").val();

                 $.ajax({url: 'EditData',
                         data: {"description": new_description,
                                "groups": new_groups,
                                "place": new_place,
                                "subject": new_subject,
                                "time": new_time,
                                <% out.println("\"id\": \""+photo_id+"\","); %>
                                },
                         type: 'POST'
                        });
                 location.reload();
             },
             Cancel: function() {
                 $(this).dialog("close");
             }
         },
         close: function() {
             <% out.println("$(\"#description_field\").val('"+description+"');"); %>
             <% out.println("$(\"#place_field\").val('"+place+"');"); %>
             <% out.println("$(\"#subject_field\").val('"+subject+"');"); %>
             <% out.println("$(\"#time_field\").val('"+timing+"');"); %>
             $("#groups_field").val('private');
         }
     });
     $( "#edit-info" )
     .button()
     .click(function() {
         $( "#edit-form" ).dialog( "open" );
     });

     $( "#time_field" ).datepicker({
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
                 //Encode the homePage link
		String encodeHomePage = response.encodeURL("home.jsp");
            %>
        </div>
        
<div id="container">
<%
out.println("<p class='homePage'>Go back to <A class='homePage' href='"+encodeHomePage+"'>Home Page</a></p>");
%>

<center>
       <%
       String username = String.valueOf(session.getAttribute("username"));
       out.println("<img src=\"/proj1/GetOnePic?big"+photo_id+"\">");
       out.println("<p>Description: "+description);
       out.println("<br>Place: "+place);
       out.println("<br>Owner: "+owner_name);
       out.println("<br>Subject: "+subject);
       out.println("<br>Groups: "+permitted);
       out.println("<br>Time photo taken: "+timing+"</p>");
       
       String encodeEdit = response.encodeURL("EditData");
       String encodePic = response.encodeURL("PictureBrowse");
 	if(username.equals(owner_name))
		out.println("<button id=edit-info>Edit Photo Information</button>");
       
       %>

<form action=<%=encodePic%>>
    <input type='submit' value='Return to Pictures'>
</form>
</center>
<div id="edit-form" title="Edit Photo Information">
    <p class="intro">Edit any of the fields and click 'submit'.</p>
    <form method="POST" action=<%=encodeEdit%>>
    <fieldset>
        <label for="description_field">Description</label>
        <% out.println("<input type='text' name='description_field' id='description_field' value='"+description+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="place_field">Place</label>
        <% out.println("<input type='text' name='place_field' id='place_field' value='"+place+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="subject_field">Subject</label>
        <% out.println("<input type='text' name='subject_field' id='subject_field' value='"+subject+"' class='text ui-widget-content ui-corner-all' />"); %>
        <label for="groups_label">Groups</label>
        <select name="security" id="groups_field">
        <% for (int i = 0; i < group_ids.size(); i += 1) {
            if (group_names.get(i).equals(permitted)) {
                out.println("<option selected='true' value='"+group_ids.get(i) +
                            "'>"+group_names.get(i)+"</option>");
            } else {
                out.println("<option value='" + group_ids.get(i) +
                            "'>"+group_names.get(i)+"</option>");
            }
        } %>
        </select>
        <label for="time_field">Time photo taken</label>
        <% out.println("<input type='text' name='time_field' id='time_field' value='"+timing+"' class='text ui-widget-content ui-corner-all' />"); %>
    </fieldset>
    </form>
</div>
</div>
</body>
</html>
