<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
	<title>Video</title>
	<style type="text/css">
	<!--
	-->
	</style>
	<link rel="stylesheet" type="text/css" media="screen" href="" />		
</head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
function toTimestamp(strDate){
 var datum = Date.parse(strDate);
 return datum/1000;
}
function loadVideoData2()
{
	$.ajax(
	{
		url: '/demo/servlets/LoadVideo',
		data: {column:$("#orderColumnSL").val(), order:$("#orderSL").val(), offset:$('#offset').val(), timestamp:toTimestamp($('#timestamp').val()), type:"1", token:"AAAAAJgXcONwBAIubfeta2ZCU9etoCOetpnajtVCYJ0OmncSWZAj9y3SBILfEnAGg1bVyKHZAaos9jvgAu8OjhnHUiNhxWY4yBj1YtZBQ0AZDZD", ip:"61.63.48.225"},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			/*
			$("#" + orderColumn).attr("sort", order);
			$("#sortColumn").attr("sortCol", orderColumn);
			$("#sortColumn").text($("#" + orderColumn).text() + " " + order);
			var totalPage = response.totalPage;
			//
			var ary = [];
			for(var i=1;i<=totalPage;i++)
			{
				ary[ary.length] = "<option value='"+i+"'>"+i+"</option>";
			}
			$("#pagingDL").empty();
			$("#pagingDL").append(ary.join(''));
			//
			var total = response.total;
			var offset = response.offset;
			$("#pagingDL").val(offsetToPage(offset));
			*/
			$("#pagingDL").hide();
			$("#sortColumn").hide();
			var ary = [];
			for(var i=0;i<response.video.length;i++)
			{
				var id = "v_" + i;
				ary[ary.length] = "<tr>" + 
								"<td><img src='"+response.video[i].thumb+"' width=80 height=60/></td>"+
								"<td ><a href='"+response.video[i].source_url+"' id='"+i+"' target='_blank'>"+response.video[i].title+"</a><br>["+response.video[i].category+"]</td>"+
								"<td align='center'>"+response.video[i].streamCount+"</td>"+
								"<td align='center'>"+response.video[i].lastPostTime+"</td>"+
								"<td align='center'>"+response.video[i].firstPostTime+"</td>"+	
								"<td align='left'><span id='si_"+response.video[i].id+"'>Loading...</span></td>" + 		
								"</tr>";
				
			}
			$("#data").empty();
			$("#data").append(ary.join(''));
			//
			$("span[id^=si_]").each(function(){
				var vid = this.id.substring(3);
				loadStream(vid);
			});
		},
		complete: function(xhr, status){
		}
	});	
}
function loadVideoData(orderColumn, keepSortType)
{
	$("#pagingDL").show();
	$("#sortColumn").show();
	var order  = $("#" + orderColumn).attr("sort");
	if(keepSortType==undefined)
	{
		if(order=="asc")
			order = "desc";
		else
			order = "asc";
	}
	var page = $("#pagingDL").val()==null?1:$("#pagingDL").val();
	var offset = pageToOffset(page);
	$.ajax(
	{
		url: '/demo/servlets/LoadVideo',
		data: {column:orderColumn, order:order, offset:offset},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			//alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			$("#" + orderColumn).attr("sort", order);
			$("#sortColumn").attr("sortCol", orderColumn);
			$("#sortColumn").text($("#" + orderColumn).text() + " " + order);
			var totalPage = response.totalPage;
			//
			var ary = [];
			for(var i=1;i<=totalPage;i++)
			{
				ary[ary.length] = "<option value='"+i+"'>"+i+"</option>";
			}
			$("#pagingDL").empty();
			$("#pagingDL").append(ary.join(''));
			//
			var total = response.total;
			var offset = response.offset;
			$("#pagingDL").val(offsetToPage(offset));
			var ary = [];
			for(var i=0;i<response.video.length;i++)
			{
				var id = "v_" + i;
				ary[ary.length] = "<tr>" + 
								"<td><img src='"+response.video[i].thumb+"' width=80 height=60/></td>"+
								"<td ><a href='"+response.video[i].source_url+"' id='"+i+"' target='_blank'>"+response.video[i].title+"</a><br>["+response.video[i].category+"] duration:"+response.video[i].duration+"(s)</td>"+
								"<td align='center'>"+response.video[i].streamCount+"</td>"+
								"<td align='center'>"+response.video[i].lastPostTime+"</td>"+
								"<td align='center'>"+response.video[i].firstPostTime+"</td>"+	
								"<td align='left'><span id='si_"+response.video[i].id+"'>Loading...</span></td>" + 		
								"</tr>";
				
			}
			$("#data").empty();
			$("#data").append(ary.join(''));
			//
			$("span[id^=si_]").each(function(){
				var vid = this.id.substring(3);
				loadStream(vid);
			});
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
		url: '/demo/servlets/LoadStream',
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
function offsetToPage(offset)
{
	var pagingSize = 50;
	var page = (offset / pagingSize) + 1;
	return page;
}
function pageToOffset(page)
{
	var pagingSize = 50;
	var offset = ( page - 1 ) * pagingSize;	
	return offset;
}
function goPage(el)
{
	var offset = pageToOffset($(el).val());
	var sortColumn = $("#sortColumn").attr("sortCol");
	var sortType = $("#" + sortColumn).attr("sort");
	loadVideoData(sortColumn, true);
}
function bindEvent()
{
	var pageVal = $("#pagingDL").val()==null?1:$("#pagingDL").val();
	$("#header span").each(function(){
		var attr = $(this).attr("id");
		if((typeof(attr) != 'undefined') && attr != false)
		{
			$(this).bind("click", function(){
				loadVideoData(this.id);
			});
			this.style.cursor = "hand";
		}
	});
}
$(document).ready(function(e)
{
	bindEvent();
});
</script>
<body onload="javascript:loadVideoData('streamCount');">
<select id="orderColumnSL">
	<option value="title">title</option>
	<option value="streamCount">streamCount</option>
	<option value="max_created_time">max_created_time</option>
	<option value="min_created_time">min_created_time</option>
</select>
<select id="orderSL">
	<option value="asc">asc</option>
	<option value="desc">desc</option>
</select>
<input type="text" id="offset" value="30"/>
<input type="text" id="timestamp" value="03/28/2011"/>
<input type="button" id="btn" value="Get" onclick="loadVideoData2();"/>
<table border=1>
	<tr>
		<td align="left">
			Page:<select id="pagingDL" onclick="javascript:goPage(this);"></select>&nbsp;&nbsp;
			Order by:<span id="sortColumn" sortCol="title">Title</span>
		</td>
	</tr>
	<tr>
		<td>
		<table border=1>
			<thead>
				<tr id="header">
					<td><span>Thumbnail</span></td>
					<td><span id="title" sort="desc">Title</span></td>
					<td><span id="streamCount" sort="asc">Stream Count</span></td>
					<td><span id="max_created_time" sort="asc">Latest Post Time</span></td>
					<td><span id="min_created_time" sort="desc">First Post Time</span></td>
					<td><span>Stream Info.</span></td>
				</tr>
			</thead>
			<tbody id="data">
			</tbody>
		</table>
		</td>
	</tr>
</table>
</body>
</html>