<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<!DOCTYPE>
<%
	String feedVid = request.getParameter("v");
	String feedVidTitle = request.getParameter("title");
//	System.out.println("######" + feedVid);
	String digest = request.getParameter("secret");
	String[] appIds = new String[]{"246324865464948"};
	String[] categories = new String[]{"Music"};
	boolean fDebug = false;
	String appId = "368607346499484";	//all
	String topic = "";
	if(fDebug)
	{
		appId = "301292833249422";
		appIds[0] = appId;
	}
	try
	{
		if(digest!=null && !digest.equals(""))
		{
			boolean fMatch = false;
			
			for(int i=0;i<categories.length;i++)
			{
				String getDigest = org.gagia.core.security.MD5Digest.getDigest(categories[i], "368607346499484");
				if(digest.equals(getDigest))
				{
					fMatch = true;
					topic = categories[i];
					appId = appIds[i];
					break;
				}
			}
			if(!fMatch)
			{
				out.println("");
				return;
			}
			
		}
	}
	catch(Exception e)
	{
		out.println("...");
	}
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
				location.href = "list.jsp?access_token=" + accessToken + "&user_id=" + userId + "&topic=<%=topic%>&fDebug=<%=fDebug%>&feedVid=<%=feedVid%>&title=<%=feedVidTitle%>";
			}
		});
	} 
     </script>
  </body>
</html>