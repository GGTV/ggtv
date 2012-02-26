<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
        <meta property="og:title" content="title" />
        <meta property="og:description" content="description" />
        <meta property="og:image" content="thumbnail_image" />	<title>Video</title>
	<style type="text/css">
	<!--
	.normal {
		white-space: normal; /* default value */
		width: 160px;        /* specific width */
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
		width: 160px; 
		}
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
    var curType;
    var curCate;
function loadOlderPosts()
{
    curOffset -= 7;
    loadVideo(curType, curCate);
}
function getToken()
{
    var access_token = "<%=request.getParameter("access_token")%>";
    if(access_token == '')
        access_token = "AAAFPPxXzH5wBALgIXt3lQFcatEBwjqIi22oh0Yh1PJ17YgspJmQj02aEBmuaWxwdhbZAkp52BbYARIDXKapVLFhsed4cL8kZCNBrJnWyd7pTqscIY8";
	return access_token;
}

function loadData(mItemId)
{
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
	loadVideo(type, "");
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
			
			ary[ary.length] = "<LI class='uiMenuItem uiMenuItemRadio uiSelectorOption checked' data-label='SORT' rel=''>" + 
         		"<A class='itemAnchor' href='#' aria-checked='true'><SPAN class='itemLabel fsm'>All</SPAN></A>" + 
        		"</LI>";
			for(var i=0;i<response.category.length;i++)
			{
				var cate = response.category[i].category;
				//ary[ary.length]="<option value='"+cate+"'>"+cate+"</option>";
				ary[ary.length]="<LI class='uiMenuItem uiMenuItemRadio uiSelectorOption' data-label='SORT' rel='"+cate+"'>" + 
         		"<A class='itemAnchor' href='#' aria-checked='true'><SPAN class='itemLabel fsm'>"+cate+"</SPAN></A>" + 
        		"</LI>";
			}
			var e = $('UL[rel=category]');
			$(e).empty();
			$(e).append(ary.join(''));
			$(e).children().each(function(){
				$(this).bind('click', function(){
					hideCategory();
					$(e).children().removeClass("checked");
					loadVideo(type, $(this).attr("rel"));
					$(this).addClass("checked");
				});
			});
		},
		complete: function(xhr, status){
		}
	});
}
function loadVideo(type, cate)
{
    curType = type;
    curCate = cate;
//	alert(type + "," + cate);
//	loadCategory(type);
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
			var ary = [];
			for(var i=0;i<response.video.length;i++)
			{
				var item = response.video[i];
				ary[ary.length] = "<div id='item_"+item.key+"' vid='"+item.key+"' style='width=160px; float:left; border-style:double;cursor:hand'>" + 
									"<img src='"+ item.thumb+"' width=160 height=120/>" +
									"<div style='width=160px;'><pre class='wrapped'>"+ item.title +"</pre></div>" + 
								  "</div>";
                /*
				var duration = "";				
				if(response.video[i].duration!=null)
				{
					duration = formatDuration(response.video[i].duration);
				}
				
				var id = "v_" + i;
				var lastPostTime = response.video[i].lastPostTime.substr(0, 16);
				ary[ary.length] = "<tr>" + 
								"<td><img src='"+response.video[i].thumb+"' width=160 height=120/></td>"+
								"<td><table height=100% width=100%><tr>" + 
//								"<td height='80%' valign=top colspan=3><a href='"+response.video[i].source_url+"' id='"+i+"' target='_blank'>"+response.video[i].title+"</a></td>"+
								"<td height='80%' valign=top colspan=3><span style='cursor:hand' id='"+id+"' key='"+response.video[i].key+"'>"+response.video[i].title+"</span></td>"+								"</tr><tr>" + 
								"<td height='20%' align='left'><img src='images/share.png' width=16 height=16/>&nbsp;"+response.video[i].streamCount+"</td>"+
								"<td height='20%' align='left'><img src='images/duration.png' width=16 height=16/>&nbsp;"+duration+"</td>"+
								"<td height='20%' align='right'>"+lastPostTime+"</td>"+
								"</tr></table></td>" + 
								"</tr>";
                 */
           
			}
			$('#listArea').empty();
			$('#listArea').append(ary.join(''));
			$('div[id^=item_]').each(function(){
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
function playVideo(vid)
{
	var params = { allowScriptAccess: "always"};
	var atts = { id: "myytplayer" };
	var flashvars = {};
	swfobject.embedSWF("http://www.youtube.com/v/"+vid+"?enablejsapi=1&playerapiid=ytplayer&version=3",
					"myytplayer", "65%", "65%", "8", null, flashvars, params, atts);
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
	if(currentPlayItem != null)
	{
		var nextVid = $('#item_' + currentPlayItem).next().attr('vid');
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
		});
	});
	//
//	setTimeout(function(){$('#mG').click();}, 500);

}
$(document).ready(function(e)
{
	bindEvent();
	loadData('mG');
});
</script>
<body>
<div id="toolbar" style="width:350px; display:block">
	<div class="panel" style="width:350px">
		<a href="#"  title="toolbar" style="width:25px"/>
		<ul>
			<li style="width:100px; float:left"><a href="#" id="mP"><span>Personal</span></a></li>
			<li style="width:100px; float:left"><a href="#" id="mR"><span>Regional</span></a></li>
			<li style="width:100px; float:left"><a href="#" id="mG"><span>Global</span></a></li>
		</ul>
	</div>
</div>
<!-- play area-->
<div id="myytplayer">
</div>
<!-- /play area-->
<div style="clear:both"/>
<!-- list -->
<div id="listArea" style="position:absolute;width:100%;height=100px; left: 0px; bottom: 10px;">
<!--
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
	<div style="width=200px; float:left">
		<img src="" width=160 height=120/>
		<div>title........</div>
	</div>
-->	
</div>
<!-- /list -->
</body>
</html>