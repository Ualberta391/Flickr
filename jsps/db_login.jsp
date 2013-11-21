<% Connection conn = null;

   String driverName = "oracle.jdbc.driver.OracleDriver";
   String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";

   try {
        //load and register the driver
        Class drvClass = Class.forName(driverName);
        DriverManager.registerDriver((Driver) drvClass.newInstance());
       }
   catch(Exception ex) {
       System.out.println(ex.getMessage());
   }
   try {
       //establish the connection
       conn = DriverManager.getConnection(dbstring,"c391g5","radiohead7");
       conn.setAutoCommit(false);
       }
   catch(Exception ex) {
       out.println(ex.getMessage());
   }
%>
