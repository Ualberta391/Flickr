/***
    Servlet for editing the notice associated with the user in a group.
    This servlet is called when the user selects the "Submit New Notice" button 
    from the security/editFriend.jsp module.
***/
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;

public class EditNotice extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
        // Parameters to connect to the oracle database
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

        String friend = "";
        String new_notice = "";
        String group_id = "";

        try {
            // Get the friend and notice info from the ajax call
            friend = request.getParameter("friend").toString();
            new_notice = request.getParameter("new_notice").toString();
            group_id = request.getParameter("group_id").toString();

            // Connect to the database and create a statement
            Class drvClass = Class.forName(drivername);
            DriverManager.registerDriver((Driver) drvClass.newInstance());
            Connection conn = DriverManager.getConnection(dbstring, username, password);
            Statement stmt = conn.createStatement();
            
            // Edit the notice in the database
            String sql = ("update group_lists set notice='" + new_notice + 
                          "' where group_id='" + group_id + 
                          "' and friend_id='" + friend + "'");

            stmt.executeUpdate(sql);
	    stmt.executeUpdate("commit");
            conn.close();
        } catch(Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
