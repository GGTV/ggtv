<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<meta property="fb:app_id" content="368607346499484" />
<meta property="og:title" content="" />
<meta property="og:type" content="website" />
<meta property="og:title" content="title" />
<meta property="og:url" content="http://ggtv.nni.com.tw/gageeatv" />
<meta property="og:description" content="description" />
        <meta property="og:image" content="thumbnail_image" />	<title>Video</title>
	<style type="text/css">
	<!--
	.showLoading{
		position:absolute;
		float:right;
		right:100px;
		top:0px;
		color:white;
	}
	.menu_box{
		position:absolute;
		float:right;
		right:0px;
	}
	.menu_box_align_left{
		position:absolute;
		float:left;
		left:0px;
	}
	.bottom{
		bottom:20px;
	}
	.normal {
		white-space: normal; /* default value */
		width: 120px;        /* specific width */
		}
	.wrapped {
		/* wrap long urls */
		white-space: pre;           /* CSS 2.0 */
		white-space: pre-wrap;      /* CSS 2.1 */
		white-space: pre-line;      /* CSS 3.0 */
		white-space: -pre-wrap;     /* Opera 4-6 */
		white-space: -o-pre-wrap;   /* Opera 7 */
		white-space: -moz-pre-wrap; /* Mozilla */
		white-space: -hp-pre-wrap;  /* HP Printers */
		word-wrap: break-word;      /* IE 5+ */
		/* specific width */
		width: 120px; 
		}
	.truncated { display:inline-block; max-width:120px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; color:white}
	.underline {text-decoration:underline overline; color:orange}
	.listAreaFrame {
		float:left;
		overflow:hidden;
		width:100%;
		height:17%;
		position:absolute;
		z-index:100;
		background-color:black;
		bottom:0px;
	}
	.selectedItem {
		position:absolute;
		margin-left:180px;
		margin-top:3px;
		width:100px;
		height:17%;
		background-color:gray;
		filter: Alpha(Opacity=0);
		-moz-opacity: 0.0;
		opacity: 0.0;
	}
	.img_opacity{
		filter: Alpha(Opacity=35);
		-moz-opacity: 0.35;
		opacity: 0.35;
	}
	-->
	</style>
    <link rel="stylesheet" type="text/css" href="fb.css" />
    <link rel="stylesheet" type="text/css" href="css/smoothness/jquery-ui-1.8.18.custom.css" />
</head>
<script type="text/javascript" src="swfobject.js"></script>    
<script type="text/javascript" src="date_fmt.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript" src="jquery.hotkeys.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.8.18.custom.min.js"></script>
<script>
<%@ include file="ytscript.jsp" %>
var currentPlayItemVid = null;
function toTimestamp(strDate){
 var datum = Date.parse(strDate);
 return datum/1000;
}
function formatDuration(sec)
{
	var s = sec % 60;
	var m = parseInt(sec / 60);
	var h = parseInt(m / 60);
	s = s<10?"0" + s:s;
	m = m<10?"0" + m:m;
	h = h<10?"0" + h:h;
	if(h=="00")
		return m + ":" + s;
	else
		return h + ":" + m + ":" + s;
}
    var curOffset = -100;
    var curIndex = 0;
    var curType;
    var curCate = "";
