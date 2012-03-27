<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE>
<%
	boolean fDebug = false;
	String appId = "368607346499484";
	if(fDebug)
		appId = "301292833249422";
%>
<html>
 <head>
   <title>Gageeatv</title>
 </head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
</script>
 <body style="margin:0; padding:0; border:0; background-color:#000000">
 
     <div id="allContent" style="background-color: #000000; height:100%">
  		<!--<div id="output" style="color: #FFFFFF;" />-->
		<iframe id="output" src="about:blank" width=0 height=0 frameborder=0></iframe>
     </div>

     <div id="fb-root"></div>
<script src="http://connect.facebook.net/en_US/all.js"></script>
     <script type="text/javascript">
     window.fbAsyncInit = function() {
    FB.init({
      appId      : '<%=appId%>', // App ID
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });
    // Additional initialization code here
    FB.getLoginStatus(checkState);
  };
  function checkState(response) {
  if (response.status === 'connected') {
	   	echoSize();
	   	doLogin(response.authResponse.accessToken, response.authResponse.userID);
  } else {
  	fbLogin();
  }
}
  function fbLogin()
  {
	FB.login(function(response) {
	   if (response.authResponse) {
	   	//accessToken, userID, expiresIn, signedRequest
	   	echoSize();
	   	doLogin(response.authResponse.accessToken, response.authResponse.userID);
	   } else {
	   }
	 }, {scope: 'email,user_birthday,user_groups,user_hometown,user_location,read_friendlists,read_stream,offline_access'});
	}
  // Load the SDK Asynchronously
  (function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all.js";
     ref.parentNode.insertBefore(js, ref);
   }(document));
   //
   //
  function echoSize() {
		document.getElementById('output').style.width = document.documentElement.clientWidth + " px";
		document.getElementById('output').style.height = document.documentElement.clientHeight + " px";
  	    }
	function doLogin(accessToken, userId)
	{
		$.ajax({
			url: "../../servlets/Login",
			type: "POST",
			dataType: "json",
			data: {
				uid: userId,
				token: accessToken
			},
			success: function(response){
				location.href = "list.jsp?access_token=" + accessToken + "&user_id=" + userId;
			}
		});
	} 
     </script>
  </body>
</html>