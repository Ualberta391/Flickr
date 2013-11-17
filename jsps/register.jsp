<!DOCTYPE html>
<html>
    <head>
        <title>Register</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>

    <body> 
        <div id = "header">
            <marquee behavior="scroll" direction="left"><b><h1>CMPUT 391</h1></b></marquee>
            <marquee behavior="scroll" direction="left"><h4>Creators: Scott Vig, Valerie Sawyer, Zhan Yap</h4></marquee>
	</div>
	
	
	<div id="container">
	
	<%@ page import="java.sql.*" %>
	<%@ page import="java.util.*"%>
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
            /*out.println("<p>Your input Username is "+username+"</p>");
            out.println("<p>Your input Password is "+password+"</p>");
            out.println("<p>Your input First Name is "+firstName+"</p>");
            out.println("<p>Your input Last Name is "+lastName+"</p>");
	    out.println("<p>Your input Address is "+address+"</p>");
            out.println("<p>Your input Email is "+email+"</p>");
	    out.println("<p>Your input Phone is "+phone+"</p>");
	    */

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
		conn = DriverManager.getConnection(dbstring,"zyap","oi2eooi278");
        	conn.setAutoCommit(false);
	    }
            catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
            }



            Statement stmt = null;
	    //ResultSet rset = null;
	    
	    //Fetch current date
	    java.util.Date utilDate = new java.util.Date();
            java.sql.Date date = new java.sql.Date(utilDate.getTime());
	    
	    

	    //out.println("date = "+date);
	    
	    String sql1 = "Insert into Users values('"+username+"','"+password+"',date'"+date+"')";
            String sql2 = "Insert into Persons values ('"+username+"','"+firstName+"','"+lastName+"','"+address+"','"+email+"',"+phone+")";
	    
	    //out.println(sql1);
	    //out.println(sql2);
	    
	    //Attempting to execute both SQL statements
	    //If username or email has been taken, it will notifty the user
            try{
		stmt = conn.createStatement();
		
		//Update the table Users
		stmt.executeUpdate(sql1);
		
		try{
		    //Update the table Persons
		    stmt.executeUpdate(sql2);
		    
		    //Set username attribute to session
		    session.setAttribute("username",username);
		    String encode = response.encodeURL("home.jsp");
		    
		    //After the user has successfully registered an account with us, we will redirect the user to his homepage
		    response.sendRedirect(encode);
		}catch(Exception ex){
		    //Display to the user an error if he provided an email or username that has already been taken
		    out.println("<div id='error'>");
		    out.println("<Fieldset>");
		    out.println("<legend>Actions</legend>");
		    out.println("Sorry, the email you provided have been used.");
		    out.println("Please select a different one.");
		    out.println("<br><a href='main.jsp'>back</a>");
		    out.println("</Fieldset>");
		    out.println("</div>");
		    
		    //If entered this loop, it means the username the user provided was valid but the email isnt.
		    //Have to roll back to prevent values being incorrectly entered in the database
		    sql1 = "Delete from Users where user_name='"+username+"'";
		    stmt.executeUpdate(sql1);
		    out.println(sql1);
		}
            }
	    catch(Exception ex){
		//Display to the user an error if he provided an email or username that has already been taken
		out.println("<div id='error'>");
	        out.println("<Fieldset>");
		out.println("<legend>Actions</legend>");
		out.println("Sorry, the username you provided have been used.");
		out.println("Please select a different one.");
		out.println("<br><a href='main.jsp'>back</a>");
		out.println("</Fieldset>");
		out.println("</div>");
		
		//out.println("<hr>" + ex.getMessage() + "<hr>");
		//out.println("You couldn't create an account with us");
            }

	    
	    
	    
	    //Close connection
            try{
                conn.close();
            }
            catch(Exception ex){
                out.println("<hr>" + ex.getMessage() + "<hr>");
            }
        }%>
	
	</div>
    </BODY>
</HTML>