function loadOlderPosts(fHideLoading)
{
    curIndex += 1;
    loadVideo(curType, curCate, fHideLoading);
}
var screenWidth = document.documentElement.clientWidth;
var screenHeight = document.documentElement.clientHeight;
var w = (screenWidth - 20 - 20 - 50)/7;
//var itemHeight = screenHeight * 20/100 - 16;
var itemHeight = $(window).height() * 17/100 - 16;
function loadCachedPosts(offset, fReset)
{
	fReset = fReset==undefined?true:fReset;
	var cacheObj = cache[curType +"_"+curCate];
	//var response = cachedVideoData;
	var response = cacheObj.data;
	var ary = [];
	curIndex += offset;
	var theIdx = curIndex;
	var vData = {};
	for(var i=theIdx;i<response.video.length && i<theIdx+100;i++)
	{
		var item = response.video[i];
		var img = item.thumb==null?"images/video.png":item.thumb;
		ary[ary.length] = "<div id='item_"+item.key+"' vid='"+item.key+"' surl='"+item.share_url+"' style='width:"+w+"px; float:left; margin:3px;cursor:hand;'>" + 
							"<img src='"+ img+"' width="+w+" height="+itemHeight+" class='img_opacity'/>" +
						  "</div>";		
		vData[item.key] = {}
		vData[item.key].vtitle = item.title;
		vData[item.key].desc = item.description;
		vData[item.key].lastPostTime = item.lastPostTime;
	}
	if(fReset)
	{
		$('#listArea').empty();
//		$('#listArea').css('marginLeft', '0px');
	}
	//$('#listArea').append('<table border=0 width=100% id=tbList><tr><td align=center width=100%>'+ary.join('')+'</td></tr></table>');
	$('#listArea').append(ary.join(''));
	$('div[id^=item_]').each(function(){
		$(this).attr('video_title', vData[$(this).attr('vid')].vtitle);
		$(this).attr('desc', vData[$(this).attr('vid')].desc);
		$(this).attr('lastPostTime', vData[$(this).attr('vid')].lastPostTime);
		$(this).bind('click', function(){
			var vid = $(this).attr("vid");
			playVideo(vid);
		});
	});
	var moveW = (w+6)/shortcutCount;
	
	window.status = "???????????" + $('#listArea').css('marginLeft');
	$('#listArea').css('marginLeft', "0px").css('marginLeft', moveW*3*shortcutCount + "px");
	/*
	while(idx!=0)
    {
	  $('#listArea').animate({
		   'marginLeft':"+="+moveW+"px"
	   }, 0);
	  idx--;
    }
	*/
	$('#next').bind('click', function(){
		moveToNextPage();
		//loadOlderPosts();
	});
	$('#pre').bind('click', function(){
		moveToPrevPage();
		/*
		if(curIndex>0)
			loadCachedPosts(-1);
		*/
	});
	if(fAutoPlayNext)
		playNextVideo();
}
function getToken()
{
    var access_token = "<%=request.getParameter("access_token")%>";
//    alert('<%=request.getParameter("user_id")%>');
    if(access_token == '')
        access_token = "AAAFPPxXzH5wBAPqIFsd2NZB4H4nd8ypqe0sMF4eFTZBznI1mfa0umI9qbrNSy9YQmgymXTC2gO4gsMMgjHs5mQqhZBTx6ZC8fHgQ3LQqIQZDZD";
	return access_token;
}

