<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="javax.crypto.Mac" %>
<%@ page import="javax.crypto.spec.SecretKeySpec" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="org.apache.commons.codec.binary.Base64" %>
<%@ page import="org.json.JSONObject" %>
<%
	long l = 1325102400;
	System.out.println("expired date: " + new java.util.Date(l*1000));
	String fbSecretKey = "4a841b03e65e229d8309c94fa921d186";
	String fbAppId = "368607346499484";
	String signed_request = request.getParameter("signed_request");
	String accessToken = "";
	String user_id = "";
	System.out.println("signed_request=" + signed_request);
	if(signed_request != null)
	{
		Base64 base64 = new Base64(true);
		String[] signedRequest = signed_request.split("\\.", 2);
		//parse signature
		String sig = new String(base64.decode(signedRequest[0].getBytes("UTF-8")));
		//parse data and convert to json object
		JSONObject data = new JSONObject(new String(base64.decode(signedRequest[1].getBytes("UTF-8"))));
		if(data.has("algorithm"))
			System.out.println("algorithm=" + data.getString("algorithm"));
		if(!hmacSHA256(signedRequest[1], fbSecretKey).equals(sig))
		{
			System.out.println("signature is not correct, possibly the data was tampered with");
		}
		if(!data.has("user_id") || !data.has("oauth_token"))
		{
			System.out.println("user_id or oauth_token not found.");
			out.print("Please sign in facebook first.");
			out.close();
		}
		else 
		{
			//this is authorized user, get their info from Graph API using received access token
			accessToken = data.getString("oauth_token");
			user_id = data.getString("user_id");
			System.out.println("accessToken=" + accessToken);
			System.out.println("user_id=" + data.getString("user_id"));
			//
			System.out.println(data);
		}
	}
	else
	{
		if(request.getParameter("jft")!=null && request.getParameter("jft").equals("gagia"))
		{
		}
		else
		{
			out.print("");
			out.close();
		}
	}
%>
<%!
private String hmacSHA256(String data, String key) throws Exception {
        SecretKeySpec secretKey = new SecretKeySpec(key.getBytes("UTF-8"), "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(secretKey);
        byte[] hmacData = mac.doFinal(data.getBytes("UTF-8"));
        return new String(hmacData);
    }
%>
<!DOCTYPE>
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
		<iframe id="output" src="about:blank"></iframe>
     </div>

     <div id="fb-root"></div>
     <script src="http://connect.facebook.net/en_US/all.js"></script>
     <script type="text/javascript">
  	 FB.init({
    		appId  : '368607346499484',
            status     : true, 
            cookie     : true,
            xfbml      : true
  	    });

  	 function echoSize() {
		/*
    	      document.getElementById('output').innerHTML = 
                 "HTML Content Width: " + window.innerWidth + 
                 " Height: " + window.innerHeight;
    	      console.log(window.innerWidth + ' x ' + window.innerHeight);
		*/
		document.getElementById('output').style.width = document.documentElement.clientWidth + " px";
		document.getElementById('output').style.height = document.documentElement.clientHeight + " px";
		//document.getElementById('output').src = "index.jsp?access_token=<%=accessToken%>&user_id=<%=user_id%>";
		//document.getElementById('output').src = "list.jsp?access_token=<%=accessToken%>&user_id=<%=user_id%>";
  	    }
	function doLogin()
	{
		$.ajax({
			url: "../../servlets/Login",
			type: "POST",
			dataType: "json",
			data: {
				uid: "<%=user_id%>",
				token: "<%=accessToken%>"
			},
			success: function(response){
				location.href = "list.jsp?access_token=<%=accessToken%>&user_id=<%=user_id%>";
				//alert(response);
			}
		});
	}
	<%
	if(request.getParameter("jft")!=null && request.getParameter("jft").equals("gagia"))
	{
	%>
		location.href = "list.jsp?access_token=<%=accessToken%>&user_id=<%=user_id%>";
	<%
	}
	else
	{
	%>
    	doLogin();
    <%
    }
    %>
	   echoSize();
  	   window.onresize = echoSize;
     </script>
  </body>
</html>