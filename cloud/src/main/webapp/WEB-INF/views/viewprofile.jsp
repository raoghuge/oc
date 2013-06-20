<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="janrain" uri="http://janrain4j.googlecode.com/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph </title>
	  <link rel="shortcut icon" href="${applicationScope.contextPath}/resources/images/favicon.ico" />
      <link rel="stylesheet" href="${applicationScope.contextPath}/resources/css/style.css" type="text/css" media="screen" />      
      <script src="${applicationScope.contextPath}/resources/js/geo-min.js" type="text/javascript" charset="utf-8"></script>
	  <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
      <script type="text/javascript" src="${applicationScope.contextPath}/resources/js/jquery.js" language="javascript"></script>
      <script type="text/javascript" src="${applicationScope.contextPath}/resources/js/alertHandler.js" language="javascript"></script>
      
     <script type="text/javascript">
/* <![CDATA[ */
$(document).click(function(e) {
	$('div.noti-li-up').hide();
	$('div.noti-li-frd').hide();
	$('div.noti-li-msg').hide();	
});

$(document).ready(function(){
	alert("ready");
	$('div.man-li-up').hide();
	$('div.noti-li-up').hide();
	$('div.noti-li-frd').hide();
	$('div.noti-li-msg').hide();

	$('a.noti-icon').click(function(e) {
		//  alert("hi");
		$(this).find("span").hide();
		$('div.noti-li-up').show("fast");  
		$("div.noti-li-up").css('top',47 ).css('left', e.pageX - 160);
		//$('div.noti-li-up').toggle("fast");  
	});

	$('a.noti-user').click(function(e) {
		$(this).find("span").hide();
		$('div.noti-li-frd').show("fast");  
		$("div.noti-li-frd").css('top',47 ).css('left', e.pageX - 160);
	});

	$('a.noti-msg').click(function(e) {
		$(this).find("span").hide();
		$('div.noti-li-msg').show("fast");  
		$("div.noti-li-msg").css('top',47 ).css('left', e.pageX - 160);
	});
	
	// Setting css of Message tab as block	
	$("#tab1_n").css('display', 'block' );
	
	setUserLocationIcon();
	
	checkFriendRequest();
	setFriendsCount();
	
/*	 var globalStart = 0;
	var globalPageSize = 2;
	var isScrollingFull = false;
	var whichDataIsBeingScrolled = "getMessagesUpdatesFromFriendsAndFollowing";
	
	getMessagesUpdatesFromFriendsAndFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});*/
	
	 var globalStart = 0;
	var globalPageSize = 2;
	var isScrollingFull = false;
	var whichDataIsBeingScrolled = "getOwnMessages";
	getOwnMessages(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;}); 
	
	
	$(window).scroll(function(){
	    if  ($(window).scrollTop() == $(document).height() - $(window).height()){
	    	if(!isScrollingFull) {
	    		//$('#msgUpdates').append("<li id=\"loading\">Loading more..</li>");
		    	globalStart = globalStart + 1;
		    	
		    	if(whichDataIsBeingScrolled=="getMessagesUpdatesFromFriendsAndFollowing") {
		    		getMessagesUpdatesFromFriendsAndFollowing(globalStart, globalPageSize, function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	} else if(whichDataIsBeingScrolled=="getMessagesUpdatesFromFollowing") {
		    		getMessagesUpdatesFromFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	} else if(whichDataIsBeingScrolled=="getMessagesUpdatesFromFollowers") {
		    		getMessagesUpdatesFromFollowers(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	} else if(whichDataIsBeingScrolled=="getMessagesUpdatesFromFriends") {
		    		getMessagesUpdatesFromFriends(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	} else if(whichDataIsBeingScrolled=="getOwnMessages") {
		    		getOwnMessages(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	} else if(whichDataIsBeingScrolled=="searchMessages") {
		    		var criteria = $("#search").val();
		    		searchMessages(criteria, globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		    	}
	    	}
	    }
	}); 

	$("#liMessage").click(function () {	//tab Message when clicked
		globalStart = 0;
		isScrollingFull = false;
		whichDataIsBeingScrolled = "getMessagesUpdatesFromFriendsAndFollowing";
		getMessagesUpdatesFromFriendsAndFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
	});
	
	$("#liFollowings").click(function () {
		globalStart = 0;
		isScrollingFull = false;
		whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowing";
		getMessagesUpdatesFromFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
	});
	
	$("#liFollowers").click(function () {
		globalStart = 0;
		isScrollingFull = false;
		whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowers";
		getMessagesUpdatesFromFollowers(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
	});
	
	$("#liFriends").click(function () {
		globalStart = 0;
		isScrollingFull = false;
		whichDataIsBeingScrolled = "getMessagesUpdatesFromFriends";
		getMessagesUpdatesFromFriends(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
	}); 
	
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
		
	$("#tabs_next li").click(function() {
		//	First remove class "active" from currently active tab
		$(".man-li-up").hide();
		 var index = $("#tabs_next li").index(this);
		$("#tabs_n li").removeClass('active');
		if(index==0) {
			globalStart = 0;
			isScrollingFull = false;
			whichDataIsBeingScrolled = "getOwnMessages";
			getOwnMessages(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		} else if(index==1) {
			globalStart = 0;
			isScrollingFull = false;
			whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowing";
			getMessagesUpdatesFromFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		} else if(index==2) {
			globalStart = 0;
			isScrollingFull = false;
			whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowers";
			getMessagesUpdatesFromFollowers(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		} else if(index==3) {
			globalStart = 0;
			isScrollingFull = false;
			whichDataIsBeingScrolled = "getMessagesUpdatesFromFriends";
			getMessagesUpdatesFromFriends(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		} 
		//	Now add class "active" to the selected/clicked tab
		$("#tabs_n li"+".up"+index).addClass("active");
		//	Hide all tab content
		$(".tab_content_n").hide();
		//	Here we get the href value of the selected tab
		var selected_tab = $(this).find("a").attr("href");
		//	Show the selected tab content
		$(selected_tab).fadeIn();
		//	At the end, we add return false so that the click on the link is not executed
		return false;
	});

	$(".hover").mouseover(function() {
		$(this).css('width',84);
		$(this).val('Unfollow');
		}).mouseout(function(){
		$(this).val('Following');
	});
	 
	$("#search").bind('keyup', function() {
		if ($("#search").val() != "") {
			var criteria = $("#search").val();
			if(criteria.length>1){
				globalStart = 0;
				isScrollingFull = false;
				whichDataIsBeingScrolled = "searchMessages";
				searchMessages(criteria, globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
			}
		}
	});
	 
	 $("#msg").bind('keyup', function(event) {

		if ($("#msg").val() != "") 
		{
			var msgVal = $("#msg").val();
			
			if(event.keyCode == 32)
			{
				var patt=/http:/g;
				if(patt.test(msgVal) == true)
					{
					var urlRegex = /(https?:\/\/[^\s]+)/g;
					msgVal.replace(urlRegex, function(shorturl) {
					        
					        $.ajax({
					        	type : "GET",
								url : "${applicationScope.URLShortner}/url/shorten",
								data : {url : shorturl},
								success : function(data) {
									shorturl = shorturl.replace(shorturl,data);
									msgVal = msgVal.replace(urlRegex,shorturl);
									$("#msg").val(msgVal);
									//$("#msg").val("<a onclick='expand(\""+msgVal+"\")'>"+msgVal+"</a>");
					    		},
								error : function(e) {
									console.log(e);
									return false; 
								}
							}); 
    
					    });
					}
			}
		}
	});
	 
	 $(".hover").mouseover(function() {
		$(this).css('width',84);
		$(this).val('Unfollow');
		}).mouseout(function(){
		$(this).val('Following');
	});
	
});

$(".gray-btn col").click(function() {
	
	var msgVal = $("#msg").val();
	 alert(msgVal);
	 if (msgVal && !msgVal.match(/^http([s]?):\/\/.*/)) {
		    input.val('http://' + val);
		    alert(msgVal);
		  }
});
	
function searchMessages(criteria, startIndex, pageSize, callback){
	//alert('in searchMessage' + startIndex + ", " + pageSize);
	$.ajax({
		type : "GET",
		url : "${applicationScope.contextPath}/user/searchMessages",
		data: {criteria: criteria, startIndex: startIndex, pageSize: pageSize},
		success : function(response) 
		{				
			if (response == "notfound") 
			{
				//alert("not found");			
			}
			else 
			{		 				
					var messages="";
					if(startIndex==0) {
						messages = messages +"<ul id='msgUpdates'>";
					}
				    for ( var i = 0; i < response.length; i ++) 
				    {
				
				    	messages = messages + "<li><img src='" +  response[i].profilePhoto + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
						+ response[i].username
						+ "\");'>" + response[i].displayName + "</a></span> @" + response[i].username + "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" />";
						messages = messages + "<p>" + getMessageFormatted(response[i].message) + "</p>";
				    	messages = messages + "<p><br>" + response[i].when + "</p></div>";
				    	messages = messages + "</li>";
				 
				    }
				    if(startIndex==0) {
				    	messages = messages +"</ul>"; 
				    	$('#tabMessages').html(messages);
					} 
				   	else {
				  		$('#msgUpdates').append(messages);
				   	}
				   	
				   	if(data.length < pageSize) {
				   		callback(true);
				   	} else {
				   		callback(false);
				   	}	
			}  
		
		},
		error : function(e) 
		{
			console.log(e);
			
			return false;
		}
	});
}

function setFriendsCount(){
	//alert('in setFriendsCount');
 	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getCounts',
		success: function(data) {
			$("#friendNum").html(data.friendsLength+ " <br /> Friends");
		}
		}); 
}



function checkFriendRequest(){
	//alert('in checkFriendRequest');
	$.ajax({
		type: 'POST',
		url: '${applicationScope.contextPath}/user/checkFriendRequest',
		success: function(data) {
			if(data.length>0){
			$(".noti-user").html("<img src=\"${applicationScope.contextPath}/resources/images/noti-user.jpg\" /><span>"+data.length+"</span>");
			$("#friendRequestTab").html("Friend Request <span>"+data.length+"</span> <a class=\"right\">See more</a>");	
			
			var friendRequestHtml="<ul>";
			for(var index=0;index<data.length;index++){
			friendRequestHtml=friendRequestHtml+"<li><img height=\"40\" width=\"40\" src=\""+data[index].photoUrl+"\">";
			friendRequestHtml=friendRequestHtml+"<p>";
			friendRequestHtml=friendRequestHtml+"<a href=\"#\">"+data[index].displayName+"</a> send you friend request";
			
			friendRequestHtml=friendRequestHtml+"<a class=\"blue-btn\" href=\"javascript:approveFriendRequest('${activeUser.username}','"+data[index].username+"')\">Accept</a><a class=\"blue-btn\" href=\"javascript:rejectFriendRequest('${activeUser.username}','"+data[index].username+"')\">Reject</a>";
			friendRequestHtml=friendRequestHtml+"</p></li>";
			}
			friendRequestHtml=friendRequestHtml+"</ul>";
			$("#friendRequestTab").append(friendRequestHtml);
			
			
			 /* <li><img src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"/> <p><a href="#">abc girl</a> send you friend request
			    <a href="#" class="blue-btn">Accept</a>   <a href="#" class="blue-btn">Reject</a>  
			    <span class="col">1 common friend</span></p>
			    </li> */
			
		/* 	<ul>
			<li>
			<img src="/social/resources/images/thumb_girl.jpg">
			<p>
			<a href="#">abc girl</a>
			send you friend request
			<a class="blue-btn" href="#">Accept</a>
			<a class="blue-btn" href="#">Reject</a>
			<span class="col">1 common friend</span>
			</p>
			</li>
			</ul>
			*/
		
			
			}else{
				$(".noti-user").html("<img src=\"${applicationScope.contextPath}/resources/images/noti-user.jpg\" />");
				$("#friendRequestTab").html("Friend Request  <a class=\"right\">See more</a><ul><li>No New Friend Request</li></ul>");	
			}
			//alert(data.length);
			//showAlert("You are now friend of @"+user);
		//	$("#friendNum").html(data.friendCount).append("<br /> Friends</a>");
		}
		});
}

function approveFriendRequest(userName,friendName){
 	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/approveFriendRequest',
		data:{friendName: friendName,
			  myName:userName},
		success: function(data) {
			showAlert("You are now friend of @"+friendName);
			setFriendsCount();
			checkFriendRequest();
		}
		}); 
 	
}

function rejectFriendRequest(userName,friendName){
	 	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/rejectFriendRequest',
		data:{friendName: friendName,
			  myName:userName},
		success: function(data) {
		}
		}); 
}



function addFriend(user, index) { 

	$.ajax({
		type: 'POST',
		url: '${applicationScope.contextPath}/user/addFriend',

		data: {friendUsername: user},

		success: function(data) {
			showAlert("You are now friend of @"+user);
		/* 	$("#friendNum").html(data.friendCount).append("<br /> Friends</a>"); */
			setFriendsCount();
		}
		});
	}
	function postMsgUrl()
	{
		var msgVal = $("#msg").val();
		var patt=/http:/g;
		if(patt.test(msgVal) == true)
			{
			var urlRegex = /(https?:\/\/[^\s]+)/g;
			msgVal.replace(urlRegex, function(shorturl) {
			        
			        $.ajax({
			        	type : "GET",
						url : "${applicationScope.URLShortner}/url/shorten",
						data : {url : shorturl},
						success : function(data) {
							shorturl = shorturl.replace(shorturl,data);
							msgVal = msgVal.replace(urlRegex,shorturl);
							$("#msg").val(msgVal);
							postMessage();
							//$("#msg").val("<a onclick='expand(\""+msgVal+"\")'>"+msgVal+"</a>");
			    		},
						error : function(e) {
							console.log(e);
							return false; 
						}
					}); 

			    });
			}
		
		else
			{
				postMessage();
			}
	}
function postMessage() 
{
	var msgVal = $("#msg").val();
	var latVal = $("#latitude").val();
	var lonVal = $("#longitude").val();
	var countryVal = $("#country").val();
	var cityVal = $("#city").val();
	var isSharedVal = $("#isShared").val();
	var isUserLocationOn = $("#isUserLocationOn").val();
	
	//alert(msgVal + cityVal + " " + countryVal + " " + latVal + lonVal + isSharedVal + isUserLocationOn);
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/post',
		data: {msg: msgVal, latitude: latVal, longitude: lonVal, country: countryVal, city: cityVal, isShared: isSharedVal,isUserLocationOn:isUserLocationOn},
		success: function(data) 
		{
		   // alert('status of this operation is ' + data.messageCount);
		    $("#messageCount").html(data.messageCount);
		    getTrends();
		    showAlert("Message posted !!!");
		    $("#msg").val('');
		}
		});
	//alert("Ajaxing end");
	
	
}





function getOwnMessages(startIndex, pageSize, callback) { 

	/* callback = function deleteCallback(val) { 
		//alert(val);
		if(val==true) {
			getOwnMessages(startIndex, pageSize, function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
		}
	} */
	alert("getOwnMessages");
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getTweets',
		data: {startIndex: startIndex, pageSize: pageSize},
		success: function(data) {
alert(data);
			var messages="";
			if(startIndex==0) {
				messages = messages +"<ul id='msgUpdates'>";
			}
		    for ( var i = 0; i < data.length; i ++) 
		    {
		    	
		    	var id = data[i].key;	//startIndex + "-" + i;
		    	messages = messages + "<li id=\"" + id + "\"><img src='" +  data[i].profilePhoto + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
				+ data[i].username
				+ "\");'>" + data[i].displayName + "</a></span> @" + data[i].username + "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /><a onclick='deleteMessage(\"" + data[i].message + "\",\"" + data[i].key + "\");'>Delete</a>";
				messages = messages + "<p>" + getMessageFormatted(data[i].message) + "</p>";
		    	messages = messages + "<p><br>" + data[i].when + "</p></div>";
		    	messages = messages + "</li>";
alert(messages);
		    }
		  //getTrends();
		    if(startIndex==0) {
		    	messages = messages +"</ul>"; 
		    	$('#tabMessages').html(messages);
			} 
		   	else {
		  		$('#msgUpdates').append(messages);
		   	} 
		   	
		   	if(data.length < pageSize) {
		   		callback(true);
		   	} else {
		   		callback(false);
		   	}	
		}
		});
}
	
