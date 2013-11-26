<!-- Error page for when the user attempts to add an invalid user as a friend to a group.
     An error occurs when the attempted friend is:
        * The user himself/herself
        * Already in the group
        * Does not exist in the database
        * Null
-->
<!DOCTYPE html>
<html>
    <head>
        <title>Invalid Friend!</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="../util/addHeader.jsp"%>
    <% String group_name = (request.getParameter("group")).trim();
       String encodeGroup = response.encodeURL("/proj1/security/viewFriends.jsp?group=" + group_name); 
       %>
    <div id="container">
        <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
        <div id="error">
            <Fieldset>
                <legend>Error</legend>
                <h2><b>Cannot add friend to group!
                       <br>Friend must exist, <br>must not be yourself, <br>and
                       cannot already be part of the group</b></h2>
                <a id="buttonstyle" href='<%=encodeGroup%>'>Back to Group</a>
            </Fieldset>
        </div>
    </div>
    </body>
</html>
