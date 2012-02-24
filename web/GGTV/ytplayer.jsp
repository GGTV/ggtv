<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<style>
body {
	margin: 0 0 0 0;
}
</style>
</head>
<script type="text/javascript" src="swfobject.js"></script>    
<body style="text-align:center">
<div id="marq" style="position: absolute; padding-top: 5px; color:white; width:800px; font-size:20px; display:none"></div>
<table border=0 cellspadding=0 cellspacing=0 width=100% height=100%>
	<tr><td>
  <div id="ytapiplayer">
    You need Flash player 10+ and JavaScript enabled to view this video.
  </div>
	</td></tr>
</table>
  <script type="text/javascript">

    var params = { allowScriptAccess: "always"};
    var atts = { id: "myytplayer" };
	var flashvars = {};
    swfobject.embedSWF("http://www.youtube.com/v/Zhawgd0REhA?enablejsapi=1&playerapiid=ytplayer&version=3",
                       "ytapiplayer", "100%", "100%", "8", null, flashvars, params, atts);
//	swfobject.addParam("wmode", "transparent"); 

  </script>
</body>
<script>
var isPlaying = false;
function showMarq()
{
	document.getElementById("marq").style.display = "";
	setTimeout(hideMarq, 5000);
}
function hideMarq()
{
	document.getElementById("marq").style.display = "none";
}
function onYouTubePlayerReady(playerId) {
      ytplayer = document.getElementById("myytplayer");
	  ytplayer.addEventListener("onStateChange", "onytplayerStateChange");
	  ytplayer.addEventListener("onError", "onytplayerError");
	  /*
	  play();
	  setTimeout(showMarq, 5000);
	  */
}
//unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)
function onytplayerStateChange(newState) {
//   alert("Player's new state: " + newState);
	if(newState == 0)
	{
		isPlaying = false;
		window.status = "complete";
	}
	else if(newState == 1 || newState==3 || newState==5)
		isPlaying = true;
	else if(newState == 2)
		isPlaying = false;
	else
		isPlaying = false;
}
function onytplayerError(errorCode)
{
	alert("error: " + errorCode);
	isPlaying = false;
}
function loadVideo(videoId)
{
	if(ytplayer)
		ytplayer.loadVideoById(videoId);
	else
		setTimeout(function(){loadVideo(videoId);}, 500);
}
function play() {
  if (ytplayer) {
    ytplayer.playVideo();
	//alert(ytplayer.getDuration());
  }
}
</script>
</html>