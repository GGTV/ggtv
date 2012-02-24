<script>
var fSortMenuShow = false;
function showSortMenu()
{
	hideCategory();
	hidePlayMode();
    $('div[rel=toggleParent]').addClass("openToggler");
    fSortMenuShow = true;
    $('a[rel=toggle]').get(0).onclick=function(){hideSortMenu();return false;};
}
function hideSortMenu()
{
    $('div[rel=toggleParent]').removeClass("openToggler");
    fSortMenuShow = false;
    $('a[rel=toggle]').get(0).onclick=function(){showSortMenu();return false;};
}
function showCategory()
{
	hideSortMenu();
	hidePlayMode();
	$('div[rel=toggleParent2]').addClass("openToggler");
	$('a[rel=toggle2]').get(0).onclick=function(){hideCategory();return false;};
}
function hideCategory()
{
	$('div[rel=toggleParent2]').removeClass("openToggler");
	$('a[rel=toggle2]').get(0).onclick=function(){showCategory();return false;};
}
function showPlayMode()
{
	hideSortMenu();
	hideCategory();
	$('div[rel=toggleParent3]').addClass("openToggler");
	$('a[rel=toggle3]').get(0).onclick=function(){hidePlayMode();return false;};
}
function hidePlayMode()
{
	$('div[rel=toggleParent3]').removeClass("openToggler");
	$('a[rel=toggle3]').get(0).onclick=function(){showPlayMode();return false;};
}

</script>
<!-- Header (Sort) -->
<DIV id="contentArea" role="main"><DIV id="pagelet_home_stream" data-referrer="pagelet_home_stream" data-gt='{"ref":"nf"}'>
    <UL class="uiStream" id="boulder_fixed_header">
        <LI class="mts uiStreamHeader">
 <!-- Show / hide Play mode-->
 <DIV class="uiStreamHeaderChronologicalForm3">
   <DIV class="uiSelector inlineBlock uiSelectorRight uiSelectorNormal uiSelectorDynamicLabel">
    <DIV class="wrap" rel="toggleParent3"><BUTTON class="hideToggler"></BUTTON>
     <A class="uiSelectorButton uiButton" href="" rel="toggle3" aria-haspopup="1" role="button" data-length="30" onclick="javascript:showPlayMode();return false;"><SPAN class="uiButtonText">PLAY MODE</SPAN></A>
     <DIV class="uiSelectorMenuWrapper uiToggleFlyout">
      <DIV class="uiMenu uiSelectorMenu" role="menu">
       <UL class="uiMenuInner">
        <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption checked" data-label="SORT">
         <A class="itemAnchor" href="http://www.facebook.com/?sk=h_nor" role="menuitemradio" aria-checked="true"><SPAN class="itemLabel fsm">Once</SPAN></A>
        </LI>
        <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption" data-label="SORT: TITLE">
         <A class="itemAnchor" href="http://www.facebook.com/?sk=h_chr" role="menuitemradio" aria-checked="false"><SPAN class="itemLabel fsm">Repeat</SPAN></A>
        </LI>
        <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption" data-label="SORT: TITLE">
         <A class="itemAnchor" href="http://www.facebook.com/?sk=h_chr" role="menuitemradio" aria-checked="false"><SPAN class="itemLabel fsm">Continuous</SPAN></A>
        </LI>
       </UL>
      </DIV>
     </DIV>
    </DIV>
   </DIV>
  </DIV>
 <!-- /Show / hide play mode-->
 <!-- Show / hide Category-->
 <DIV class="uiStreamHeaderChronologicalForm2">
   <DIV class="uiSelector inlineBlock uiSelectorRight uiSelectorNormal uiSelectorDynamicLabel">
    <DIV class="wrap" rel="toggleParent2"><BUTTON class="hideToggler"></BUTTON>
     <A class="uiSelectorButton uiButton" href="" rel="toggle2" aria-haspopup="1" role="button" data-length="30" onclick="javascript:showCategory();return false;"><SPAN class="uiButtonText">CATEGORY</SPAN></A>
     <DIV class="uiSelectorMenuWrapper uiToggleFlyout">
      <DIV class="uiMenu uiSelectorMenu" role="menu">
       <UL class="uiMenuInner" rel="category">
        <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption checked" data-label="SORT">
         <A class="itemAnchor" href="http://www.facebook.com/?sk=h_nor" role="menuitemradio" aria-checked="true"><SPAN class="itemLabel fsm">Most Recent</SPAN></A>
        </LI>
        <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption" data-label="SORT: TITLE">
         <A class="itemAnchor" href="http://www.facebook.com/?sk=h_chr" role="menuitemradio" aria-checked="false"><SPAN class="itemLabel fsm">Video Title</SPAN></A>
        </LI>
       </UL>
      </DIV>
     </DIV>
    </DIV>
   </DIV>
  </DIV>
 <!-- /Show / hide Category-->
 <DIV class="uiStreamHeaderChronologicalForm">
                <DIV class="uiSelector inlineBlock uiSelectorRight uiSelectorNormal uiSelectorDynamicLabel">
                    <DIV class="wrap" rel="toggleParent"><BUTTON class="hideToggler"></BUTTON>
                        <A class="uiSelectorButton uiButton" href="" rel="toggle" aria-haspopup="1" role="button" data-length="30" onclick="javascript:showSortMenu();return false;"><SPAN class="uiButtonText">SORT</SPAN></A>
                        <DIV class="uiSelectorMenuWrapper uiToggleFlyout">
                            <DIV class="uiMenu uiSelectorMenu" role="menu">
                                <UL class="uiMenuInner">
                                    <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption checked" data-label="SORT">
                                        <A class="itemAnchor" href="http://www.facebook.com/?sk=h_nor" role="menuitemradio" aria-checked="true"><SPAN class="itemLabel fsm">Most Recent</SPAN></A>
                                    </LI>
                                    <LI class="uiMenuItem uiMenuItemRadio uiSelectorOption" data-label="SORT: TITLE">
                                        <A class="itemAnchor" href="http://www.facebook.com/?sk=h_chr" role="menuitemradio" aria-checked="false"><SPAN class="itemLabel fsm">Video Title</SPAN></A>
                                    </LI>
                                </UL>
                            </DIV>
                        </DIV>
                    </DIV>
                </DIV>
            </DIV>
        </LI>
    </UL>
</DIV></DIV>
<!-- /Header (Sort) -->
