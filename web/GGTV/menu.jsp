<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri = "http://java.sun.com/jstl/core" prefix="c"%>
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
	<link rel="stylesheet" type="text/css" media="screen" href="" />		
</head>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
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
	window.parent.main.loadVideo(type, "");
	loadCategory(type);
}
function loadCategory(type)
{
	$.ajax(
	{
		url: '../../servlets/LoadCategory',
		data: {type:type, token:window.parent.getToken()},
		type:'POST',
		dataType:'json',
		error: function(xhr, status, e) {
			alert('xhr: '+xhr.responseText+'\nstatus: '+status+'\ne: '+e);
		},
		success: function(response)
		{
			var ary = new Array();
			ary[ary.length] = "<option value=''>All</option>";
			for(var i=0;i<response.category.length;i++)
			{
				var cate = response.category[i].category;
				ary[ary.length]="<option value='"+cate+"'>"+cate+"</option>";
			}
			var e = window.parent.headline.document.getElementById("cateList");
			$(e).empty();
			$(e).append(ary.join(''));
			$(e).bind('change', function(){
				window.parent.main.loadVideo(type, $(e).val());
			});
		},
		complete: function(xhr, status){
		}
	});
}
function toTimestamp(strDate){
 var datum = Date.parse(strDate);
 return datum/1000;
}
$(document).ready(function(e)
{
	$('td[id^=m]').each(function(){
		$(this).bind('click', function(){
			$('td[id^=m] span').removeClass('itemSelected');
			$(this).children('span').addClass('itemSelected');
			loadData(this.id);
		});
	});
	//
	setTimeout(function(){$('#mG').click();}, 500);
});

</script>
<body>
<center>
	<table border="0" cellspacing="0" cellpadding="0" height="100%" style="margin:3px 5px 3px 5px">
		<tr>
			<td id="mP" align="center" valign="middle" style="cursor:hand" width="100px" height="80px" onmouseover="style.backgroundColor='#C0C0C0'" onmouseout="style.backgroundColor='white'"><img src="images/friend.png" width="50" height="50"/><span style="height:50px"><u>Personal</u></span></td>
			<td id="mR" align="center" valign="middle" style="cursor:hand" width="100px" height="80px" onmouseover="style.backgroundColor='#C0C0C0'" onmouseout="style.backgroundColor='white'"><img src="images/map.png" width="50" height="50"/><span><u>Regional</u></span></td>
			<td id="mG" align="center" valign="middle" style="cursor:hand" width="80px" height="80px" onmouseover="style.backgroundColor='#C0C0C0'" onmouseout="style.backgroundColor='white'"><img src="images/global.png" width="50" height="50"/><span><u>Global</u></span></td>
			<!--
			<td id="mS" align="center" valign="middle">Search</td>
			<td id="mL" align="center" valign="middle">Sign on</td>
			-->
		</tr>
	</table>
</body>
</html>