function loadData(mItemId)
{
	curOffset = -100;
	curIndex = 0;
	curCate = "";
	//
	if($('#btnCate').val()!="Category")
		$('#btnCate').val($('#divCate option[value=""]').text());
	var type = -1;
	if(mItemId == "mM")
	{
		type = 3;
	}
	if(mItemId == "mP")
	{
		type = 2;
	}
	else if(mItemId == "mR")
	{
		type = 1;
	}
	else if(mItemId == "mG")
	{
		type = 0;
	}
	cache[type+"_"+curCate] = {finish:0, offset:-100, pause:0, index:0};
	loadVideo(type, curCate);
	$('a[id^=m]').removeClass("underline");
	$('#'+mItemId).addClass("underline");
//	loadCategory(type);
}
function loadCategory(type)
{
	var cates = new Array("All", "Autos", "Film & Animation", "Comedy", "Music", "Games", "News", "Sports", "Travel", "Technology");
	var otherCates = new Array();
	$.ajax(
	{
		url: '../../servlets/LoadCategory',
		//data: {type:type, token:window.parent.getToken()},
		data: {type:type, token:getToken()},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			var ary = new Array();
			
			$('#divCate').empty();
			//ary[ary.length] = "<option value=''>All</option>";
			var styleSelected = "background-color:#FFA500;";
			if(curCate == '')
				ary[ary.length] = "<div rel='' style='"+styleSelected+"cursor:hand'>All</div>";
			else
				ary[ary.length] = "<div rel='' style='cursor:hand'>All</div>";
			var cateData = {};
			for(var i=0;i<response.category.length;i++)
			{
				var item = response.category[i];
				var fFound = false;
				for(var j=0;j<cates.length;j++)
				{
					if(item.category == cates[j])
					{
						var css_bgColor = "";
						if(curCate == item.category)
							css_bgColor = "background-color:#FFA500;";
						ary[ary.length] = "<div rel='cate_"+i+"' style='"+css_bgColor+"cursor:hand'>"+item.category+"</div>";
						cateData['cate_'+i] = item.category;
						fFound = true;
						break;
					}
				}
				if(fFound==false)
					otherCates[item.category] = item.category;
			}
			ary[ary.length] = "<div rel='more' style='cursor:hand'>more</div>";
			$('#divCate').append(ary.join(''));
			$('#divCate').children('div').each(function(){
				$(this).attr('rel', cateData[$(this).attr('rel')]);
			});
			$('#divCate').children('div').bind('click', function(){
				$('#divCate').children('div').css('background-color', '');
				$(this).css('background-color', 'black');
				if($(this).attr('rel')!='more')
				{
					//$('#divCate').hide("slow");
					if(timerLoad!=null)
						clearInterval(timerLoad);
					cache[type+"_"+$(this).attr('rel')] = {finish:0, offset:-100, pause:0, index:0};
					loadVideo(type, $(this).attr('rel'));					
				}
				else
				{
					var ary = new Array();
					//for(var i=0;i<otherCates.length;i++)
					for(var cc in otherCates)
					{
						ary[ary.length] = "<div rel='"+cc+"' style='cursor:hand' tag='more'>"+cc+"</div>";
					}
					$('#divCate').children('div[rel=more]').hide();
					$('#divCate').append(ary.join(''));
					$('#divCate').children('div[tag=more]').bind('click', function(){
						$('#divCate').children('div').css('background-color', '');
						$(this).css('background-color', 'black');
						if(timerLoad!=null)
							clearInterval(timerLoad);
						cache[type+"_"+$(this).attr('rel')] = {finish:0, offset:-100, pause:0, index:0};
						loadVideo(type, $(this).attr('rel'));					
					});
				}
			});
		},
		complete: function(xhr, status){
		}
	});
}
var cachedVideoData;
var playMode = 0;
var fAutoPlayNext = false;
var cache = {};
var timerLoad = null;
var timerKeyup = {'right':{"t":0},'left':{"t":0}};
var lastPostTime = null;
function loadOlderData(type, cate)
{
	var j = 0;
	try
	{
		j = $(currentSelectedItem).prevAll().length;
	}
	catch(e){}
	var size = $('#listArea').children('div[id^=item_]').length;
	if((size - j)>=20)
		return;
	var lastItem = $('#listArea div:last-child');
	var dateTime = lastItem.attr('lastPostTime').substring(0, lastItem.attr('lastPostTime').indexOf("."));
	if(dateTime==lastPostTime)
		return;
	lastPostTime = dateTime;
	dateTime = dateTime.replace(/-/g, "/");
	
	var params = {column:'max_created_time', order:'desc', offset:-100, timestamp:toTimestamp(dateTime)-1, type:type};
	if(cate!='')
		params = $.extend(params, {cate:cate});
	if(type==2)
		params = $.extend(params, {token:getToken()});
	$.ajax(
	{
		url:'../../servlets/LoadVideo',
		data:params,
		type:'POST',
		dataType:'json',
		error:function(xhr, status, e) {
			//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			var ary = [];
			var vData = {};
			if(response.video.length==0)
				clearInterval(timerLoad);
			if(cate != curCate)
				return;
			for(var i=0;i<response.video.length;i++)
			{
				var item = response.video[i];
				var img = item.thumb==null?"images/video.png":item.thumb;
				ary[ary.length] = "<div id='uitem_"+item.key+"' vid='"+item.key+"' surl='"+item.share_url+"' style='width:"+w+"px; float:left;cursor:hand;margin:3px'>" + 
									"<img src='"+ img+"' width="+w+" height="+itemHeight+" class='img_opacity'/>" +
								  "</div>";
				vData[item.key] = {};
				vData[item.key].vtitle = item.title;
				vData[item.key].desc = item.description;
				vData[item.key].lastPostTime = item.lastPostTime;
			}
			$('#listArea').append(ary.join(''));
			$('div[id^=uitem_]').each(function(){
				$(this).attr('video_title', vData[$(this).attr('vid')].vtitle);
				$(this).attr('desc', vData[$(this).attr('vid')].desc);
				$(this).attr('lastPostTime', vData[$(this).attr('vid')].lastPostTime);
				$(this).attr('id', 'item_'+$(this).attr('vid'));
				$(this).bind('click', function(){
					var vid = $(this).attr("vid");
					playVideo(vid);
				});
			});
		},
		complete: function(xhr, status){
		}
	});
}
function loadVideoData(type, cate, offset, fHideLoading)
{
	if(cache[type+"_"+cate].finish == 0)
	{
		var fShowLoading = fHideLoading==undefined?true:!fHideLoading;
		{
			if(fShowLoading)
			{
				$("#loading").show();
			}
			//
			var params = {column:'max_created_time', order:'desc', offset:offset, timestamp:toTimestamp(new Date()), type:type};
			if(cate!='')
				params = $.extend(params, {cate:cate});
			if(type==2 || type==3)
				params = $.extend(params, {token:getToken()});
			$.ajax(
			{
				url:'../../servlets/LoadVideo',
				data:params,
				type:'POST',
				dataType:'json',
				error:function(xhr, status, e) {
					//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
				},
				success: function(response)
				{
					try
					{
						cache[type+"_"+cate].data = response;
						cachedVideoData = response;
						timerLoad = setInterval(function(){loadOlderData(type, cate);}, 500);
						//
						if(fShowLoading)
						{
							loadCachedPosts(0);
							currentSelectedItem = $('div[id^=item_]')[0];
							$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
							$('#selectedItemTitle').text($('#listArea').find(currentSelectedItem).attr('video_title'));
							$('#selectedItemTitle').focus();		
						}
					}
					catch(e){}
				},
				complete: function(xhr, status){
					if(fShowLoading)
						$('#loading').hide();
						//$('#loading').dialog('close');
				}
			});
		}
	}
}
function loadVideo(type, cate, fHideLoading)
{
	curType = type;
	curCate = cate;
	if(cache[type+"_"+cate] == undefined)
		cache[type+"_"+cate] = {finish:0, offset:-100, pause:0, index:0};
	var cacheObj = cache[type+"_"+cate];
	if(cacheObj.offset == -100 || cacheObj.pause==1)
	{
		if(cacheObj.offset == -100)
			curIndex = 0;
		if(cacheObj.finish==1)
			return;
		//
		loadCategory(type);
		cacheObj.pause=0;
		loadVideoData(type, cate, cacheObj.offset, fHideLoading);
	}
	else
		loadCachedPosts(0);
}
var hideListTT = null;
function playVideo(vid)
{
	if($('#myytplayer').is('div'))
	{
		var params = { allowScriptAccess: "always",  allowfullscreen:"true", wmode:"transparent"};
		var atts = { id: "myytplayer" };
		var flashvars = {};
		var windowHeight = $(window).height();
		//var h = windowHeight - $('#listAreaFrame').height() - $('#menu').height() - $('#toolbar').height() - 10;
		var h = windowHeight - $('#listAreaFrame').height() - $('#toolbar').height() - 8;
		var ratio = h/windowHeight;
		var w = $(window).width()*ratio;
		$('#tbPlayer').height(h);
		$('#tbPlayer').width(w);
		var objWidth = "100%";
		var objHeight = "100%";
		if($.browser.msie)
		{
			objWidth = w;
			objHeight = h;
		}
		swfobject.embedSWF("http://www.youtube.com/v/"+vid+"?enablejsapi=1&playerapiid=ytplayer&version=3",
						"myytplayer", objWidth, objHeight, "8", null, flashvars, params, atts);
	}
	else
	{
		yt_loadVideo(vid);
	}
	if($('#btnFull').css('display')=="none" && $('#btnRestore').css('display')=="none")
		$('#btnFull').show();
	//		
	$('#spanPlaying').text($('div[vid='+vid+']').attr('video_title'));
	currentPlayItemVid = vid;
	//
	if(document.getElementById("listAreaFrame").style.display == "none")
		moveToCurrentPlayItem();
	
	//
	if(hideListTT!=null)
		clearTimeout(hideListTT);
	//hideListTT = setTimeout(function(){hideList();}, 8000);
}
function playAgain()
{
	if(currentPlayItemVid != null)
	{
		playVideo(currentPlayItemVid);
	}	
}
function playNextVideo()
{
	fAutoPlayNext = false;
	if(currentPlayItemVid != null)
	{
		var nextVid = $('#item_' + currentPlayItemVid).next().attr('vid');
		if(nextVid==undefined)
		{
			loadOlderPosts(true);
			fAutoPlayNext = true;
		}
		else
			playVideo(nextVid);
	}
}
function playPrevVideo()
{
	fAutoPlayPrev = false;
	if(currentPlayItemVid != null)
	{
		var prevVid = $('#item_' + currentPlayItemVid).prev().attr('vid');
		if(prevVid==undefined)
		{
			//ToDO: loadNewerPosts
//			loadNewerPosts(true);
			fAutoPlayPrev = true;
		}
		else
			playVideo(prevVid);
	}
}
var debug = true;
function loadStream(vid)
{
	$.ajax(
	{
		url: '../../servlets/LoadStream',
		data: {vid:vid},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			if(debug)
			//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
			debug = false;
		},
		success: function(response)
		{
			var ary = new Array();
			for(var i=0;i<response.stream.length;i++)
			{
				var stream = response.stream[i];
				var hr = i==0?"":"<hr>";
				ary[ary.length] = hr + "<div>"+stream.name + ": " + stream.message+"</div>";
			}
			$("#si_" + vid).html(ary.join(''));
		},
		complete: function(xhr, status){
		}
	});		
}
var currentSelectedItem = null;
var shortcutCount = 7;
var idx = 3*shortcutCount;
var initMarginLeft = 0;
var flag = 0;
function isInteger(s) {
  return (s.toString().search(/^-?[0-9]+$/) == 0);
}
function hideList()
{
	if(isPlaying == false)
		return;
	var h = $(window).height()-20;
	var ratio = h/$(window).height();
	window.status = h + ',' + w;
	$('#tbPlayer').height(h);
	$('#tbPlayer').width($(window).width());
	$('#listAreaFrame').hide('fast');
	$('#showListBtn').show();
	//
	$('#divCate').hide();
}
function showList()
{
	if(hideListTT != null)
	{
		clearTimeout(hideListTT);
	}
	if(document.getElementById('listAreaFrame').style.display='none')
	{
		var windowHeight = $(window).height();
		var h = windowHeight - 120 - 20;
		var ratio = h/windowHeight;
		var w = $(window).width()*ratio;
		$('#tbPlayer').height(h);
		$('#tbPlayer').width(w);
		//
		$('#listAreaFrame').show();
		$('#showListBtn').hide();
//		hideListTT = setTimeout(function(){hideList();}, 8000);		
	}	
	$('#divCate').show();
}
function moveToCurrentPlayItem()
{
	var moveW = (w+6)/shortcutCount;
	//
	var tmpIdx = idx;
	var fFound = false;
	if(currentPlayItemVid == currentSelectedItem.attr('vid'))
		return;
	var currentPlayItem = $('#listArea').children('[vid='+currentPlayItemVid+']')[0];
	var i = $(currentPlayItem).prevAll().length;
	var j = $(currentSelectedItem).prevAll().length;
	if((i-j)<0)
	{
		idx = i*shortcutCount;
	   $('#listArea').animate({
		'marginLeft':"+="+moveW * Math.abs(i-j)*shortcutCount+"px"
		}, 100);
		$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
		currentSelectedItem = $('#listArea').children('[vid='+currentPlayItemVid+']');
		$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');				
		$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
		
	}
	else if((i-j)>0)
	{
		idx = j*shortcutCount;
		$('#listArea').animate({
			'marginLeft':"-="+moveW * (i-j)*shortcutCount+"px"
		}, 100);
		$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
			currentSelectedItem = $('#listArea').children('[vid='+currentPlayItemVid+']');
			$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
			$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));		
	}
}
function moveToFirst()
{
	var prevAll = $(currentSelectedItem).prevAll();
	var len = prevAll.length;
	window.status = "**********" + len;
	if(len<=0)
	{
		return;
	}
	var moveW = (w+6)/shortcutCount;
 	$('#listArea').animate({
		'marginLeft':"+="+moveW * len * shortcutCount+"px"
	}, 100);
	$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
	currentSelectedItem = $(currentSelectedItem).prevAll().slice(len-1, len);
	$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
	$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
}
function moveToEnd()
{
	var nextAll = $(currentSelectedItem).nextAll();
	var len = nextAll.length;
	if(len==0)
		return;
	var moveW = (w+6)/shortcutCount;
 	$('#listArea').animate({
		'marginLeft':"-="+moveW * len * shortcutCount+"px"
	}, 100);
	$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
	window.status = "**********" + $(currentSelectedItem).nextAll().length;
	currentSelectedItem = nextAll.slice(len-1, len);
	$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
	$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
}
function moveToNextPage()
{
	var nextAll = $(currentSelectedItem).nextAll();
	var len = nextAll.length<7?nextAll.length:7;
	if(len==0)
	{
		moveToNextPage();
		return;
	}
//	alert(len);
	var moveW = (w+6)/shortcutCount;
 	$('#listArea').animate({
		'marginLeft':"-="+moveW * len * shortcutCount+"px"
	}, 100);
	$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
	window.status = "**********" + $(currentSelectedItem).nextAll().length;
	currentSelectedItem = nextAll.slice(len-1, len);
	$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
	$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
}
function moveToPrevPage()
{
	var prevAll = $(currentSelectedItem).prevAll();
	var len = prevAll.length<7?prevAll.length:7;
	window.status = "**********" + len;
	if(len<=0)
	{
		return;
	}
	var moveW = (w+6)/shortcutCount;
 	$('#listArea').animate({
		'marginLeft':"+="+moveW * len * shortcutCount+"px"
	}, 100);
	$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
	currentSelectedItem = $(currentSelectedItem).prevAll().slice(len-1, len);
	$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
	$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
}
function addShortcutEvent()
{
	//
	var marginLeft = w*3+20+10;
	var moveW = (w+6)/shortcutCount;
   $(document).bind('keyup', 'home', function(){
		moveToFirst();
   });
   $(document).bind('keyup', 'end', function(){
   		moveToEnd();
   });
   $(document).bind('keyup', 'right', function(){
		if($('#listArea').find(currentSelectedItem).next().attr('vid') != undefined)
		{
			window.status = "before:" + idx + ".." + $('#listArea').css('marginLeft');
			
			$('#listArea').animate({
				'marginLeft':"-="+moveW+"px"
			}, 100);
			idx++;
			if(idx%shortcutCount==0)
			{
				/*
				if(timerKeyup.right.t == 0)
				{
					timerKeyup.right.t = toTimestamp(new Date());
					timerKeyup.right.idx = idx;
					timerKeyup.right.oldIdx = idx - shortcutCount;
					//
					$('#listArea').animate({
						'marginLeft':"-="+moveW +"px"
					}, 100);
					$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
					currentSelectedItem = $('#listArea').find(currentSelectedItem).next();
					$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
					$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
				}
				else
				{
					var now = toTimestamp(new Date());
					if((now - timerKeyup.right.t)<1)
					{
						timerKeyup.right.t = now;
						currentSelectedItem = $('#listArea').find(currentSelectedItem).next();
						timerKeyup.right.idx = idx;
						$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
					}
					else*/
					{
						/*
						var r = idx-timerKeyup.right.oldIdx;
						$('#listArea').animate({
							'marginLeft':"-="+moveW * (r-3)+"px"
						}, 100);
						*/
						$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
						currentSelectedItem = $('#listArea').find(currentSelectedItem).next();
						$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
						$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
						timerKeyrup.right.t = 0;
					}
			//	}
			}
			window.status = "after: " + idx;
		}
		/*
		else
		{
			window.status = "before(DD): " + idx;
			$('#listArea').animate({
			 'marginLeft':marginLeft
			 }, 0);
			idx=0;
			flag++;
			$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
			currentSelectedItem = $('#listArea').children('div[id^=item_]')[0];
			$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');
			$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
			window.status = "after(DD): " + idx + "," + flag;
		}
		*/
   		showList();
   });
  $(document).bind('keyup', 'left', function(){
	   //if(idx!=0)
	   if($(currentSelectedItem).prevAll().length!=0)
	   {
		   $('#listArea').animate({
			'marginLeft':"+="+moveW+"px"
			}, 100);
		   //idx-=0.5;
		   idx--;
   			if(idx%shortcutCount==0)
			{
				$('#listArea').find(currentSelectedItem).children('img').addClass('img_opacity');
				currentSelectedItem = $('#listArea').find(currentSelectedItem).prev();
				$('#listArea').find(currentSelectedItem).children('img').removeClass('img_opacity');				
				$('#selectedItemTitle').text(currentSelectedItem.attr('video_title'));
			}
	   }
		showList();
   });
  $(document).bind('keyup', 'pagedown', function(){
	if(isPlaying)
	{
		playNextVideo();
	}
  	//skip and playNext
  });
  $(document).bind('keyup', 'pageup', function(){
  	//skip and playPrev
	if(isPlaying)
	{
		playPrevVideo();
	}
  });
    while(idx!=0)
    {
	  $('#listArea').animate({
		   'marginLeft':"+="+moveW+"px"
	   }, 0);
	  //idx-=0.5;
	  idx--;
    }
    $(document).bind('keyup', 'return', function(){
    	playVideo(currentSelectedItem.attr('vid'));
	});
	initMarginLeft = $('#listArea').css('marginLeft');
}
function bindEvent()
{
	$('#showListBtn').bind('click', function(){
		showList();
	});
	$('#btnFull').bind('click', function(){
		hideList();
		$(this).hide();
		$('#btnRestore').show();
	});
	$('#btnRestore').bind('click', function(){
		showList();
		$(this).hide();
		$('#btnFull').show();
	});
//
	addShortcutEvent();
//
	$('a[id^=m]').each(function(){
		$(this).bind('click', function(){
			$('a[id^=m] span').removeClass('itemSelected');
			$(this).children('span').addClass('itemSelected');
			loadData(this.id);
			return false;
		});
	});
	//
	/*
	$('#btnPlayMode').bind('click', function(){
		if($('#divPlayMode').css('display')=='none')
		{
//			$('#divCate').hide();
			$('#divPlayMode').show();
		}
		else
			$('#divPlayMode').hide();
	});
	$('div[id^=playMode]').bind('click', function(){
		$('div[id^=playMode]').css('background-color', '');
		$(this).css('background-color', 'black');
		playMode = $(this).attr('rel');
		$('#divPlayMode').hide('slow');
	});
	*/
	$('#playMode0').bind('click', function(){
		playMode = 1;
		$(this).hide();
		$('#playMode'+playMode).show();
	});
	$('#playMode1').bind('click', function(){
		playMode = 2;
		$(this).hide();
		$('#playMode'+playMode).show();
	});
	$('#playMode2').bind('click', function(){
		playMode = 0;
		$(this).hide();
		$('#playMode'+playMode).show();
	});
	/*
	$('#btnCate').bind('click', function(){
		if($('#divCate').css('display')=='none')
		{	
			$('#divPlayMode').hide();
			$('#divCate').show();
		}
		else
			$('#divCate').hide();
	});
	*/
	//bind share button	
	$('#share_button').bind('click', function(){
		if(currentPlayItemVid==null)
			return;
		fbs_click();
	});
	
}
function fbs_click() 
{
	if(currentPlayItemVid==null)
		return;
	var playingItem = $('div[vid='+currentPlayItemVid+']');
	u=playingItem.attr('surl');
	t="The Video is shared via Gageea TV";
	var thumb = playingItem.children('img').attr('src');
	var imgURL = thumb;
	if(thumb.indexOf("url=")!=-1)
		imgURL = thumb.substring(thumb.indexOf("url=")+4);
	else
		imgURL = window.location.protocol + "//" + window.location.host + window.location.pathname.substring(0, window.location.pathname.lastIndexOf("/")) + "/" + imgURL;
//alert(imgURL);
	if(imgURL.indexOf("&")!=-1)
		imgURL = imgURL.substring(0, imgURL.indexOf("&"));
	FB.ui(
	{
		method: 'feed',
		name: t,
		link: u,
		picture: unescape(imgURL),
		caption: playingItem.attr('video_title'),
		description: playingItem.attr('desc'),
		message: ''
	});
	return false;
}
$(document).ready(function(e)
{
	bindEvent();
	//
	loadData('mG');
//
});
</script>
<!-- share message : The video is shared via Gageea TV -->
<body style="padding:0px;margin:0px auto;text-align:center; background-color:black" onload='document.getElementById("listAreaFrame").focus()'>
<div id="loading" class="showLoading">Loading...</div>
<!-- share -->
<div id="share" class='menu_box' style="top:0px;right:3px;cursor:hand">
	<img src="images/btn_share.png" title="Share" id="share_button"/>
