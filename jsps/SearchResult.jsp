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
public class SearchResult extends HttpServlet implements SingleThreadModel {
    
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
        out.println("<title>Search Result</title>");
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
        String from ="";
        String to="";
        java.util.Date parsedf = null;
        java.util.Date parsedt = null;
        Connection conn = null;
        try{
            conn = getConnected();
            //Get the data
            String dFrom = request.getParameter("from");
            String dTo = request.getParameter("to");
            
            //Convert string to java.util.date format and then back into the correct string date format for comparison
            SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
            parsedf = format.parse(dFrom);
            parsedt = format.parse(dTo);
            DateFormat df = new SimpleDateFormat("dd-MMM-yy");  
            from = df.format(parsedf);
            to = df.format(parsedt);
                
            //If the user clicked the button search
            if(request.getParameter("dateSubmit") != ""){
                //If user entered something to query
                if(!(request.getParameter("query").equals(""))){
                    PreparedStatement doSearch = conn.prepareStatement("SELECT * FROM (SELECT 6*SCORE(1) + 3*SCORE(2) + SCORE(3) AS RANK, subject, description, place, timing, photo_id FROM images i WHERE CONTAINS(i.subject, ?, 1)>0 OR CONTAINS(i.place, ?, 2)>0 OR CONTAINS(i.description, ?, 3)>0) WHERE (timing between ? and ?)  ORDER BY RANK DESC");
                    
                    doSearch.setString(1, request.getParameter("query"));
                    doSearch.setString(2, request.getParameter("query"));
                    doSearch.setString(3, request.getParameter("query"));
                    doSearch.setString(4, from);
                    doSearch.setString(5, to);
                    
                    ResultSet rset2 = doSearch.executeQuery();
                    
                    String p_id = "";
                    
                    while(rset2.next()){
                        //Get the photo id
                        p_id = (rset2.getObject(6)).toString();
                        
                        //Encode display.jsp link
                        String encodeDisplay1 = response.encodeURL("DisplayImage.jsp");
                        String encodeDisplay2 = "/proj1/"+encodeDisplay1+"?id="+p_id;
                        out.println("<a href='"+encodeDisplay2+"'>");
                        
                        //Encode the servlet GetOnePic
                        String encodeOne1 = response.encodeURL("GetOnePic");
                        String encodeOne2 = "/proj1/"+encodeOne1+"?"+p_id;
                        out.println("<img src='"+encodeOne2+"'></a>");
                    }
                }else{
                    out.println("<br><b>Please enter text for search</b>");
                }
            }
            conn.close();
        }catch(SQLException e){
            out.println("SQLException: " +e.getMessage());
            //conn.rollback();
        }
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
