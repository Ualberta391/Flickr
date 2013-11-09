import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

/**
 *  This servlet displays a large version of the selected image, along with 
 *  accompanying data
 *
 */
public class DisplayImage extends HttpServlet 
    implements SingleThreadModel {

    /**
     *    This method first gets the query string indicating PHOTO_ID,
     *    and then executes the query 
     *          select image from yuan.photos where photo_id = PHOTO_ID   
     *    Finally, it sends the picture to the client
     */

    public void doGet(HttpServletRequest request,
		      HttpServletResponse response)
	throws ServletException, IOException {
	
	//  construct the query from the client's QueryString
	String picid = request.getQueryString();
	String query = "select * from images where photo_id=" + picid;
	String description = "";
	String place = "";
	String owner_name = "";
	String subject = "";
	String when = "";
	String permitted = "";

	response.setContentType("text/html");
	PrintWriter out = response.getWriter();

	Connection conn = null;
	try {
	    conn = getConnected();
	    Statement stmt = conn.createStatement();
	    ResultSet rset = stmt.executeQuery(query);

	    if ( rset.next() ) {
		description = rset.getString("DESCRIPTION");
		place = rset.getString("PLACE");
		owner_name = rset.getString("OWNER_NAME");
		subject = rset.getString("SUBJECT");
		when = rset.getString("WHEN");
		permitted = rset.getString("PERMITTED");

		out.println("<html>\n<head>\n<title>"+subject+"</title>\n</head>\n");
		out.println("<body bgcolor=\"#000000\" text=\"#cccccc\" >");
		out.println("<script>\nfunction editInformation() {\n");
		out.println("var person=prompt(\"Please enter your name\",\"Harry Potter\");");
		out.println("}</script>");
		out.println("<center>");
		out.println("<img src=\"/proj1/GetOnePic?big"+picid+"\"></a>\n");
		out.println("<h3>Description: "+description+"</h3>");
		out.println("<h3>Place: "+place+"</h3>");
		out.println("<h3>Owner: "+owner_name+"</h3>");
		out.println("<h3>Subject: "+subject+"</h3>");
		out.println("<h3>Groups: "+permitted+"</h3>");
		out.println("<h3>Time photo taken: "+when+"</h3>");
		out.println("<form action='PictureBrowse'>");
		out.println("<input type='submit' value='Return to all pictures'>");
		out.println("</form>");
		out.println("<button onclick=\"editInformation()\">Edit</button>");
		out.println("</center>\n</body>\n</html>");

		stmt.close();
		conn.close();
	    } 
	    else 
		response.sendRedirect("img_not_found.html");
	} catch ( Exception ex ) {
	    out.println(ex.getMessage() );
	}
	// to close the connection
	finally {
	    try {
		conn.close();
	    } catch ( SQLException ex) {
		out.println( ex.getMessage() );
	    }
	}
    }

    /*
     *   Connect to the specified database
     */
    private Connection getConnected() throws Exception {

	String username = "vrscott";
	String password = "radiohead7";
        /* one may replace the following for the specified database */
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

	/*
	 *  to connect to the database
	 */
	Class drvClass = Class.forName(drivername); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password) );
    }
}
