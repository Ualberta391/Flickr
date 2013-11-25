/***
    Servlet used to handle the uploading of image objects.
    This servlet uses the imgscalr package to reduce the uploaded image
    to thumbnail size.
***/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
import java.text.*;
import oracle.sql.*;
import oracle.jdbc.*;
import java.awt.Image;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import org.imgscalr.*;  // imgscalr package for fast, accurate thumbnail scaling

/**
 *  The package commons-fileupload-1.0.jar is downloaded from 
 *         http://jakarta.apache.org/commons/fileupload/ 
 *  and it has to be put under WEB-INF/lib/ directory in your servlet context.
 *  One shall also modify the CLASSPATH to include this jar file.
 */
import org.apache.commons.fileupload.DiskFileUpload;
import org.apache.commons.fileupload.FileItem;

public class UploadImage extends HttpServlet {
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "c391g5";
	String password = "radiohead7";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
    List<FileItem> image_files = new ArrayList<FileItem>();
    List<BufferedImage> images = new ArrayList<BufferedImage>();
    List<BufferedImage> thumbnails = new ArrayList<BufferedImage>();
        
	String description = "";
	String place = "";
	String subject = "";
	String security = "";
    java.sql.Date sql_date = null;
	int pic_id;
        
	// Get the session (Create a new one if required)
	HttpSession session = request.getSession( true );
        String pic_owner = String.valueOf(session.getAttribute("username"));
        
	try { 
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List<FileItem> items = fu.parseRequest(request);
            
	    for (FileItem item : items) {
	        if (!item.isFormField()) {
		    // Item is the uploaded file
		    image_files.add(item);
		} else {
		    // Other parameters from the form
		    String fieldname = item.getFieldName();
		    String fieldvalue = item.getString();
		    // Add escape character to any single quotes (to avoid SQL error)
		    fieldvalue = fieldvalue.replace("'", "''");
		    if (fieldname.equals("description")) {
		        description = fieldvalue;
		    } else if (fieldname.equals("place")) {
		        place = fieldvalue;
 		    } else if (fieldname.equals("subject")) {
		        subject = fieldvalue;
		    } else if (fieldname.equals("security")) {
		        security = fieldvalue;
		    } else if (fieldname.equals("time")) {
                if (!fieldvalue.isEmpty()) {
                    SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy");
                    java.util.Date parsed = format.parse(fieldvalue);
                    sql_date = new java.sql.Date(parsed.getTime());
                }
            }
	    }
        }
           
        // Connect to the database and create a statement
        Connection conn = getConnected(drivername,dbstring, username,password);
        Statement stmt = conn.createStatement();

        //Get the image stream
        for (FileItem image_file : image_files) {
            InputStream instream = image_file.getInputStream();
            
            BufferedImage img = ImageIO.read(instream);
            BufferedImage thumbNail = shrink(img, 150);
                
            /*
             *  First, to generate a unique pic_id using an SQL sequence
             */
            ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
            rset1.next();
            pic_id = rset1.getInt(1);
                
            //Insert an empty blob into the table first. Note that you have to 
            //use the Oracle specific function empty_blob() to create an empty blob
            String insert_sql = ("INSERT INTO images VALUES(" + pic_id + ",'" + pic_owner + 
                                 "'," + security + ",'" + subject + "','" + place + "',");
            if (sql_date != null)
                insert_sql += "date'" + sql_date + "','";
            else
                insert_sql += "sysdate,'";
            insert_sql += description + "',empty_blob(),empty_blob())";
            stmt.executeQuery(insert_sql);
            
            // to retrieve the lob_locator 
            // Note that you must use "FOR UPDATE" in the select statement
            String cmd = "SELECT * FROM images WHERE photo_id = "+pic_id+" FOR UPDATE";
            ResultSet rset = stmt.executeQuery(cmd);
            rset.next();
            BLOB thumb_blob = ((OracleResultSet)rset).getBLOB(8);
            BLOB photo_blob = ((OracleResultSet)rset).getBLOB(9);
            
            //Write the image to the blob object
            OutputStream t_outstream = thumb_blob.getBinaryOutputStream();
            OutputStream p_outstream = photo_blob.getBinaryOutputStream();
            
            ImageIO.write(thumbNail, "jpg", t_outstream);
            ImageIO.write(img, "jpg", p_outstream);
            
            instream.close();
            t_outstream.close();
            p_outstream.close();
        }
        
        stmt.executeUpdate("commit");
        
        conn.close();
        
	} catch( Exception ex ) {
	    System.out.println(ex.getMessage());
	}
        
    //Encode PictureBrowse servlet
    String encodePictureBrowse = response.encodeURL("/proj1/display/pictureBrowse.jsp");
	response.sendRedirect(encodePictureBrowse);
    }

    /*
    *   To connect to the specified database
    */
    private static Connection getConnected( String drivername,
					    String dbstring,
					    String username, 
					    String password  ) 
	throws Exception {
	Class drvClass = Class.forName(drivername); 
	DriverManager.registerDriver((Driver) drvClass.newInstance());
	return( DriverManager.getConnection(dbstring,username,password));
    } 

    // Shrink image to a maximum size of n, keeping its proportions,
    // and return the shrinked image.
    public static BufferedImage shrink(BufferedImage image, int n) {
	  return Scalr.resize(image, n);
    }	
}
