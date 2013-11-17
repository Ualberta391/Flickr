<HTML>
    <HEAD>
	<TITLE>Your Login Result</TITLE>
    </HEAD>

    <BODY>
    <!--A simple example to demonstrate how to use JSP to 
	connect and query a database. 
	@author  Hong-Yu Zhang, University of Alberta
    -->
	<%@include file="db_login.jsp"%>
	<%@ page import="java.sql.*" %>
	<% if(request.getParameter("bSubmit") != ""){
	    //get the user input from the login page
            String userName = (request.getParameter("username")).trim();
	    String passwd = (request.getParameter("password")).trim();
            out.println("<p>Your input User Name is "+userName+"</p>");
            out.println("<p>Your input password is "+passwd+"</p>");

	    //select the user table from the underlying db and validate the user name and password
            Statement stmt = null;
	    ResultSet rset = null;
	    String sql = "select password from users where user_name = '"+userName+"'";
	    out.println(sql);

            try{
	        stmt = conn.createStatement();
		rset = stmt.executeQuery(sql);
            }
	    catch(Exception ex){
		out.println("<hr>" + ex.getMessage() + "<hr>");
            }

	    String truepwd = "";
	    
	    //If username and password textbox is not empty when click the button "Login"
	    if(!userName.trim().isEmpty() && !passwd.trim().isEmpty()){
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
		
	    }
	    else{
		//redirect user to error page
		response.sendRedirect("error.html");
	    }
        }
        else{
                out.println("<form method=post action=login.jsp>");
                out.println("UserName: <input type=text name=USERID maxlength=20><br>");
                out.println("Password: <input type=password name=PASSWD maxlength=20><br>");
                out.println("<input type=submit name=bSubmit value=Submit>");
                out.println("</form>");
        }%>
        <%@include file="db_logout.jsp"%>
    </BODY>
</HTML>
