<!-- User documentation or help page -->
<!DOCTYPE html>
<html>
    <head>
        <title>Home</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="addHeader.jsp"%>
    <div id="container">
        <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
        <div id="subContainer" style="width:1000px;text-align:left">
            <h1 style="color:black">User Documentation</h1>
            <h2 style="color:black">Installation Guideline</h2>
            1) Download our package and extract the values in your home directory or somewhere you can find it<br> 
            2) Copy and paste the file into home/catalina/webapps/proj1 (if WEB-INF is already there, delete it) <br>
            3) open a terminal and change directories to home/catalina/webapps/proj1/WEB-INF/classes<br>
            4) compile the java files there by typing javac *<br>
            5) Open the terminal and run tomcat by typing starttomcat<br>
            6) Open sql plus with the terminal by typing sqlplus<br>
            7) Run the sql script, @exe.sql in sqlplus<br>
            8) In the browser of your choice (preferably Firefox) type http://ui???.cs.ualberta.ca:<your-first-port-number>/proj1/user_management/main.jsp<br>
                        where ui??? is the computer you are working on. (you can find this information by typing hostname in the terminal)<br>
            <h2 style="color:black">User Manual</h2>
            <h3 syle="color:black">User Management Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Before you can start uploading and browsing pictures, you must first register an account with us.  Simply type in the required information, such as your first and last name, email address, phone number; and a password and a username so you can log in.  Keep in mind your username and email address must be unique.  Once you've entered the required information, click submit, and if it's successful you will be redirected to your home page.  If you've entered a username or an email address that somebody else already has, you will have to try again. If you're already registered, simply type in your username and password in the log in text fields and you will be redirected to your home page unless your username does not match with the password you entered. </p>

            <h3 syle="color:black">Security Module</h3>  
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You cannot log on to your account if your username and password are not valid.  However once you are logged in, you can create any number of groups by clicking the Group Info button.  Once there, type in what you would like to call your group and click submit.  If you already created a group with that name you will be given an error and will have to think of a different name or go back to the home page.  You can see all the groups that you have created and by clicking on any one of them, you can add friends to that group.  The friend that you add must be a valid username that has registered in the system and not someone that is already a member of your group.  You can also delete a group or a user from the group by clicking delete.</p>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Once you've created groups and added users to them, you can specify who can see the images you’ve uploaded.  When uploading images (see the uploading module for more information) simply choose from the drop down box which group you want access to see the image.  If you want you can also choose public so all users of the system can see the image, or private so only you and the admin can see the image.  (Keep in mind the admin can also see all images you’ve uploaded even if the admin is not part of the group you chose to see the image).  Once you've uploaded the image, you can edit who can see it by clicking on the edit button when viewing the image.</p>

            <h3 syle="color:black">Uploading Module</h3>    
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To upload an image, click the upload image button from your home page, and choose the file you would like to upload (either a jpeg or gif file).  You can also enter descriptive information about the image such as the name, subject, date and location of when the image was taken, and security information (See the Security Module for more information).  Similarly you can upload all image files stored in a local directory and can enter information about them.  If you choose not to enter information  about the image, the security specification will be set to private and the rest of the description will be blank.  </p>

            <h3 syle="color:black">Display Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;If you would like to browse images, click the View Pictures button.  There, you can see thumbnails of all the images you've uploaded, images of other users that have marked them as public, and images that have marked them as a group you are a part of.   (However if you are admin you can see all images).  At the top you will see the top five most popular images. The popularity of an image is specified by the number of distinct users that have ever viewed the image (not its thumbnail). If there was a tie, you will see the tired images. You can also see a larger view of the image and some details of the image (such as name, subject, date and location of when the image was taken, and security information) by clicking on it.  If you are the owner of the image, you can also update any of those fields by clicking edit. </p> 

            <h3 syle="color:black">Search Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;By clicking on the Search Pictures button from the home page, you can search for certain images.  Simply type in one or more key words in the Search text field (to search with more than one key word, type each word followed by a comma and a space key, for example: animals, Edmonton).  If you would like you can also search for images between a certain date.  To do this, click on the from and to buttons and pick the dates.  You can also decide to view the pictures either from most recent first or most recent last by choosing the respective radio button.  If you choose the default option the ranking will be determined by the following formula:  Rank(photo_id) = 6*frequency(subject) + 3*frequency(place) + frequency(description).  As you can see, the key words are checked with the description, subject, and location words of each image that the user entered and the images with the most occurrences of those words are shown.</p>  

            <h3 syle="color:black">Data Analysis Module</h3>
            <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;You can only see the data analysis if you are logged on as admin.  To view the data analysis, click View Data from the home page.  Here you can see the number of images uploaded for each subject, date, and user.  You can also see a more specific query.  At the bottom of the page, specify the subject, user and time period.  If you want to see the number of images uploaded for each subject leave it blank.  Similarly leave the user or time period blank if you would like to the number of images of each user, or time period respectively.</p>
                
        </div>
    </div>
    </body>
</html>