function onClickTabMessages(globalStart, globalPageSize) {
	globalStart = 0;
	isScrollingFull = false;
	getMessagesUpdatesFromFriendsAndFollowing(globalStart, globalPageSize,function(isScrollingFullArg) {isScrollingFull = isScrollingFullArg;});
}

function getMessagesUpdatesFromFriendsAndFollowing(startIndex, pageSize, callback) {
	//alert('in friends and followings');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getMessagesUpdatesFromFriendsAndFollowing',
		data: {startIndex: startIndex, pageSize: pageSize},
		success: function(data) {
			var messages="";
			if(startIndex==0) {
				messages = messages +"<ul id='msgUpdates'>";
			}
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	//alert(data[i].username + data[i].displayName + data[i].userPhotoUrl);
		    	var relation = "";
		    	if(data[i].relType==null) {
		    		relation="Following";
		    	}
		    	else if(data[i].relType=="org.socialgraph.domain.Friend") {
		     		relation="Friend";
		     	} 
		  
		    	messages = messages + "<li><img src='" + data[i].userPhotoUrl + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
				+ data[i].username
				+ "\");'>" + data[i].displayName + "</a></span> " + data[i].username + "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /><a onclick='shareMessage(\""+ data[i].key + "\");'>Share</a>";
		    	messages = messages + "<p>" + getMessageFormatted(data[i].message) + "</p>";
		    	messages = messages + "<p><br>" + data[i].when + "</p></div>";
		    	messages = messages + "</li>";
		    }
		  
		   	if(startIndex==0) {
		    	messages = messages +"</ul>"; 
		    	$('#tabMessages').html(messages);
			} 
		   	else {
		  		$('#msgUpdates').append(messages);
		   	}
		   	
		   	if(data.length < pageSize) {
		   		callback(true);
		   	} else {
		   		callback(false);
		   	}	
		}
		});
	}

