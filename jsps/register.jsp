<HTML>
    <HEAD>
	<TITLE>Your Register Result</TITLE>
    </HEAD>

    <BODY>
    <!--A demonstration on how to store user's credentials into the database-->
        
	<%@ page import="java.sql.*" %>
	<% if(request.getParameter("aSubmit") != ""){
	
	    //get the user input from the login page
            String username = (request.getParameter("username")).trim();
	    String password = (request.getParameter("password")).trim();
	    String firstName = (request.getParameter("first")).trim();
	    String lastName = (request.getParameter("last")).trim();
	    String address = (request.getParameter("address")).trim();
	    String email = (request.getParameter("email")).trim();
	    String phone = (request.getParameter("phone")).trim();
	    
	    //Print for verification
            out.println("<p>Your input Username is "+username+"</p>");
            out.println("<p>Your input Password is "+password+"</p>");
            out.println("<p>Your input First Name is "+firstName+"</p>");
            out.println("<p>Your input Last Name is "+lastName+"</p>");
	    out.println("<p>Your input Address is "+address+"</p>");
            out.println("<p>Your input Email is "+email+"</p>");
	    out.println("<p>Your input Phone is "+phone+"</p>");

	    //establish the connection to the underlying database
            Connection conn = null;
	
	    String driverName = "oracle.jdbc.driver.OracleDriver";
            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
	
	    try{
		//load and register the driver
        	Class drvClass = Class.forName(driverName); 
	        DriverManager.registerDriver((Driver) drvClass.newInstance());
            }
	    catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
	    }
	
            try{
	        //establish the connection 
		conn = DriverManager.getConnection(dbstring,"<Put your username here>","<Password here>");
        	conn.setAutoCommit(false);
	    }
            catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
            }



	    //Add user's information into database
            Statement stmt = null;
	    //ResultSet rset = null;
            String sql = "Insert into UserInfo values ('"+username+"','"+password+"','"+firstName+"','"+lastName+"','"+address+"','"+email+"',"+phone+")";
	    out.println(sql);
            try{
		stmt = conn.createStatement();
		
		//Execute update into the database
		stmt.executeUpdate(sql);
		out.println("\nYou have successfully created an account");
            }
	    catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
		out.println("You couldn't create an account with us");
            }
	    conn.close();
        }
        else{
                out.println("<form method=post action=login.jsp>");
                out.println("UserName: <input type=text name=USERID maxlength=20><br>");
                out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
                out.println("<input type=submit name=bSubmit value=Submit>");
                out.println("</form>");
        }%>
    </BODY>
</HTML>
