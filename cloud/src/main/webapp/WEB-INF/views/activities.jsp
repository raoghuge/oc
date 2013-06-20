<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph</title>
  	  <link rel="shortcut icon" href="${applicationScope.contextPath}/resources/images/favicon.ico" />
      <link rel="stylesheet" href="${applicationScope.contextPath}/resources/css/style.css" type="text/css" media="screen" />      
      <script src="${applicationScope.contextPath}/resources/js/geo-min.js" type="text/javascript" charset="utf-8"></script>
	  <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
      <script type="text/javascript" src="${applicationScope.contextPath}/resources/js/jquery.js" language="javascript"></script>
      <script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/arbor.js"></script>
	<script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/arborGraphics.js"></script>
	<script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/graphRenderer.js"></script>
		<script type="text/javascript" src="${applicationScope.contextPath}/resources/js/alertHandler.js"
		language="javascript"></script>
     <script type="text/javascript">
/* <![CDATA[ */
$(document).ready(function(){
var moveLeft = -50;
var moveDown = 0;  
$('a.passinfo').click(function(e) {
    $('div.man-li-up').toggle("fast");  
	   $("div.man-li-up").css('top', e.pageY ).css('left', e.pageX);
 	//   $("div.man-li-up").css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);

  } );
   $("a.conn").click(function() {
	  $(".prof-dis").hide();
	  $(".conn-dis").show(); 
	   $(".li2").removeClass('active');  
	  $(".li1").addClass("active");
   });
   $("a.prof-con").click(function() {
	  $(".prof-dis").show();
	  $(".conn-dis").hide(); 
	  $(".li1").removeClass('active');  
	  $(".li2").addClass("active");
   });
   
 
   
	$("#tabs_n li").click(function() {
		//	First remove class "active" from currently active tab
		$(".man-li-up").hide();
		$("#tabs_n li").removeClass('active');

		//	Now add class "active" to the selected/clicked tab
		$(this).addClass("active");

		//	Hide all tab content
		$(".tab_content_n").hide();

		//	Here we get the href value of the selected tab
		var selected_tab = $(this).find("a").attr("href");

		//	Show the selected tab content
		$(selected_tab).fadeIn();

		//	At the end, we add return false so that the click on the link is not executed
		return false;
		
		

	});
	
	$(".close_list").click(function () {
	$(this).parent().hide();
	});
	
	 $(".hover").mouseover(function() {
$(this).css('width',84);
$(this).val('Unfollow');
}).mouseout(function(){
$(this).val('Following');
});

});

function getMessageFormatted(message) {
	var formattedMessage = "";
	if(message!=null) {
		var words = message.split(" ");
		var fineWord = "";
		for ( var i = 0; i < words.length; i++) {
			fineWord = words[i];
			appendWord = "";
			if(fineWord.indexOf('@')==0) {
				appendWord = "<a href=\"javascript:profile_pop()\">" + fineWord + "</a>";
			} else if(fineWord.indexOf('#')==0) {
				appendWord = "<a onclick='showTrendMessages(\""+ fineWord +"\");'>" + fineWord + "</a>";
			} else {
				appendWord = fineWord;
			}
			formattedMessage = formattedMessage + " " + appendWord;
		}
	}
	return formattedMessage;
}
	 
	 
function getMessagesUpdatesFromFriendsAndFollowing() {
	//alert('friends and following');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/activities/getMessagesUpdatesFromFriendsAndFollowing',
		success: function(data) {
			var messages="";
			messages = messages +"Recent friend or Follower who messaged  <br />";
			
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	var relation = "";
		    	if(data[i].relType==null) {
		    		relation="Following";
		    	}
		    	else if(data[i].relType=="org.socialgraph.domain.Friend") {
		     		relation="Friend";
		     	} 
		    	
		    	messages = messages + "<a title='"+data[i].username+"' href=\"javascript:profile_pop('"+data[i].username+"')\"><img height=\"30px\" width=\"30px\" src='" + data[i].userPhotoUrl + "' /></a>";
		    }
		   
		    $('#tabMessages').html(messages);
		}
		});
	}
	
function getRecentFriends() {     
	//alert('Friends');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/activities/getRecentFriends',
		success: function(data) {
			var messages="";
			messages = messages +"Recently <strong><a href=\"javascript:profile_pop('${activeUser.username}')\"><span class=\"tit-sml\">"+'${activeUser.username}'+"</span></a></strong> became friend with "+data.length+" people <br />";
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	messages = messages + "<a title='"+data[i].username+"' href=\"javascript:profile_pop('"+data[i].username+"')\"><img height=\"30px\" width=\"30px\" src='" + data[i].userPhotoUrl + "' /></a>";
		    }
		   
		    $('#tabFriends').html(messages);
		}
		});
	}
	
