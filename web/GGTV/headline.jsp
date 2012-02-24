<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
	<title>Video</title>
	<style type="text/css">
	<!--
		.itemSelected {font-size:20px; color:#CC6633;}
	-->
	</style>
	
</head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
function showBackBtn()
{
	$('#divBack').show();
	$('#divView').hide();
	$('#divControlPanel').hide();
	$('#divControlPanel').children('span').removeClass("itemSelected");
}
function showViewBtn()
{
	$('#divView').show();
	$('#divBack').hide();
}
function backToList()
{
	if(window.parent.ytplay.isPlaying)
	{
		$('#divControlPanel').show();
		showViewBtn();
	}
	window.parent.mainFrame.cols="*,0";
}
function viewVideo()
{
	$('#divBack').show();
	window.parent.mainFrame.cols="0,*";
	if(window.parent.ytplay.ytplayer)
	{
		window.parent.ytplay.ytplayer.playVideo();
	}
	showBackBtn();
}
function pauseVideo()
{
	if(window.parent.ytplay.ytplayer)
		window.parent.ytplay.ytplayer.pauseVideo();
}
function stopVideo()
{
	if(window.parent.ytplay.ytplayer)
		window.parent.ytplay.ytplayer.stopVideo();
	//
	showBackBtn();
	$('#divBack').hide();
}
$(document).ready(function(e)
{
	$('#divBack').hide();
	$('#divBack').bind('click', function(){
		backToList();
		$('#buttons span').removeClass('itemSelected');
		$('#divBack').addClass('itemSelected');
	});
	$('#divView').bind('click', function(){
		viewVideo();
		$('#buttons span').removeClass('itemSelected');
		$('#divView').addClass('itemSelected');
	});
	//
	$('#pause').bind('click', function(){
		pauseVideo();
		$('#divControlPanel').children('span').removeClass('itemSelected');
		$('#pause').addClass('itemSelected');
	});
	$('#stop').bind('click', function(){
		stopVideo();
		$('#divControlPanel').children('span').removeClass('itemSelected');
		$('#stop').addClass('itemSelected');
	});
});
</script>
<body>
<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
	<tr>
		<td align="left" valign="middle" id="buttons">
			<span id="divBack" style="display:none;cursor:hand">Back</span>
			<span id="divView" style="display:none;cursor:hand">View Video</span>
		</td>
		<td align="left" valign="middle">
			PlayMode&nbsp;<select id="playMode">
				<option value="0">Once</option>
				<option value="1">Repeat</option>
				<option value="2">Continuous</option>
			</select>
		</td>
		<td align="left" valign="middle">
			<div id='divControlPanel' style="display:none">
				<span id="pause" style="cursor:hand">Pause</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<span id="stop" style="cursor:hand">Stop</span>
			</div>
		</td>
		<td align="center" valign="middle">
			<h1></h1>
			<span id="sTitle"></span><span id="sCount"></span>
		</td>
		<td align="right" valign="middle">
			Category&nbsp;<select id="cateList">
			</select>
		</td>
	</tr>
</table>
</body>
</html>