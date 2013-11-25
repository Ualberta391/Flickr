/***
***/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;

public class DeleteImage extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	// Change the following parameters to connect to the oracle database
	String username = "c391g5";
	String password = "radiohead7";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

    String pic_id = "";

    try {
        // Get the new string values from the ajax call
        pic_id = request.getParameter("id").toString();

        // Connect to the database and create a statement
        Class drvClass = Class.forName(drivername);
        DriverManager.registerDriver((Driver) drvClass.newInstance());
        Connection conn = DriverManager.getConnection(dbstring, username, password);
        Statement stmt = conn.createStatement();
        
        // Delete the image
        stmt.executeUpdate("DELETE FROM images WHERE photo_id=" + pic_id);

        // Also delete from picture_hits since the photo doesn't exist anymore
        stmt.executeUpdate("DELETE FROM picture_hits WHERE photo_id=" + pic_id);

        stmt.executeUpdate("commit");
        conn.close();
    } catch(Exception ex) {
        System.out.println(ex.getMessage());
    }
    }
}
