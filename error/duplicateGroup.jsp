<!-- Error display for when a user tries to create a group
     with a name that is already present in the database -->
<!DOCTYPE html>
<html>
    <head>
        <title>Duplicate Group!</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="../util/addHeader.jsp"%>
    <% String encodeGroupInfo = response.encodeURL("/proj1/security/groupInfo.jsp"); %>
    <div id="container">
        <div id="error">
            <Fieldset>
                <legend>Error</legend>
                <h2><b>Cannot create group!<br><br>Name already exists</b></h2>
                <form action=<%=encodeGroupInfo%>>
                    <input id="buttonstyle" type='submit' value='Back to Groups List'>
                </form>
            </Fieldset>
        </div>
    </div>
    </body>
</html>
