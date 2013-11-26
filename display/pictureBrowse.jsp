<!-- Module to display the images in the database, with the top 5 images appearing first -->
<html>
    <head>
        <title>Photo List</title>
        <link rel='stylesheet' type='text/css' href='/proj1/util/mystyle.css'>
        <%@include file="../util/dbLogin.jsp"%>
        <%  // Initialize lists of valid photo_ids and top photo_ids
            List<String> valid_ids = new ArrayList<String>();
            List<String> top_ids = new ArrayList<String>();

            // Encode the redirect URLs
            String encodeUpload = response.encodeURL("/proj1/uploading/uploadImage.jsp");
            String encodeDisplay1 = response.encodeURL("/proj1/display/displayImage.jsp");    
            String encodeGet1 = response.encodeURL("/proj1/display/GetOnePic");
            String username = String.valueOf(session.getAttribute("username"));

            String pic_id = "";
            String owner_name = "";
            String sql = "";
            int permitted = 0;
            boolean is_friend = false;
            int top_count = 0;
            int last_count = 0;

            // Get all photos that are able to be seen by the current user
            Statement photo_id_stmt = conn.createStatement();
            Statement access_control_stmt = conn.createStatement();
            ResultSet ids_rset = photo_id_stmt.executeQuery("select photo_id from images");
            while (ids_rset.next()) {
                is_friend = false;
                pic_id = ids_rset.getObject(1).toString();
                sql = "select owner_name, permitted from images where photo_id=" + pic_id;
                ResultSet ctrl_rset = access_control_stmt.executeQuery(sql);
                if (ctrl_rset.next()) {
                    owner_name = ctrl_rset.getString(1);
                    permitted = ctrl_rset.getInt(2);
                }
                
                sql = "select friend_id from group_lists where group_id=" + permitted;
                ResultSet rset3 = access_control_stmt.executeQuery(sql);
                while (rset3.next()) {
                    if (rset3.getString(1).equals(username))
                        is_friend = true;
                }
                if (owner_name.equals(username) || permitted == 1 || 
                    username.equals("admin") || is_friend)
                    valid_ids.add(pic_id);
            }
            photo_id_stmt.close();
            access_control_stmt.close();

            // Get the top 5 photos that are able to be seen by the current user
            Statement top_pics_stmt = conn.createStatement();
            sql = ("select photo_id, count(photo_id) from picture_hits group by " +
                   "photo_id order by count(photo_id) desc");
            ResultSet top_pics_rset = top_pics_stmt.executeQuery(sql);
            while (top_count < 5 && top_pics_rset.next())  {
                pic_id = top_pics_rset.getString(1);
                if (valid_ids.contains(pic_id)) {
                    top_ids.add(pic_id);
                    last_count = top_pics_rset.getInt(2);
                    top_count += 1;
                }
            }

            // In case of a tie, display all tied images
            while (top_pics_rset.next()) {
                pic_id = top_pics_rset.getString(1);
                if (top_pics_rset.getInt(2) == last_count) { 
                    if (valid_ids.contains(pic_id))
                        top_ids.add(pic_id);
                } else {
                    break;
                }
            }
        %>
        <%@ page import="java.sql.*, java.text.*, java.util.*" %>
        <%@include file="../util/dbLogout.jsp"%>
    </head>
    <body>
        <%@include file="../util/addHeader.jsp"%>
        <div id="container">
            <p class='homePage'>Go back to <A class='homePage' href='<%= encodeHomePage %>'>Home Page</a></p>
            <form action="<%= encodeUpload %>">
                <input type="submit" id="buttonstyle" value="Add More Photos">
            </form>
            <center>
                <h3 style="color:white;font-size:30px"> Top 5 Images </h3>
                <% for (String top_id : top_ids) {
                     // Encode DisplayImage.jsp link
                    String encodeDisplay2 = encodeDisplay1+"?id="+top_id;
                    out.println("<a href='"+encodeDisplay2+"'>");

                    // Encode the GetOnePic servlet
                    String encodeGet2 = encodeGet1+"?"+top_id;
                    out.println("<img src='"+encodeGet2+"'></a>");
                    }
                %>
                <h3 style="color:white;font-size:30px"> All Images </h3>
                <% for (String p_id : valid_ids) { 
                    // Encode DisplayImage.jsp link
                    String encodeDisplay2 = encodeDisplay1+"?id="+p_id;
                    out.println("<a href='"+encodeDisplay2+"'>");

                    // Encode the GetOnePic servlet
                    String encodeGet2 = encodeGet1+"?"+p_id;
                    out.println("<img src='"+encodeGet2+"'></a>");
                    }
                %>
            </center>
        </div>
    </body>
</html>