function getMessagesUpdatesFromFollowing(startIndex, pageSize, callback) {     

	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getUpdatesFromFollowing',
		data: {startIndex: startIndex, pageSize: pageSize},
		success: function(data) {
			var messages="";
			if(startIndex==0) {
				messages = messages +"<ul id='ulFollowing'>";
			}
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	
		    	messages = messages + "<li><img src=\"" + data[i].userPhotoUrl + "\" />";
		    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\">";
		    	messages = messages + "<a onclick='profile_pop(\"" + data[i].username + "\");'>"
		    	messages = messages + data[i].displayName + "</a></span>" + data[i].username +
		    	"<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> "+
		    	"<span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\">"+
		    	"<img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" />"+
		    	"</a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Following\"  /></span>";
		    	messages = messages + "<p class=\"small-p\">" + getMessageFormatted(data[i].message) + "</p></div>";
		    	messages = messages + "</li>";
		    }
		    
		    if(startIndex==0) {
		    	messages = messages +"</ul>"; 
		    	$('#tabFollowing').html(messages);
			} 
		   	else {
		  		$('#ulFollowing').append(messages);
		   	}
		   	
		   	if(data.length < pageSize) {
		   		callback(true);
		   	} else {
		   		callback(false);
		   	}	
		}
		});
	}
	
