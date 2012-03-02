function onYouTubePlayerReady(playerId) {
      ytplayer = document.getElementById("myytplayer");
	  ytplayer.addEventListener("onStateChange", "onytplayerStateChange");
	  ytplayer.addEventListener("onError", "onytplayerError");
	  play();
}
//unstarted (-1), ended (0), playing (1), paused (2), buffering (3), video cued (5)
function onytplayerStateChange(newState) {
//   alert("Player's new state: " + newState);
	if(newState == 0)
	{
		isPlaying = false;
		window.status = "complete";
		if(playMode == 0);
		else if(playMode == 1)
		{
			playAgain();			
		}
		else if(playMode == 2)
		{
			playNextVideo();	
		}
	}
	else if(newState == 1 || newState==3 || newState==5)
	{
		isPlaying = true;
	}
	else if(newState == 2)
		isPlaying = false;
	else
		isPlaying = false;
}
function onytplayerError(errorCode)
{
//	alert("error: " + errorCode);
	isPlaying = false;
		if(playMode == 0 || playMode == 1);
		else if(playMode == 2)
		{
			playNextVideo();	
		}
}
function yt_loadVideo(videoId)
{
	if(ytplayer)
	{
		ytplayer.loadVideoById(videoId);
	}
	else
		setTimeout(function(){yt_loadVideo(videoId);}, 500);
}
function play() {
  if (ytplayer) {
    ytplayer.playVideo();
  }
}