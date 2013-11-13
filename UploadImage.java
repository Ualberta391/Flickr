/***
 *  A sample program to demonstrate how to use servlet to 
 *  load an image file from the client disk via a web browser
 *  and insert the image into a table in Oracle DB.
 *  
 *  Copyright 2007 COMPUT 391 Team, CS, UofA                             
 *  Author:  Fan Deng
 *                                                                  
 *  Licensed under the Apache License, Version 2.0 (the "License");         
 *  you may not use this file except in compliance with the License.        
 *  You may obtain a copy of the License at                                 
 *      http://www.apache.org/licenses/LICENSE-2.0                          
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *  
 *  Shrink function from
 *  http://www.java-tips.org/java-se-tips/java.awt.image/shrinking-an-image-by-skipping-pixels.html
 *
 *
 *  the table shall be created using the following
      CREATE TABLE pictures (
            pic_id int,
	        pic_desc  varchar(100),
		    pic  BLOB,
		        primary key(pic_id)
      );
      *
      *  One may also need to create a sequence using the following 
      *  SQL statement to automatically generate a unique pic_id:
      *
      *   CREATE SEQUENCE pic_id_sequence;
      *
      ***/

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.*;
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
    public String response_message;
    public void doPost(HttpServletRequest request,HttpServletResponse response)
	throws ServletException, IOException {
	//  change the following parameters to connect to the oracle database
	String username = "vrscott";
	String password = "radiohead7";
	String drivername = "oracle.jdbc.driver.OracleDriver";
	String dbstring ="jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	FileItem image_obj = null;

	String description = "";
	String place = "";
	String subject = "";
	String security = "";
	int pic_id;

	try {
	    //Parse the HTTP request to get the image stream
	    DiskFileUpload fu = new DiskFileUpload();
	    List<FileItem> items = fu.parseRequest(request);

	    for (FileItem item : items) {
	        if (!item.isFormField()) {
		    // Item is the uploaded file
		    image_obj = item;
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
		    }
		}
	    }

	    //Get the image stream
	    InputStream instream = image_obj.getInputStream();

	    BufferedImage img = ImageIO.read(instream);
	    BufferedImage thumbNail = shrink(img, 150);

        // Connect to the database and create a statement
        Connection conn = getConnected(drivername,dbstring, username,password);
	    Statement stmt = conn.createStatement();
	    
	    /*
	     *  First, to generate a unique pic_id using an SQL sequence
	     */
	    ResultSet rset1 = stmt.executeQuery("SELECT pic_id_sequence.nextval from dual");
	    rset1.next();
	    pic_id = rset1.getInt(1);

	    //Insert an empty blob into the table first. Note that you have to 
	    //use the Oracle specific function empty_blob() to create an empty blob

	    stmt.execute("INSERT INTO images VALUES(" + pic_id + ",'owner_name','" + 
						   security + "','" + subject + "','" +
						   place + "','yesterday','" + description +
			         	           "',empty_blob(),empty_blob())");
 
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
	    
	    /*
	    int size = myblob.getBufferSize();
	    byte[] buffer = new byte[size];
	    int length = -1;
	    while ((length = instream.read(buffer)) != -1)
		outstream.write(buffer, 0, length);
	    */
	    instream.close();
	    t_outstream.close();
	    p_outstream.close();
	
            stmt.executeUpdate("commit");

	    response_message = description;

            conn.close();

	} catch( Exception ex ) {
	    System.out.println( ex.getMessage());
	    response_message = ex.getMessage();
	}

	response.sendRedirect("PictureBrowse");
    }

    /*
      /*   To connect to the specified database
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
