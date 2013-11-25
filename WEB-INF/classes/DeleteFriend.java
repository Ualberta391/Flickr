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

public class DeleteFriend extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
        // Change the following parameters to connect to the oracle database
        System.out.println("hi here");
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        String group_id = "";
        String friend = "";

        try {
            // Get the group ID from the ajax call
            group_id = request.getParameter("id").toString();
            friend = request.getParameter("friend").toString();

            // Connect to the database and create a statement
            Class drvClass = Class.forName(drivername);
            DriverManager.registerDriver((Driver) drvClass.newInstance());
            Connection conn = DriverManager.getConnection(dbstring, username, password);
            Statement stmt = conn.createStatement();
            
            // Delete the friend
            String sql = ("delete from group_lists where group_id='" + group_id + 
                          "' and friend_id='" + friend + "'");

            stmt.executeUpdate(sql);
            stmt.executeUpdate("commit");
            conn.close();
        } catch(Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