function getMessagesUpdatesFromFollowers(startIndex, pageSize, callback) {     
	//alert('followers');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getUpdatesFromFollowers',
		data: {startIndex: startIndex, pageSize: pageSize},
		success: function(data) {
			var messages="";
			if(startIndex==0) {
				messages = messages +"<ul id='ulFollowers'>";
			}
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	messages = messages + "<li><img src=\"" + data[i].userPhotoUrl + "\" />";
		    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\">";
		    	messages = messages + "<a onclick='profile_pop(\"" + data[i].username + "\");'>"
		    	messages = messages + data[i].displayName + "</a></span>" + data[i].username +
		    	"<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> "+
		    	"<span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\">"+
		    	"<img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" />"+
		    	"</a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Follow\"  /></span>";
		    	messages = messages + "<p class=\"small-p\">" + getMessageFormatted(data[i].message) + "</p></div>";
		    	messages = messages + "</li>";
		    }
		    if(startIndex==0) {
		    	messages = messages +"</ul>"; 
		    	$('#tabFollowers').html(messages);
			} 
		   	else {
		  		$('#ulFollowers').append(messages);
		   	}
		   	
		   	if(data.length < pageSize) {
		   		callback(true);
		   	} else {
		   		callback(false);
		   	}	
		}
		});
	}
	
