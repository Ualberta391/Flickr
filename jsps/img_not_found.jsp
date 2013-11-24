<!DOCTYPE html>
<html>
    <head>
        <title>Image Not Found</title>
        <link rel="stylesheet" type="text/css" href="mystyle.css">
    </head>
    <body> 
    <%@include file="add_header.jsp"%>
    <% String encodePictureBrowse = response.encodeUrl("PictureBrowse.jsp"); %>
    <div id="container">
        <div id="error">
            <Fieldset>
                <legend>Error</legend>
                <h2><b>Image not found!</b></h2>
                <form action=<%=encodePictureBrowse%>>
                    <input id="buttonstyle" type='submit' value='Back to Picture List'>
                </form>
            </Fieldset>
        </div>
    </div>
    </body>
</html>
