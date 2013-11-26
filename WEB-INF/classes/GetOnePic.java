/**
 *   This servlet is accessed when any .jsp requires an image object.
 *   This servlet queries the database for the input photo_id and returns the 
 *   image object.  A large amount of this code was taken from the provided
 *   example module from Li-Yan Yuan.
 *
 */
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class GetOnePic extends HttpServlet implements SingleThreadModel {
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

        // Gathers the image id from the query string
        String picid  = request.getQueryString();
        String query = "";

        if (picid.startsWith("big"))
            query = "select photo from images where photo_id=" + picid.substring(3);
        else
            query = "select thumbnail from images where photo_id=" + picid;

        ServletOutputStream out = response.getOutputStream();
        Connection conn = null;
        try {
            conn = getConnected();
            Statement stmt = conn.createStatement();
            ResultSet rset = stmt.executeQuery(query);

            if (rset.next()) {
                response.setContentType("image/gif");
                InputStream input = rset.getBinaryStream(1);	    
                int imageByte;
                while((imageByte = input.read()) != -1)
                    out.write(imageByte);
                input.close();
            } else {
                response.sendRedirect("img_not_found.html");
            }
        } catch( Exception ex ) {
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

    private Connection getConnected() throws Exception {
        // Returns a connection object which is used to access the database
        // Parameters to connect to the database
        String username = "c391g5";
        String password = "radiohead7";
        String drivername = "oracle.jdbc.driver.OracleDriver";
        String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

        Class drvClass = Class.forName(drivername); 
        DriverManager.registerDriver((Driver) drvClass.newInstance());
        return( DriverManager.getConnection(dbstring,username,password) );
    }
}