function getMessagesUpdatesFromFriends(startIndex, pageSize, callback) {     
	//alert('Friends');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/user/getUpdatesFromFriends',
		data: {startIndex: startIndex, pageSize: pageSize},
		success: function(data) {
			//alert(data);
			var messages="";
			if(startIndex==0) {
				messages = messages +"<ul id='ulFriends'>";
			}
		    for ( var i = 0; i < data.length; i += 1) 
		    {
		    	//alert('in loop');
		    	messages = messages + "<li><img src=\"" + data[i].userPhotoUrl + "\" /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
				+ data[i].username
				+ "\");'>" + data[i].displayName + "</a></span>" + data[i].username + "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> <span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\"><img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" /></a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Unfriend\"  /></span>";
		    	messages = messages + "<p class=\"small-p\">" + getMessageFormatted(data[i].message) + "</p></div>";
		    	messages = messages + "</li>";
		    	
		    	//messages = messages + "<li><img src=\"${applicationScope.contextPath}/resources/images/thumb_girl.jpg\" /><div class=\"col prof-li\"><span class=\"tit-sml\"><a href=\"javascript:profile_pop()\">JYOTI PATIL</a></span> @napasninja <img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> <span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\"><img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" /></a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Following\"  /></span>";
		    	//messages = messages + "<p class=\"small-p\">hey hi m icwa final student I am simple n sweet my frnds say that.... and I love my family</p></div>";
		    	//messages = messages + "</li>";
		    }
		    if(startIndex==0) {
		    	messages = messages +"</ul>"; 
		    	$('#tabFriends').html(messages);
			} 
		   	else {
		  		$('#ulFriends').append(messages);
		   	}
		   	
		   	if(data.length < pageSize) {
		   		callback(true);
		   	} else {
		   		callback(false);
		   	}	
		}
		});
	}
	
