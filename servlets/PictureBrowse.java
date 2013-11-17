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
    public void doGet(HttpServletRequest request,
                 HttpServletResponse response)
        throws ServletException, IOException {

        // send out the HTML file
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
    HttpSession session = request.getSession( true );

         out.println("<html>");
        out.println("<head>");
        out.println("<title> Photo List </title>");
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

         while (rset.next() ) {
         p_id = (rset.getObject(1)).toString();
         // specify the servlet for the image
            out.println("<a href=\"/proj1/DisplayImage.jsp?id="+p_id+"\">");
         // specify the servlet for the thumbnail
         out.println("<img src=\"/proj1/GetOnePic?"+p_id +
         "\"></a>");
         }
         stmt.close();
         conn.close();
        } catch ( Exception ex ){ out.println( ex.toString() );}
    
        out.println("<form action='UploadImage.jsp'>");
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
