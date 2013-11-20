import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import oracle.jdbc.driver.*;
import java.text.*;
import java.net.*;

/**
* A simple example to demonstrate how to use servlet to
* query and display a list of pictures
*
* @author Li-Yan Yuan
*
*/
public class PictureBrowse extends HttpServlet implements SingleThreadModel {
    
    /**
* Generate and then send an HTML file that displays all the thermonail
* images of the photos.
*
* Both the thermonail and images will be generated using another
* servlet, called GetOnePic, with the photo_id as its query string
*
*/
    public void doGet(HttpServletRequest request,HttpServletResponse response) throws ServletException, IOException {
        // send out the HTML file
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        HttpSession session = request.getSession( true );
        
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Photo List</title>");
        out.println("<link rel='stylesheet' type='text/css' href='mystyle.css'>");
        out.println("</head>");
        out.println("<body>");
        
        out.println("<div id = 'header'>");
        out.println("<p>&nbsp;</p>");
        
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
        out.println("</div>");
        out.println("<div id='container'>");
        out.println("<p class='homePage'>Go back to <A class='homePage' href='"+response.encodeURL("home.jsp")+"'>Home Page</a></p>");
        out.println("<center>");
        out.println("<h3>The List of Images </h3>");
        
        /*
         * to execute the given query
         */
        try {
            String query = "select photo_id from images";
            Connection conn = getConnected();
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(query);
            String p_id = "";
            String ownername = "";
            int permitted = 0;
            String username = String.valueOf(session.getAttribute("username"));
            while (rset.next() ) {
                //Getting the photo ID
                p_id = (rset.getObject(1)).toString();
                //Getting the user who uploaded that image
                String sql = "select owner_name from images where '"+p_id+"' = photo_id";
                try{
                    stmt = conn.createStatement();
                    //Execute the select statement
                    ResultSet ownerSet = stmt.executeQuery(sql);
                    if (ownerSet.next()){
                        ownername  = ownerSet.getString(1);
                    }
                    else{
                        out.println("no owner exists");
                    }
                }catch(Exception ex){
                    out.println("<hr>" + ex.getMessage() + "<hr>");
                }	        
                // Checking if the user is permitted to see the image
                sql = "select permitted from images where '"+p_id+"' = photo_id";
                try{
                    stmt = conn.createStatement();
                    //Execute the select statement
                    ResultSet permittedSet = stmt.executeQuery(sql);
                    if (permittedSet.next()){
                        permitted = permittedSet.getInt(1);
                    }
                    else{
                        out.println("permitted could not be found");
                    }
                }catch(Exception ex){
                    out.println("<hr>" + ex.getMessage() + "<hr>");
                }
                //If the image is uploaded by the current user, the picture is public, or the user is admin the user can view the photo
                if(ownername.equals(username) || permitted == 1 || username.equals("admin")){  
                    //Encode display.jsp link
                    String encodeDisplay1 = response.encodeURL("DisplayImage.jsp");
                    String encodeDisplay2 = "/proj1/"+encodeDisplay1+"?id="+p_id;
                    out.println("<a href='"+encodeDisplay2+"'>");
                    
                    //Encode the servlet GetOnePic
                    String encodeOne1 = response.encodeURL("GetOnePic");
                    String encodeOne2 = "/proj1/"+encodeOne1+"?"+p_id;
                    out.println("<img src='"+encodeOne2+"'></a>");
                }
                else{
                    sql = "select friend_id from group_lists where '"+permitted+"' = group_id";
                    try{
                        stmt = conn.createStatement();
                        //Execute the select statement
                        ResultSet friend_id_Set = stmt.executeQuery(sql);
                        while (friend_id_Set.next()){
                            //If you are a friend to the owner of the picture, you can view it as well
                            if(friend_id_Set.getString(1).equals(username)){
                                //Encode display.jsp link
                                String encodeDisplay1 = response.encodeURL("DisplayImage.jsp");
                                String encodeDisplay2 = "/proj1/"+encodeDisplay1+"?id="+p_id;
                                out.println("<a href='"+encodeDisplay2+"'>");
                                
                                //Encode the servlet GetOnePic
                                String encodeOne1 = response.encodeURL("GetOnePic");
                                String encodeOne2 = "/proj1/"+encodeOne1+"?"+p_id;
                                out.println("<img src='"+encodeOne2+"'></a>");
                                
                                break;
                            }
                        }
                    }catch(Exception ex){
                        out.println("<hr>" + ex.getMessage() + "<hr>");
                    }
                }
            }
            stmt.close();
            conn.close();
      	}catch( Exception ex ){ 
	    out.println( ex.toString() );
        }
        
        //Encode the uploadImage.jsp link
        String encodeUpload = response.encodeURL("UploadImage.jsp");
        
        out.println("<form action='"+encodeUpload+"'>");
        out.println("<input type='submit' value='Add more photos'>");
        out.println("</form>");
        out.println("</center>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
    
    /*
    * Connect to the specified database
    */
    private Connection getConnected() throws Exception {
        
        String username = "vrscott";
        String password = "radiohead7";
        /* one may replace the following for the specified database */
        
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        /*
         * to connect to the database
         */
        Class drvClass = Class.forName(drivername);
        DriverManager.registerDriver((Driver) drvClass.newInstance());
        return( DriverManager.getConnection(dbstring,username,password) );
    }
}