function deleteMessage(strMessage, key) { 
	alert('in delete');
	$.ajax({
		type: 'POST',
		url: '${applicationScope.contextPath}/user/deleteMessage',
		data: {message: strMessage, key: key},
		success: function(data) {
			$("#messageCount").html(data.messageCount);
			showAlert("Message deleted !!!");
			$('#' + key).remove();
		}
		});
	}

	
function shareMessage(key) { 
	alert('in share');
	$.ajax({
		type: 'POST',
		url: '${applicationScope.contextPath}/user/shareMessage',
		data: {key: key},
		success: function(data) {
			$("#messageCount").html(data.messageCount);
			showAlert("Message shared !!!");
		}
		});
	}


function setUserLocationOnOff(button) {
	$.ajax({
		type: 'POST',
		url: '${applicationScope.contextPath}/user/setUserLocationOnOff',
		success: function(data) {
		    	//alert('set to ' + data);//Set hidden field to blank
		    	if(data==false)
		    		{
		    		button.style.backgroundImage="url(${applicationScope.contextPath}/resources/images/nolocation.png)";
		    		document.getElementById('location_city').innerHTML="";
		    		
		    		document.getElementById('latitude').value = "";
					document.getElementById('longitude').value = "";
					document.getElementById('city').value="";
					document.getElementById('country').value="";
					document.getElementById('isUserLocationOn').value=false;
		    		}
		    	else
		    	{
		    		button.style.backgroundImage="url(${applicationScope.contextPath}/resources/images/location.png)";
		    		document.getElementById('isUserLocationOn').value=true;
		    		if(geo_position_js.init()){
		    			geo_position_js.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
		    			geocoder = new google.maps.Geocoder();
		    		}
		    		else{
		    			//alert("Functionality not available");
		    		}
		    	}
		    	
		    }
		});
	
}




/* ]]> */
</script> 
<script language="javascript" type="text/javascript">  
	

  function caption()
  {
	  $('#caption').css('display','block');
  }
  function clearCaption() 
  {
	  $('#caption').css('display','none');
  }
  function open_pop()
  {
	  $('#form1-pop').css('display','block');
  }
  function close_pop()
  {
	  $('#form1-pop').css('display','none');
  }
  

	
		
 </script>
</head>

<body>

<div id="trends-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop het">
				<div class="close-btn">
					<div class="title-form">Trends.</div>
					<a href="javascript:trend_close()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg" alt="Close" title="Close" class="right"/></a>
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

<div id="form1-pop" style="display:none;">
<div class="trans"></div>
<div class="pop">
<div class="main-pop">
<div class="close-btn"><div class="title-form">Update your profile image</div><a href="javascript:close_pop();" title="Close"><img src="${applicationScope.contextPath}/resources/images/close.jpg" alt="Close" title="Close"  class="col"></a></div>
<form method="post" name="uploadForm" action="${applicationScope.contextPath}/user/upload" enctype="multipart/form-data">
<span>Upload Image</span>
<input name="fileData" type="file" />
<input type="submit" name="send" class="blue-btn" value="Upload" />
</form>
<div class="clear"></div>
</div>
</div>
</div>

<script>
	var geocoder;
	
		$('#liMessage').focus(function() {
		//alert('Handler for .focus() called.');
		});
	
		if(geo_position_js.init()){
			geo_position_js.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
			geocoder = new google.maps.Geocoder();
			//alert('location det');
		}
		else{
			//alert("Functionality not available");
		}

		function success_callback(p)
		{
			//document.getElementById('point').innerHTML='lat='+p.coords.latitude+';lon='+p.coords.longitude;
			document.getElementById('latitude').value = p.coords.latitude;
			document.getElementById('longitude').value = p.coords.longitude;
			//alert(p.coords.latitude);
			codeLatLng(p.coords.latitude,p.coords.longitude);
		}
		
		function error_callback(p)
		{
			//alert('error='+p.message);
		}		
		
	
		function setUserLocationIcon() {
		//	alert("Ajaxing");
	
		geo_position_js.getCurrentPosition(success_callback,error_callback,{enableHighAccuracy:true});
		
		
			//alert("Ajaxing end");
		    //alert('Posted your Message successfully..!!!');
		}

		
		
