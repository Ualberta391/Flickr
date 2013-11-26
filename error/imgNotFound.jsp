<!-- Error page for when the user attempts to access an image that does not exist -->
<!DOCTYPE html>
<html>
    <head>
        <title>Image Not Found</title>
        <link rel="stylesheet" type="text/css" href="/proj1/util/mystyle.css">
    </head>
    <body> 
    <%@include file="../util/addHeader.jsp"%>
    <% String encodePictureBrowse = response.encodeUrl("/proj1/display/pictureBrowse.jsp"); %>
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
