<!-- Script to run to log into the database and create a connection object.
     Extracting this logic to dbLogin.jsp reduces code duplication. -->
<% Connection conn = null;

   // Database connection parameters
   String driverName = "oracle.jdbc.driver.OracleDriver";
   String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

   try {
        // Load and register the driver
        Class drvClass = Class.forName(driverName);
        DriverManager.registerDriver((Driver) drvClass.newInstance());
       }
   catch(Exception ex) {
       System.out.println(ex.getMessage());
   }
   try {
       // Establish the connection
       conn = DriverManager.getConnection(dbstring,"c391g5","radiohead7");
       conn.setAutoCommit(false);
       }
   catch(Exception ex) {
       out.println(ex.getMessage());
   }
%>