function codeLatLng(lat, lng)
{
    var latlng = new google.maps.LatLng(lat, lng);
    geocoder.geocode(
    {'latLng': latlng}, function(results, status) 
    
    {
      if (status == google.maps.GeocoderStatus.OK) 
      {
    	  var city ="",country="",location="";
    	//  console.log(results);
    	  if (results[1]) 
    	  {
    	   		  
    		  for (var i=0; i<results[0].address_components.length; i++) 
    		  {
    			  for (var b=0;b<results[0].address_components[i].types.length;b++) 
    			  {
    			
    				  
    				  if (results[0].address_components[i].types[b] == "locality") 
    				  {
    					  
    					 city= results[0].address_components[i].long_name;
    					 //alert(city);
    					 document.getElementById('city').value=city;		
    					// alert(city);
						location=location+city+",";
    					
    				  } 
    				  
    				  if (results[0].address_components[i].types[b] == "country") 
    				  {
    					 country= results[0].address_components[i].long_name;    					    					 
    					// window.location.href="http://"+ (country.short_name).toLowerCase() +".fanggle.com";		
    					//alert(country);
						document.getElementById('country').value=country; 
						//document.getElementById('country').value=country.long_name;
						
						location=location+country;
    				  } 

    			  }
    			 
    			
    			
    		  }
    		  
    			$.ajax({
					type: 'GET',
					url: '/social/user/getUserLocationOnOffStatus',
					success: function(data) {
							  
							    if(data==false) {

							    	document.getElementById("btnLoc").style.backgroundImage="url(${applicationScope.contextPath}/resources/images/nolocation.png)";
							    	
							    	document.getElementById('latitude').value = "";
									document.getElementById('longitude').value = "";
									document.getElementById('city').value="";
									document.getElementById('country').value="";
									document.getElementById('isUserLocationOn').value=false;
							    } else {
							    	
							    	document.getElementById("btnLoc").style.backgroundImage="url(${applicationScope.contextPath}/resources/images/location.png)";
							    	document.getElementById('location_city').innerHTML=location;
							    	document.getElementById('isUserLocationOn').value=true;
							    }
					    	}
					});
   		  
    	  }
    	  else 
    	  {
		  document.getElementById('location').innerHTML='Not available';
    		//  window.location.href="http://www.fanggle.com";
    	  }
      }
      else 
      {
	   document.getElementById('location').innerHTML='Not available';
    	  //window.location.href="http://www.fanggle.com";
      }
    });
  }
	</script>
	<div id="point" > </div>
<div class="head-home border">
<div class="head-in">
<span class="logo"><img src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png" title="Social Graph" alt="Social Graph" /></span>
<div class="log-rig-new"><div class="right"><input name="" type="text" placeholder="Search" id="search"/>  Welcome ${activeUser.displayName} |<a href="${applicationScope.contextPath}/auth/logout" title="Logout">Logout</a></div> <ul class="noti-li"><!-- <li><a href="javascript:;" class="noti-msg"><img src="${applicationScope.contextPath}/resources/images/noti-msg.jpg"/><span>3</span></a></li>--><li><a href="javascript:;" class="noti-user"><img src="${applicationScope.contextPath}/resources/images/noti-user.jpg" /><!-- <span>35</span> --></a></li><!-- <li><a href="javascript:;" class="noti-icon"><img src="${applicationScope.contextPath}/resources/images/noti-icon.jpg" /><span>355</span></a></li> --></ul>
<div class="tab-home">
<div id="tabs_container">
		<ul id="tabs">
			<li class="active"><a href="#">${activeUser.displayName}</a></li><li><a href="${applicationScope.contextPath}/activities/show">Activities</a></li><li><a href="${applicationScope.contextPath}/find/show">Find</a></li><li><a href="${applicationScope.contextPath}/user/profile">Profile</a></li>
		</ul>
</div>
    
</div>
</div>
</div>
</div>
<div class="home-m">
  <div class="profile-div">
  <div class="img-prof"><a href="javascript:;"  onclick="open_pop();"><img src="${activeUser.profilePhoto}" id="profile_pic" style="width: 115px; height: 130px;" alt="Change Your Image" onmouseover="caption();" onmouseout="clearCaption();"/></a></div>
  <div class="name col"><a onclick='profile_pop("${activeUser.username}");'>${activeUser.displayName}</a><br /> <span><a onclick='profile_pop("${activeUser.username}");'>View my profile</a></span>
  <ul id="tabs_next"><li id="message"><a href="#tab1_n"><span id='messageCount'>${fn:length(activeUser.messages)}</span><br /> Message</a></li><li id="following"><a href="#tab2_n" id="followingNum">${fn:length(activeUser.following)}<br /> Following</a></li><li id="followers"><a href="#tab3_n">${fn:length(activeUser.followers)}<br /> Followers</a></li><li id="friends" ><a href="#tab4_n" id="friendNum"><br /> Friends</a></li></ul>
  </div>
 <!--   <div class="send-txt">
 <form action="${applicationScope.contextPath}/user/post" method="post">
  <textarea name="msg" id="msg" cols="" rows="" placeholder="Compose New Message..."></textarea>
  <input type="text" name="msg" value="Hello"/>
 <input name="latitude" id="latitude" type="hidden"/><input name="longitude" id="longitude" type="hidden"/>
  <input name="country" id="country" type="hidden"/><input name="city" id="city" type="hidden"/><input name="isShared" id="isShared" type="hidden" value="false"/><input name="isUserLocationOn" id="isUserLocationOn"  type="hidden" value="false"/>
  <input name="" type="button" class="gray-btn col" value="Send" onclick="postMsgUrl();" /> --><!--</form>--> <input name="" type="button" id="btnLoc" class="loc-btn col" value="" onClick="setUserLocationOnOff(this);"/>
	<span class="country" id="location_city"> </span> <input name="" type="button" class="img-btn" value="" /><!-- <span>150 characters only.</span> -->

 </div>
  </div>