function getRecentFollowers() {     
	//alert('Friends');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/activities/getRecentFollowers',
		success: function(data) {
			var messages="";
			messages = messages +"Recently Following people followed <strong><a href=\"javascript:profile_pop('${activeUser.username}')\"><span class=\"tit-sml\">"+'${activeUser.username}'+"</span></a></strong> <br />";
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	messages = messages + "<a title='"+data[i].username+"' href=\"javascript:profile_pop('"+data[i].username+"')\"><img height=\"30px\" width=\"30px\" src='" + data[i].userPhotoUrl + "' /></a>";
		    }
		   
		    $('#tabFollowers').html(messages);
		}
		});
	}
	
	
function getRecentFollowing() {     
	//alert('Friends');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/activities/getRecentFollowing',
		success: function(data) {
			var messages="";
			messages = messages +"<a href=\"javascript:profile_pop('${activeUser.username}')\"><span class=\"tit-sml\">"+'${activeUser.username}'+"</span></a></strong> Following <strong> <br />";
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	messages = messages + "<a title='"+data[i].username+"' href=\"javascript:profile_pop('"+data[i].username+"')\"><img height=\"30px\" width=\"30px\" src='" + data[i].userPhotoUrl + "' /></a>";
		    }
		   
		    $('#tabFollowing').html(messages);
		}
		});
	}
	getMessagesUpdatesFromFriendsAndFollowing();
	 getRecentFriends();
	 getRecentFollowers();
	 getRecentFollowing();
	 
/* ]]> */
</script> 
</head>

<body>
<%@ include file="profile-popup.jsp" %>
<div id="trends-block" style="display: none;">
  <div class="trans"></div>
  <div class="pop">
   <div class="main-pop het">
    <div class="close-btn">
     <div class="title-form">Trends.</div>
     <a href="javascript:trend_close()" title="Close"><img
      src="${applicationScope.contextPath}/resources/images/close.jpg" alt="Close" title="Close" class="right"></a>
    </div>
    <hr />

    <span><strong>Trends set to <a id="trendCountry">Worldwide
     </a>
     <a id="trendCity"></a>
    </strong><br />
    
    </span>
    <div id="trendLocations"></div>
    <input class="blue-btn right" id="trendReset" type="button" value="Reset" name="" onclick="clearPrefs();">
     <input class="blue-btn right mar-rig-btn" id="trendSet" type="button" value="Done" name="" onclick="setCountryCity();">

    <div class="clear"></div>
   </div>
  </div>
 </div>



<div id="gif-main" class="gif-main"></div>
<div class="head-home border">
<div class="head-in">
<span class="logo"><img src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png" title="Social Graph" alt="Social Graph" /></span>
<div class="log-rig-new"><input name="" type="text" value="Search"/>   Welcome ${activeUser.displayName} |  <a href="${applicationScope.contextPath}/auth/logout" title="Logout">Logout</a>
<div class="tab-home">
<div id="tabs_container">
		<ul id="tabs">
			<li ><a href="${applicationScope.contextPath}/user">Home</a></li><li class="active"><a href="${applicationScope.contextPath}/activities/show">Acitivities</a></li><li><a href="${applicationScope.contextPath}/find/show">Find</a></li><li><a href="${applicationScope.contextPath}/media">Media</a></li><li><a href="${applicationScope.contextPath}/user/profile">Profile</a></li><li style="display: none;"><a href="#">new</a></li>
		</ul>
	</div>
    
</div>
</div>
</div>
</div>

<div class="main-content">
<div class="tab-wrap-hap col">
<h1>Interactions</h1>
<div class="hap-profile">
<div class="hap-ant" id="tabMessages">
	
</div>

<div class="hap-ant" id="tabFriends">
	
</div>

<div class="hap-ant" id="tabFollowers">
	
</div>

<div class="hap-ant" id="tabFollowing">
	
</div>

</div>


 </div>

<%@ include file="suggestions.jsp" %> 
	
</div>


<div class="footer">
<div class="head-in">
<span class="col"><a href="javascript:;">About</a>  |  <a href="javascript:;">Help</a>  |  <a href="javascript:;">Terms</a>  |  <a href="javascript:;">Privacy</a>  |  <a href="javascript:;">Contact Us</a> <br />
Copyright &copy; 2013 Website Name. All rights reserved.</span>
<span class="right">Site design and developed by <a href="javascript:;" class="txt-dec">Dream Solutions</a>.</span>
</div>
</div>
<div class="man-li-up">
    <ul>
    <li><a href="#">Chat to @ abc..</a></li>
    <li><a href="#">Add or remove from the list</a></li>
    <li><a href="#">Block @abc</a></li>
    </ul>
    </div>
</body>
</html>
