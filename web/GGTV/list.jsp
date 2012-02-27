<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
        <meta property="og:title" content="title" />
        <meta property="og:description" content="description" />
        <meta property="og:image" content="thumbnail_image" />	<title>Video</title>
	<style type="text/css">
	<!--
	.menu_box{
		position:absolute;
		float:right;
		right:0px;
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
	-->
	</style>
    <link rel="stylesheet" type="text/css" href="fb.css" />
</head>
<script type="text/javascript" src="swfobject.js"></script>    
<script type="text/javascript" src="date_fmt.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
<%@ include file="ytscript.jsp" %>
var currentPlayItem = null;
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
    var curOffset = -7;
    var curIndex = 0;
    var curType;
    var curCate = "";
function loadOlderPosts()
{
    curIndex += 1;
    loadVideo(curType, curCate);
}
function loadCachedPosts(offset)
{
	var response = cachedVideoData;
	var ary = [];
	curIndex += offset;
	var idx = curIndex;
//	if(response.video.length>0 && idx>0)
		ary[ary.length] = "<div id='pre' style='width:20px; float:left;padding-top:70px;cursor:hand'><img src='images/pre.png' width=20/></div>";
	var screenWidth = document.documentElement.clientWidth;
	var w = (screenWidth - 20 - 20 - 50)/7;
	for(var i=idx;i<response.video.length && i<idx+7;i++)
	{
		var item = response.video[i];
		ary[ary.length] = "<div id='item_"+item.key+"' vid='"+item.key+"' style='width:"+w+"px; float:left; border-style:double;cursor:hand'>" + 
							"<img src='"+ item.thumb+"' width=120 height=100/>" +
							"<div style='width=160px;'><pre class='truncated'>"+ item.title +"</pre></div>" + 
						  "</div>";
	}
	ary[ary.length] = "<div id='more' style='width:20px; float:left;padding-top:70px;cursor:hand'><img src='images/next.png' width=20/></div>";
	$('#listArea').empty();
	$('#listArea').append('<table border=0 width=100% id=tbList><tr><td align=center width=100%>'+ary.join('')+'</td></tr></table>');
	$('div[id^=item_]').each(function(){
		$(this).bind('click', function(){
			var vid = $(this).attr("vid");
			playVideo(vid);
		});
	});
	$('#more').bind('click', function(){
		loadOlderPosts();
	});
	$('#pre').bind('click', function(){
		if(curIndex>0)
			loadCachedPosts(-1);
	});
	if(fAutoPlayNext)
		playNextVideo();
}
function getToken()
{
    var access_token = "<%=request.getParameter("access_token")%>";
//    alert('<%=request.getParameter("user_id")%>');
    if(access_token == '')
        access_token = "AAAFPPxXzH5wBAJ9TQ7ZCiRniH9nZB6I9MKG2NmTSWfcagi1UU6iXkX5ziVb3xR6zDoRPzo2ZBGOnlJCCsV3sEnrZAR4Nx8zZC5gZCyaYnrdF5LRyY181Rg";
	return access_token;
}

function loadData(mItemId)
{
	curOffset = -7;
	var type = -1;
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
	loadVideo(type, curCate);
	$('a[id^=m]').removeClass("underline");
	$('#'+mItemId).addClass("underline");
//	loadCategory(type);
}
function loadCategory(type)
{
	$.ajax(
	{
		url: '../../servlets/LoadCategory',
		//data: {type:type, token:window.parent.getToken()},
		data: {type:type, token:getToken()},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			var ary = new Array();
			
			$('#divCate').empty();
			ary[ary.length] = "<option value=''>All</option>";
			for(var i=0;i<response.category.length;i++)
			{
				var item = response.category[i];
				ary[ary.length] = "<option vaue='"+item.category+"'>" + item.category + "</option>";
			}
			$('#divCate').append(ary.join(''));
			$('#divCate').bind('change', function(){
				loadVideo(type, $(this).val());
				$('#btnCate').val($(this).val());
				//
				$('#btnHide').click();
			});
			if($('#btnCate').val()=='Category')
				$('#btnCate').val($('#divCate option[value=""]').text());
			else
				$('#divCate').val($('#btnCate').val());
		},
		complete: function(xhr, status){
		}
	});
}
var cachedVideoData;
var playMode = 0;
var fAutoPlayNext = false;
function loadVideo(type, cate)
{
	if((Math.abs(curOffset)-curIndex)<7)
	{
		curOffset-=7;
	}
	if((Math.abs(curOffset)-curIndex)<14 || curIndex==0)
	{
		curType = type;
		curCate = cate;
	//	alert(type + "," + cate);
		loadCategory(type);
		var params = {column:'max_created_time', order:'desc', offset:curOffset, timestamp:toTimestamp(new Date()), type:type};
		if(cate!='')
			params = $.extend(params, {cate:cate});
		if(type==2)
			//params = $.extend(params, {token:window.parent.getToken()});
			params = $.extend(params, {token:getToken()});
		$.ajax(
		{
			url:'../../servlets/LoadVideo',
			data:params,
			type:'POST',
			dataType:'json',
			error:function(xhr, status, e) {
				alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
			},
			success: function(response)
			{
				cachedVideoData = response;
				loadCachedPosts(0);
			},
			complete: function(xhr, status){
			}
		});
	}
	else
	{
		loadCachedPosts(0);
	}
}
function playVideo(vid)
{
	var params = { allowScriptAccess: "always",  allowfullscreen:"true"};
	var atts = { id: "myytplayer" };
	var flashvars = {};
	swfobject.embedSWF("http://www.youtube.com/v/"+vid+"?enablejsapi=1&playerapiid=ytplayer&version=3",
					"myytplayer", "70%", "70%", "8", null, flashvars, params, atts);
	currentPlayItem = vid;
}
function playAgain()
{
	if(currentPlayItem != null)
	{
		playVideo(currentPlayItem);
	}	
}
function playNextVideo()
{
	fAutoPlayNext = false;
	if(currentPlayItem != null)
	{
		var nextVid = $('#item_' + currentPlayItem).next().attr('vid');
		if(nextVid==undefined)
		{
			loadOlderPosts();
			fAutoPlayNext = true;
		}
		else
			playVideo(nextVid);
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
			alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
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
function pageToOffset(page)
{
	var pagingSize = 50;
	var offset = ( page - 1 ) * pagingSize;	
	return offset;
}
function bindEvent()
{
	$('a[id^=m]').each(function(){
		$(this).bind('click', function(){
			$('a[id^=m] span').removeClass('itemSelected');
			$(this).children('span').addClass('itemSelected');
			loadData(this.id);
			return false;
		});
	});
	//
	$('#menu').bind('click', function(){
		$('#buttonsDiv').show();
		$('#menu').hide('slow');
	});
	$('#btnHide').bind('click', function(){
		$('#buttonsDiv').hide('fast');
		$('[id^=div]').hide('slow');
		$('#menu').show();
	});
	$(".buttons").click(function () {
	var divname= 'div' + this.id.substring(3);
	  $("#"+divname).show("slow").siblings('[id^=div]').hide("slow");
	});
	//
	$('#divPlayMode').bind('change', function(){
		$('#btnPlayMode').val($('#divPlayMode option[value='+$(this).val()+']').text());
		playMode = $(this).val();
		//
		$('#btnHide').click();
	});
}
$(document).ready(function(e)
{
	bindEvent();
	loadData('mG');
//
});
</script>
<body style="padding:0px;margin:0px auto;text-align:center; background-color:black">
<div id="toolbar" style="width:350px; display:block">
	<div class="panel" style="width:350px">
		<a href="#"  title="toolbar" style="width:25px"/>
		<ul>
			<li style="width:100px; float:left;"><a href="#" id="mP"><span style="color:white">Personal</span></a></li>
			<li style="width:100px; float:left;"><a href="#" id="mR"><span style="color:white">Regional</span></a></li>
			<li style="width:100px; float:left;"><a href="#" id="mG"><span style="color:white">Global</span></a></li>
		</ul>
	</div>
</div>
<div style="clear:both; padding-top:4px;"/>
<!-- play area-->
<div id="myytplayer">
</div>
<!-- /play area-->
<div style="clear:both"/>
<!-- list -->
<div id="listArea" style="overflow:auto;position:absolute;height=80px; bottom: 0px;margin:0 auto; background-color:black;left:0px;right:0px">
<!--
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
-->	
</div>
<!-- /list -->
<!-- menu -->
<div id="menu" class='menu_box' style="bottom:0px;">
<input type="button" value="Config"></input>
</div>
<span id="buttonsDiv" class='menu_box' style="display:none;bottom:0px"> 
<input type="button" id="btnHide" value="Hide"></input>
<input type="button" id="btnPlayMode" class="buttons" value="Once"></input>
<input type="button" id="btnCate" class="buttons" value="Category"></input>
<input type="button" id="btnSort" class="buttons" value="Sort"></input>

</span>
<div style='clear:both'/>
<select id='divPlayMode' class='menu_box bottom' style="display:none;">
	<option value="0">Once</option>
	<option value="1">Repeat</option>
	<option value="2">Continuous</option>
</select>

<select id="divCate" class='menu_box bottom' style="display:none">
</select>

<div id="divSort" class='menu_box bottom' style="display:none">
Sort..
</div>
</div>
<!-- /menu -->
</body>
</html>