</div>
<div class="main-content">
<div class="tab-wrap col">
<div id="tabs_container_n" class="col">
		<ul id="tabs_n">
			<li class="active up0" id="liMessage" onClick="onClickTabMessages(0,5);"><a href="#tab1_n">Messages</a></li>
			<li class="up1" id="liFollowings"><a href="#tab2_n">Following</a></li>
			<li class="up2" id="liFollowers"><a href="#tab3_n">Followers</a></li>
			<li class="up3" id="liFriends"><a href="#tab4_n">Friends</a></li>
			<li class="up4"><a href="#tab5_n">Group</a></li>
		</ul>
	</div>
<!--<input name="" type="button" value="AddFriend" onClick="addFriend();"/>-->
<div id="tabs_content_container_n" class="col">
		<div id="tab1_n" class="tab_content_n" style="display: block;">
<!-- 			<a href="${applicationScope.contextPath}/user/getMessagesUpdatesFromFriendsAndFollowing">Get Message Updates from Friends</a> -->
<!-- 			<input type="button" value="messages" onClick="getMessagesUpdatesFromFriendsAndFollowing();" />--> 
			<div class="tab1" id="tabMessages">       
			
            </div>
		</div>
		<div id="tab2_n" class="tab_content_n">
			<div class="tab1" id="tabFollowing">
            
            </div>
		</div>
		<div id="tab3_n" class="tab_content_n" >
			<div class="tab1" id="tabFollowers">
            
            </div>
		</div>
		<div id="tab4_n" class="tab_content_n">
			<div class="tab1" id="tabFriends">
            
            </div>
		</div>        
        <div id="tab5_n" class="tab_content_n">
			<div class="tab1">
            Under Construction
            </div>
		</div>
	</div>
    </div>


	<%@ include file="suggestions.jsp" %> 
	<%@ include file="trends.jsp" %> 
	<%@ include file="messages.jsp" %> 
</div>

<%@ include file="profile-popup.jsp" %> 
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
    
    
      <div class="noti-li-up pop-noti">
 <div class="noti-tit">Notification <span>10</span> <a class="right">See more</a></div>
   <ul>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"/> <p><a href="#">abc girl</a> provided some feedback on your design...
    <span>10 minutes ago</span></p>
    </li>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg"/> <p><a href="#">xyz boy</a> provided some feedback on your design...
    <span>10 minutes ago</span></p></li>
    <li class="last-li"><img src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg"/> <p><a href="#">pnb boy</a> provided some feedback on your design...
    <span>10 minutes ago</span></p></li>
   </ul>
   </div> 
   
   
   <div class="noti-li-frd pop-noti">
 <div class="noti-tit" id="friendRequestTab">Friend Request <!-- <span>10</span> --> <a class="right">See more</a></div>
  <%--  <ul>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"/> <p><a href="#">abc girl</a> send you friend request
    <a href="#" class="blue-btn">Accept</a>   <a href="#" class="blue-btn">Reject</a>  
    <span class="col">1 common friend</span></p>
    </li>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg"/> <p><a href="#">xyz boy</a> send you friend request
     <a href="#" class="blue-btn">Accept</a>   <a href="#" class="blue-btn">Reject</a>  
   </p></li>
    <li class="last-li"><img src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg"/> <p><a href="#">pnb boy</a> send you friend request
     <a href="#" class="blue-btn">Accept</a>   <a href="#" class="blue-btn">Reject</a>  
    <span class="col">13 common friend</span></p></li>
   </ul> --%>
   </div> 
   
   <div class="noti-li-msg pop-noti">
 <div class="noti-tit">Messages  <span>2</span> <a class="right">See more</a></div>
   <ul>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"/> <p><a href="#">abc girl</a><br />
  Hi, Whatss up...</p>
    </li>
    <li><img src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg"/> <p><a href="#">abc boy</a><br />
  when you will be free giv me call</p></li>
   
   </ul>
   </div> 
     
</body>
</html>
