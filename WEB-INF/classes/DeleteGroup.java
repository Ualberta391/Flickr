/***
    Servlet for deleting a group within the security module.
    This servlet is called when the user selects the Delete Group button 
    from the security/viewOrAddFriends.jsp module.
***/
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;

public class DeleteGroup extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
        // Parameters to connect to the oracle database
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
        String group_id = "";

        try {
            // Get the group ID from the ajax call
            group_id = request.getParameter("id").toString();

            // Connect to the database and create a statement
            Class drvClass = Class.forName(drivername);
            DriverManager.registerDriver((Driver) drvClass.newInstance());
            Connection conn = DriverManager.getConnection(dbstring, username, password);
            Statement stmt = conn.createStatement();
            
            // Delete the group
            stmt.executeUpdate("DELETE FROM group_lists WHERE group_id=" + group_id);
            stmt.executeUpdate("DELETE FROM groups WHERE group_id=" + group_id);
            stmt.executeUpdate("commit");
            conn.close();
        } catch(Exception ex) {
            System.out.println(ex.getMessage());
        }
    }
}