</div>
<!-- /share -->
<div id="fb-root"></div>
<script>
  window.fbAsyncInit = function() {
    FB.init({
      appId      : '368607346499484', // App ID
      status     : true, // check login status
      cookie     : true, // enable cookies to allow the server to access the session
      xfbml      : true  // parse XFBML
    });
	fbInitialized();
    // Additional initialization code here
  };
function fbInitialized()
{
}
  // Load the SDK Asynchronously
  (function(d){
     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
     if (d.getElementById(id)) {return;}
     js = d.createElement('script'); js.id = id; js.async = true;
     js.src = "//connect.facebook.net/en_US/all.js";
     ref.parentNode.insertBefore(js, ref);
   }(document));
</script>
<div id="toolbar" style="width:350px; display:block">
	<div class="panel" style="width:450px">
		<a href="#"  title="toolbar" style="width:25px"/>
		<ul>
			<li style="width:100px; float:left;"><a href="#" id="mM"><span style="color:white">Me</span></a></li>
			<li style="width:100px; float:left;"><a href="#" id="mP"><span style="color:white">Network</span></a></li>
			<li style="width:100px; float:left;"><a href="#" id="mR"><span style="color:white">Regional</span></a></li>
			<li style="width:100px; float:left;"><a href="#" id="mG"><span style="color:white">Global</span></a></li>
		</ul>
	</div>
	<div id='spanPlaying' style="color:orange; width:800px;"></div>
