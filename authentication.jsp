<HTML>
    <HEAD>
	<TITLE>Your Login Result</TITLE>
    </HEAD>

    <BODY>
    <!--A simple example to demonstrate how to use JSP to 
	connect and query a database. 
	@author  Hong-Yu Zhang, University of Alberta
    -->

	<%@ page import="java.sql.*" %>
	<% if(request.getParameter("bSubmit") != ""){
	    //get the user input from the login page
            String userName = (request.getParameter("username")).trim();
	    String passwd = (request.getParameter("password")).trim();
            out.println("<p>Your input User Name is "+userName+"</p>");
            out.println("<p>Your input password is "+passwd+"</p>");

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

	    //select the user table from the underlying db and validate the user name and password
            Statement stmt = null;
	    ResultSet rset = null;
	    String sql = "select password from UserInfo where username = '"+userName+"'";
	    out.println(sql);

            try{
	        stmt = conn.createStatement();
		rset = stmt.executeQuery(sql);
            }
	    catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
            }

	    String truepwd = "";
	
            while(rset != null && rset.next())
	        truepwd = (rset.getString(1)).trim();
	
        	//If the password you provided matches the password in the database according to the username you provided
		//Meaning successful login
	        if(passwd.equals(truepwd)){
		        out.println("<p><b>Your Login is Successful!</b></p>");
			out.println("<p>You're logged in as "+userName+"</p>");

			
			//Set username attribute to session
			session.setAttribute("username",userName);
			String encode = response.encodeURL("home.jsp");
			response.sendRedirect(encode);

		}
		//If unsuccessful login
        	else{
	            response.sendRedirect("error.html");
		}
		
		//Close connection
                try{
                        conn.close();
                }
                catch(Exception ex){
                        out.println("<hr>" + ex.getMessage() + "<hr>");
                }
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