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
	-->
	</style>
    <link rel="stylesheet" type="text/css" href="fb.css" />
    <script src="http://static.ak.fbcdn.net/connect.php/js/FB.Share" type="text/javascript"></script>
</head>
<script type="text/javascript" src="date_fmt.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
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
			var ary = [];
			for(var i=0;i<response.video.length;i++)
			{
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
           
				ary[ary.length]  = "" + 
                   "<DIV id='contentArea' role='main'><DIV id='pagelet_home_stream' data-referrer='pagelet_home_stream' data-gt=\"{'ref':'nf'}\"><DIV class='UIIntentionalStream UIStream'><UL class='uiList uiStream uiStreamHomepage translateParent UIIntentionalStream_Content' id='home_stream' style='MIN-HEIGHT: 100px' data-referrer='home_stream'><LI class='uiUnifiedStory uiStreamStory genericStreamStory uiStreamBoulderHighlight aid_1221610072 uiListItem uiListLight uiListVerticalItemBorder' id='stream_story_vid' data-ft=\"{'qid':'5705579117614779541','mf_story_key':'','c':'m'}\"><DIV class='storyContent'><DIV class='UIImageBlock clearfix'><DIV class='storyInnerContent UIImageBlock_Content UIImageBlock_MED_Content'>" + 
                   "<DIV class='mainWrapper'>" + 
                   "<H6 class='uiStreamMessage uiStreamHeadline'>" + 
                   "</H6>" + 
                   "<H6 class='uiStreamMessage' data-ft=\"{'type':1}\">" + 
                   "<SPAN class='messageBody' data-ft=\"{'type':3}\"><A href='"+response.video[i].source_url+"' target='_blank' rel='nofollow nofollow'><SPAN>http://www.youtube.com/</SPAN><WBR></WBR><SPAN class='word_break'></SPAN>watch?v="+response.video[i].key+"</A></SPAN>" + 
                   "</H6>" + 
                   "<DIV class='mvm uiStreamAttachments clearfix fbMainStreamAttachment' data-ft=\"{'type':10}\">" + 
                   "<DIV class='UIImageBlock clearfix'>" + 
                   "<A class='uiVideoThumb UIImageBlock_Image UIImageBlock_MED_Image' id='thumb_"+response.video[i].key+"' onclick=\"CSS.addClass(this, 'uiVideoThumbLoading');return false;\" href='#' rel='async' aria-hidden='true' data-ft=\"{'type':42,'video_type':'share'}\" key='"+response.video[i].key+"'><IMG class='img' style='CLEAR: none; WIDTH: 130px' alt='' src='"+response.video[i].thumb+"'/><I></I></A>" + 
                   "<DIV class='UIImageBlock_Content UIImageBlock_MED_Content fsm fwn fcg'>" + 
                   "<DIV class='uiAttachmentTitle' data-ft=\"{'type':11}\">" + 
                   "<STRONG><A onmousedown=\"UntrustedLink.bootstrap($(this), 'HAQFHMLrEAQEM-W_F8BCfBPe6-wULZ1qRzz_9-hoBR_iTqQ', event, bagof(null));\" href='http://www.youtube.com/watch?v="+response.video[i].key+"' target='_blank' rel='nofollow'>"+response.video[i].title+"</A></STRONG>" + 
                   "</DIV>" + 
                   "<SPAN class='caption'><A onmousedown=\"UntrustedLink.bootstrap($(this), '1AQHopwgvAQH6fONQa3kzVE4mKmPjNVgDPwNJ_Y5OzhT__g', event, bagof(null));\" href='http://www.youtube.com/' target='_blank' rel='nofollow nofollow'>www.youtube.com</A></SPAN>" + 
                   "<DIV class='mts uiAttachmentDesc translationEligibleUserAttachmentMessage' id='desc_"+response.video[i].key+"'>" + response.video[i].description + 
                   "</DIV>" + 
                   "</DIV>" + 
                   "</DIV>" + 
                   "</DIV>" + 
                   "<DIV class='clearfix uiImageBlock uiStreamFooter'>" + 
                   "<I class='uiImageBlockImage uiImageBlockSmallImage lfloat img sp_7h2yks sx_5f9f3c'></I>" + 
                   "<a name='fb_share' type='icon_link' " + 
                   "href='http://www.facebook.com/sharer.php?u="+encodeURIComponent(response.video[i].share_url)+"&t=' target='_blank'>Share</a>" + 
                    /*
                        TOTO: gen share fun
                     */
                    "</DIV>" + 
                    "</DIV>" + 
                    "</DIV></DIV></DIV></LI></UL></DIV></DIV></DIV>";           
			}
			$("#data").empty();
			$("#data").append(ary.join(''));
			$("A[id^=thumb_]").bind('click', function(){
					$(this).parent().addClass("exploded");
					var vid = $(this).attr("key");
					var thumbUrl = $(this).attr('src');
					var playUrl = "https://www.youtube.com/v/"+vid+"?version=3&autohide=1&autoplay=1";
					var desc = $('#desc_' + vid).html();
					$(this).replaceWith('<div id="uqou4_'+vid+'" style="width:398px;height:224px" class=" swfObject" data-swfid="swf_uqou4_89">' + 
					'<iframe width="398" height="224" frameborder="0" src="refererFrame.jsp?vid='+vid+'"></iframe>'/* + 
					"<SPAN class='caption'><A onmousedown=\"UntrustedLink.bootstrap($(this), '1AQHopwgvAQH6fONQa3kzVE4mKmPjNVgDPwNJ_Y5OzhT__g', event, bagof(null));\" href='http://www.youtube.com/' target='_blank' rel='nofollow nofollow'>www.youtube.com</A></SPAN>" + 
                   "<DIV class='mts uiAttachmentDesc translationEligibleUserAttachmentMessage'>" + desc + 
                   "</DIV>"*/
					);
					$(this).attr("id", "flash_"+vid);
					$(this).attr("thumbUrl", thumbUrl);
					$(this).attr("playUrl", playUrl);
					//
					
			});
			/*
			$("span[id^=v_]").bind('click', function(){
				window.parent.ytplay.loadVideo($(this).attr("key"));
				window.parent.mainFrame.cols="0,*";
				window.parent.headline.showBackBtn();
			});
			*/
		},
		complete: function(xhr, status){
		}
	});
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
}
$(document).ready(function(e)
{
	//bindEvent();
	loadData('mG');
});
</script>
<body class="hasLeftCol home fbx hasSlimHeader win Locale_en_US">
<%@ include file="body_menu.jsp" %>
<%@ include file="body_sort.jsp" %>
<!--
<table border=0>
	<tr>
		<td>
		<table border=1>
			<tbody id="data">
			</tbody>
		</table>
		</td>
	</tr>
</table>
-->
<div id="data">
</div>
<%@ include file="body_more.jsp" %>
</body>
</html>