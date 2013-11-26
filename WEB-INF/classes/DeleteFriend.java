/***
    Servlet for deleting a friend in the security module.
    This servlet is called when Delete Friend button is pressed in 
    the security/editFriend.jsp module.
***/
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;

public class DeleteFriend extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
        // Parameters to connect to the oracle database
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        String group_id = "";
        String friend = "";

        try {
            // Get the group ID and friend name from the ajax call
            group_id = request.getParameter("id").toString();
            friend = request.getParameter("friend").toString();

            // Connect to the database and create a statement
            Class drvClass = Class.forName(drivername);
            DriverManager.registerDriver((Driver) drvClass.newInstance());
            Connection conn = DriverManager.getConnection(dbstring, username, password);
            Statement stmt = conn.createStatement();
            
            String sql = ("delete from group_lists where group_id='" + group_id + 
                          "' and friend_id='" + friend + "'");

            // Delete the friend
            stmt.executeUpdate(sql);
            stmt.executeUpdate("commit");

            conn.close();
        } catch(Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
