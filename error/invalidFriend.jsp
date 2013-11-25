<!DOCTYPE html>
<html>
    <head>
        <title>Invalid Friend!</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="../util/addHeader.jsp"%>
    <% String encodeGroupInfo = response.encodeURL("/proj1/security/groupInfo.jsp"); %>
    <div id="container">
        <p class="homePage">Go back to <A class="homePage" href=<%=encodeHomePage%>>Home Page</a></p>
        <div id="error">
            <Fieldset>
                <legend>Error</legend>
                <h2><b>Cannot add friend to group!
                       <br>Friend must exist, <br>must not be yourself, <br>and
                       cannot already be part of the group</b></h2>
                <form action=<%=encodeGroupInfo%>>
                    <input id="buttonstyle" type='submit' value='Back to Groups List'>
                </form>
            </Fieldset>
        </div>
    </div>
    </body>
</html>