</div>
<div style="clear:both; padding-top:4px;"/>
<!-- play area-->
<table border=0 id='tbPlayer' align=center style="z-index:100">
	<tr>
		<td>
			<div style="overflow:auto;z-index:300;position:absolute;top:25px;left:5px;text-align:left;color:white;border-color:gray;border-style:ridge;" id="divCate">
			</div>
		</td>
		<td>
			<div id="myytplayer">
			</div>
		</td>
		<td>
			<div id="divControl" style="overflow:auto;z-index:300;position:absolute;top:25px;right:0px;text-align:right;height:80%;width:33px">
				<img src="images/fullscreen.png" width=30 height=30 id="btnFull" style="cursor:hand;display:none;position:relative;top:0px;float:right">
				<img src="images/restore.png" width=30 height=30 id="btnRestore" style="cursor:hand;display:none;position:relative;top:0px;float:right">
				<img src="images/playOnce.png" width=30 height=30 id="playMode0" style="cursor:hand;position:relative;top:5px;float:right"/>
				<img src="images/repeat.png" width=30 height=30 id="playMode1" style="cursor:hand;display:none;float:right;position:relative;top:5px"/>
				<img src="images/playAll.png" width=30 height=30 id="playMode2" style="cursor:hand;display:none;float:right;position:relative;top:5px"/>
			</div>
		</td>
	</tr>
