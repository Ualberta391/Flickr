<!-- User documentation or help page -->
<!DOCTYPE html>
<html>
    <head>
        <title>User Documentation</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
        <% String encodeHome = response.encodeURL("/proj1/home.jsp"); %>
    </head>
    <body> 
    <div id="container">
        <div id="subContainer" style="width:1000px;text-align:left">
            <a href='<%= encodeHome %>' id='buttonstyle'>Back to Home</a> 
            <h1 style="color:black">User Documentation</h1>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Welcome to Thumbs-Up Storage! We are a fast, easy to learn, light-weight image hosting website where you can store all of your life's memories. Thumbs-Up Storage is your one stop location for easily storing photos and sharing them with your friends! 
            <h2 style="color:black">Installation Guide</h2>
            1) Download the installation package and extract the files to the base website directory (e.g. ~/catalina/webapps/proj1)<br> 
            2) Inside a terminal, execute the following commands, in order:<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>cd ~/catalina/webapps/proj1/</i><br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>source WEB-INF/lib/export_packages</i><br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>javac WEB-INF/classes/*.java</i><br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>starttomcat</i><br>
            3) Open a new terminal and run the following command:<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>cd ~/catalina/webapps/proj1/sql</i><br>
            4) Connect a session to the database by running the sqlplus command, and logging in with the appropriate credentials<br>
            5) At the sqlplus command line, enter the following command to initialize the database:<br>
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i>@exe.sql</i><br>
            6) In the browser of your choice (preferably Firefox) enter http://u???.cs.ualberta.ca:<your-first-port-number>/proj1/user_management/main.jsp into the URL address bar, where u??? is the computer you are working on. (<i>You can find this information by typing hostname in a terminal</i>)<br>
            <h2 style="color:black">User Manual</h2>

            <h3 syle="color:black">User Management Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Before you can start uploading and browsing pictures, you must first register an account with us.  Simply submit the required information, such as your first and last name, email address, phone number, username, and password.  Keep in mind that your username and email address must be unique. If you succesfully register, you will be redirected to your home page.</p>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you've already registered an account with us, simply type in your username and password in the login text fields and you will be redirected to your home page, unless your username and password do not match the login credentials that you previously registered with. </p>

            <h3 syle="color:black">Security Module</h3>  
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;After a successful login, you can create any number of groups by clicking the Group Info button.  Once there, type in what you would like to call your group and click submit.  Note that group names must be unique, such that you cannot create a group if you have already created a group with the same name. You can see all the groups that you have created in the Group Info page, and by clicking on any one of them, you can add friends to that group.  A friend can be added to the group if he or she is a registered user of the website, and is not already in the group.<p>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A group owner may also specify a notice to each of the friends of their group.  This notice can be viewed by the user when they select the groups that they are a part of from the Group Info page.
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Once you've created groups and added users to them, you can specify who can see the images you’ve uploaded.  When uploading images (see the uploading module for more information), simply choose from the drop down box which group you want to be able to see the image. You can also set the image to public, so that all users of the system can see the image, or private so only you can see the image. Keep in mind that the admin can also see all images, no matter what groups restrictions may be in place. Once you've uploaded the image, you can edit the group permissions by clicking on the Edit Photo Information button when viewing the image.</p>

            <h3 syle="color:black">Uploading Module</h3>    
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To upload an image, select the Upload Pictures button from the home page. Choose the file you would like to upload (either a jpeg, jpg, or gif file). You can also enter descriptive information about the image, such as the description, subject, location, and date of when the image was taken. You can also select the visibility security of the image as discussed previously. You may also upload images in bulk, by shift-clicking all the images in the File Upload browser.  When uploading a batch of images, they will all be set with the same information entered in the form. Editing the information of each image can be done using the Display Module (more on that later). If you choose not to enter information about the image, the security specification will default to public, and the rest of the information will remain blank.</p>

            <h3 syle="color:black">Display Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you would like to browse uploaded images, select the View Pictures button from the main menu.  There, you can see thumbnails of all the images you've uploaded, images other users have marked as public, and images restricted to groups that you are a part of. At the top of the page, you will see the most popular images. The popularity of an image is specified by the number of distinct users that have ever viewed the image. </p>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You can also see a larger view of the image and some details of the image (such as description, subject, location, and date of when the image was taken. If you are the owner of the selected image, you can also delete the photo from the website, or edit the photo information by clicking the Edit Photo Information button and supplying new details. </p> 

            <h3 syle="color:black">Search Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;By clicking on the Search Pictures button from the home page, you can search for certain images.  Simply type in one or more key words in the Search text field. Multiple keywords should specified by a comma and a space, such as "animals, Edmonton". You can also search for images between a certain date.  To do this, click on the 'from' and 'to' buttons and select the dates to search between.  You can also decide to view the pictures either from most recent first or most recent last by choosing the respective button. If you choose the default option, the ranking will be determined by the following formula:  Rank(photo_id) = 6*frequency(subject) + 3*frequency(place) + frequency(description).  As you can see, the key words are checked against the description, subject, and location data associated with each image that the user is allowed to view.</p>  

        <% if (request.getSession(false).getAttribute("username") != null) {
            if (String.valueOf(session.getAttribute("username")).equals("admin")) { %>
            <h3 syle="color:black">Data Analysis Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;As the admin, you can select the View Data button at the main page to utilize the Data Analysis Module, in order to generate and display an OLAP report of the website's usage. Here you can see the number of images uploaded for each subject, date, and user.  You can narrow down your data display by specifying any of these fields to track more specific data.  For example, the admin can figure out how many pictures of animals were uploaded by a user 'johnny' in the year 2013. At the bottom of the page, the admin can specify the subject, user and time period to query the database for. Each of the search criteria also has an "ALL" category, which indicates that the admin wants to see all images regardless of the value in that criteria.</p>
        <% }} %>
        <a href='<%= encodeHome %>' id='buttonstyle'>Back to Home</a> 
        </div>
    </div>
    </body>
</html>
