<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
<html xmlns="http://www.w3.org/1999/xhtml"><head>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
        <meta property="og:title" content="title" />
        <meta property="og:description" content="description" />
        <meta property="og:image" content="thumbnail_image" />	<title>Video</title>
	<style type="text/css">
	<!--
	-->
	</style>
    <link rel="stylesheet" type="text/css" href="fb.css" />
</head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<body style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; ">
	<embed type="application/x-shockwave-flash" src="https://www.youtube.com/v/<%=request.getParameter("vid")%>?version=3&amp;autohide=1&amp;autoplay=1" width="398" height="224" style="display: block;" id="swf_uqou4_89" name="swf_uqou4_89" bgcolor="#FFFFFF" quality="high" scale="scale" allowfullscreen="true" allowscriptaccess="never" salign="tl" wmode="opaque" flashvars="width=398&amp;height=224">
</body>
</html>