</table>
<!-- /play area-->
<div style="clear:both"/>
<!-- list -->
<div id="listAreaFrame" class="listAreaFrame" onblur="document.getElementById('listAreaFrame').focus()">
	<div id="selectedItemTitle" align="center" style="height:24px;color:white;"></div>
	<div id='pre' style='z-index:100;width:20px; height:100px;left:0;margin-top:3px;cursor:hand;bottom:0px;position:absolute;'><img src='images/pre.png' width=20 style='padding-top:60px'/></div>
<!--	<div id="selectedItem" class="selectedItem"></div>-->
	<div id="listArea" style="background-color:block;border-color:black">
	</div>
	<div id='next' style='z-index:100;width:20px; height:100px;right:0;margin-top:3px;cursor:hand;bottom:0px;position:absolute;'><img src='images/next.png' width=20 style='padding-top:60px'/></div>
</div>
<!--
<div style="clear:both"/>
<div style="position:absolute;width:100%;bottom:0px;z-index:500;">
<div id="showListBtn" align="center" style="bottom:0px;cursor:hand;display:none"><img src="images/up.png" height=16/></div>
-->
<!-- /list -->
<!-- menu -->
<!--
<div id="menu" class='menu_box' style="bottom:0px;right:5px">
<img src='images/playMode.png' style="height:16px;bottom:0px;cursor:hand;" id="btnPlayMode"/>
</div>
-->
<!--
<div style="z-index:600;height:45;position:absolute;bottom:18px;right:8px;display:none;text-align:left;color:white;background-color:gray;border-color:gray;border-style:ridge;" id="divPlayMode">
	<div id="playMode0" rel=0 style="cursor:hand;background-color:black">Once</div>
	<div id="playMode1" rel=1 style="cursor:hand">Repeat</div>
	<div id="playMode2" rel=2 style="cursor:hand">Continuous</div>
</div>
-->
<!--
<div style="overflow:auto;z-index:300;width:160px;height:200px;position:absolute;bottom:20px;right:5px;display:none;text-align:left;color:white;background-color:gray;border-color:gray;border-style:ridge;" id="divCate">
</div>
-->
<!-- /menu -->
<div id="dialog" style='z-index:100;display:none'><iframe name="dialogFrame"></iframe></div>
</body>
</html>