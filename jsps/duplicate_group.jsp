<!DOCTYPE html>
<html>
    <head>
        <title>Duplicate Group!</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>
    <body> 
    <%@include file="add_header.jsp"%>
    <% String encodeGroupInfo = response.encodeURL("GroupInfo.jsp"); %>
    <div id="container">
        <div id="error">
            <Fieldset>
                <legend>Error</legend>
                <h2><b>Cannot create group!<br> Name already exists</b></h2>
                <form action=<%=encodeGroupInfo%>>
                    <input id="buttonstyle" type='submit' value='Back to Groups List'>
                </form>
            </Fieldset>
        </div>
    </div>
    </body>
</html>
