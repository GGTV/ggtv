<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
</head>
<script>
function getToken()
{
    var access_token = "<%=request.getParameter("access_token")%>";
    if(access_token == '')
        access_token = "AAAFPPxXzH5wBALgIXt3lQFcatEBwjqIi22oh0Yh1PJ17YgspJmQj02aEBmuaWxwdhbZAkp52BbYARIDXKapVLFhsed4cL8kZCNBrJnWyd7pTqscIY8";
	return access_token;
}

</script>
<frameset rows="0,*,0">
  <frame src="" id="headline" name="headline" border=0/>
  <frameset cols="*,0" name="mainFrame" id="mainFrame">
	<frame src="list.jsp" id="main" name="main" border=0/>
	<frame src="ytplayer.jsp" id="ytplay" name="ytplay" border=0/>
  </frameset>
  <frame src="" id="menu" name="menu" border=0/>
</frameset>