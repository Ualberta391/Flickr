/***
    Servlet for creating a group within the security module.
    Receives group parameters from the .ajax call within the security/groupInfo.jsp module
***/
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;

public class CreateGroup extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
        // Parameters to connect to the oracle database
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

        String group_name = "";
        String user_name = "";
        java.util.Date utilDate = new java.util.Date();
        java.sql.Date date = new java.sql.Date(utilDate.getTime());

        // Get the group info from the ajax call
        group_name = request.getParameter("group_name").toString();
        user_name = request.getParameter("user_name").toString();

        try { 
            // Connect to the database and create a statement
            Class drvClass = Class.forName(drivername);
            DriverManager.registerDriver((Driver) drvClass.newInstance());
            Connection conn = DriverManager.getConnection(dbstring, username, password);
            Statement stmt = conn.createStatement();
            
            String sql = ("insert into groups values (group_seq.NEXTVAL,'" + user_name + 
                          "','" + group_name + "', DATE'" + date + "')");

            // Create the group
            stmt.executeUpdate(sql);

            conn.close();
        } catch (Exception ex) {
            // Probably a duplicate group name, send a failure back through the AJAX call.
            System.out.println(ex.getMessage());
            response.sendError(response.SC_BAD_REQUEST, "Duplicate groups.");
        }
    }
}
