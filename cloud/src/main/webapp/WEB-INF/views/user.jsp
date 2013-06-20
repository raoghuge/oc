<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib prefix="janrain" uri="http://janrain4j.googlecode.com/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph</title>
<link rel="shortcut icon" href="${applicationScope.contextPath}/resources/images/favicon.ico" />
<link rel="stylesheet" href="${applicationScope.contextPath}/resources/css/style.css" type="text/css" media="screen" />
<link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />  
<script type="text/javascript" src="${applicationScope.contextPath}/resources/js/jquery-1.9.1.js"></script>
<!-- <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script> -->
<script src="${applicationScope.contextPath}/resources/js/geo-min.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<!-- <script type="text/javascript" -->
<%-- 	src="${applicationScope.contextPath}/resources/js/jquery.js" --%>
<!-- 	language="javascript"></script> -->

<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/alertHandler.js"
	language="javascript"></script>

<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/chat.js"
	language="javascript"></script>

<script type="text/javascript">
	/* <![CDATA[ */
	var groupStartIndex = 0;
	var groupCount = 10;
	
	var chatNotifications = null;
	
	var mouse_is_inside = false;

	
	//var chatNotificationTrigger = setInterval('getChatNotifications()', 3000);
	//var chatRefreshTrigger;
	$(document)
			.ready(
					
					
					function() {
						
						$("img.edit-ic").click(function() {
							$(".twogrp input").addClass("add-bor");
							$(".twogrp input:first").focus();
						});
						$("a.cre-new").click(function() {
							$(".tab-group").css('display', 'none');
							$(".tab-creat-group").css('display', 'block');
						});

						$("a.member-clk").click(function() {
							$(".tab-group").css('display', 'none');
							$(".tab-creat-group").css('display', 'none');
							$(".prof-grp").css('display', 'block');
						});
						$("a.name-clk").click(function() {
							$(".prof-grp").css('display', 'none');
							$(".tab-creat-group").css('display', 'block');
						});

						//$(".table1 a").click(function() {
						//	$(".tab-creat-group").css('display', 'block');
						//});

						$("img.edit-combo").click(function() {
							$(".sel-com").css('display', 'block');
							$("a.sel-comb").css('display', 'none');
						});

						$('div.man-li-up').hide();
						$('div.noti-li-up').hide();
						$('div.noti-li-frd').hide();
						$('.noti-li-msg').hide();

						

						   
						$('a.noti-icon').click(
								function(e) {
									//  alert("hi");
									$(this).find("span").hide();
									$('div.noti-li-up').show("fast");
									$("div.noti-li-up").css('top', 47).css(
											'left', e.pageX - 160);
									//$('div.noti-li-up').toggle("fast");  
								});

						$('a.noti-user').click(
								function(e) {
									$(this).find("span").hide();
									$('div.noti-li-frd').show("fast");
									$("div.noti-li-frd").css('top', 47).css(
											'left', e.pageX - 160);
								});

// 						$('a.noti-msg').click(
// 								function(e) {
									
// 									$('div.noti-li-msg').show("fast");
// 									$("div.noti-li-msg").css('top', 47).css(
// 											'left', e.pageX - 160);
// 									showChatNotifications();
// 								});

						// Setting css of Message tab as block	
						$("#tab1_n").css('display', 'block');
						setUserLocationIcon();

						checkFriendRequest();
						setFriendsCount();

						var globalStart = 0;
						var globalPageSize = 2;
						var isScrollingFull = false;
						var whichDataIsBeingScrolled = "getMessagesUpdatesFromFriendsAndFollowing";

						getMessagesUpdatesFromFriendsAndFollowing(globalStart,
								globalPageSize, function(isScrollingFullArg) {
									isScrollingFull = isScrollingFullArg;
								});

						$(window)
								.scroll(
										function() {
											if ($(window).scrollTop() == $(
													document).height()
													- $(window).height()) {
												if (!isScrollingFull) {
													//$('#msgUpdates').append("<li id=\"loading\">Loading more..</li>");
													globalStart = globalStart + 1;

													if (whichDataIsBeingScrolled == "getMessagesUpdatesFromFriendsAndFollowing") {
														getMessagesUpdatesFromFriendsAndFollowing(
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													} else if (whichDataIsBeingScrolled == "getMessagesUpdatesFromFollowing") {
														getMessagesUpdatesFromFollowing(
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													} else if (whichDataIsBeingScrolled == "getMessagesUpdatesFromFollowers") {
														getMessagesUpdatesFromFollowers(
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													} else if (whichDataIsBeingScrolled == "getMessagesUpdatesFromFriends") {
														getMessagesUpdatesFromFriends(
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													} else if (whichDataIsBeingScrolled == "getOwnMessages") {
														getOwnMessages(
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													} else if (whichDataIsBeingScrolled == "searchMessages") {
														var criteria = $(
																"#search")
																.val();
														searchMessages(
																criteria,
																globalStart,
																globalPageSize,
																function(
																		isScrollingFullArg) {
																	isScrollingFull = isScrollingFullArg;
																});
													}
												}
											}
										});

						$("#liMessage")
								.click(
										function() { //tab Message when clicked
											globalStart = 0;
											isScrollingFull = false;
											whichDataIsBeingScrolled = "getMessagesUpdatesFromFriendsAndFollowing";
											getMessagesUpdatesFromFriendsAndFollowing(
													globalStart,
													globalPageSize,
													function(isScrollingFullArg) {
														isScrollingFull = isScrollingFullArg;
													});
										});

						$("#liFollowings")
								.click(
										function() {
											globalStart = 0;
											isScrollingFull = false;
											whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowing";
											getMessagesUpdatesFromFollowing(
													globalStart,
													globalPageSize,
													function(isScrollingFullArg) {
														isScrollingFull = isScrollingFullArg;
													});
										});

						$("#liFollowers")
								.click(
										function() {
											globalStart = 0;
											isScrollingFull = false;
											whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowers";
											getMessagesUpdatesFromFollowers(
													globalStart,
													globalPageSize,
													function(isScrollingFullArg) {
														isScrollingFull = isScrollingFullArg;
													});
										});

						$("#liFriends")
								.click(
										function() {
											globalStart = 0;
											isScrollingFull = false;
											whichDataIsBeingScrolled = "getMessagesUpdatesFromFriends";
											getMessagesUpdatesFromFriends(
													globalStart,
													globalPageSize,
													function(isScrollingFullArg) {
														isScrollingFull = isScrollingFullArg;
													});
										});

						$("#liGroups").click(function() {
							//$(".new-grp").css('display', 'none');

							globalStart = 0;
							isScrollingFull = false;
							whichDataIsBeingScrolled = "listGroups";
							listGroups();
						});

						var moveLeft = -50;
						var moveDown = 0;
						$('a.passinfo').click(
								function(e) {
									$('div.man-li-up').show();
									//   $('div.man-li-up').toggle("fast");  
									// 									$("div.man-li-up").css('top', e.pageY).css(
									// 											'left', e.pageX);
									$("div.man-li-up").css('position',
											"absolute").css('top', e.pageY)
											.css('left', e.pageX);
									//   $("div.man-li-up").css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);
								});
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

						$("#tabs_next li")
								.click(
										function() {
											//	First remove class "active" from currently active tab
											$(".man-li-up").hide();
											var index = $("#tabs_next li")
													.index(this);
											$("#tabs_n li").removeClass(
													'active');
											if (index == 0) {
												globalStart = 0;
												isScrollingFull = false;
												whichDataIsBeingScrolled = "getOwnMessages";
												getOwnMessages(
														globalStart,
														globalPageSize,
														function(
																isScrollingFullArg) {
															isScrollingFull = isScrollingFullArg;
														});
											} else if (index == 1) {
												globalStart = 0;
												isScrollingFull = false;
												whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowing";
												getMessagesUpdatesFromFollowing(
														globalStart,
														globalPageSize,
														function(
																isScrollingFullArg) {
															isScrollingFull = isScrollingFullArg;
														});
											} else if (index == 2) {
												globalStart = 0;
												isScrollingFull = false;
												whichDataIsBeingScrolled = "getMessagesUpdatesFromFollowers";
												getMessagesUpdatesFromFollowers(
														globalStart,
														globalPageSize,
														function(
																isScrollingFullArg) {
															isScrollingFull = isScrollingFullArg;
														});
											} else if (index == 3) {
												globalStart = 0;
												isScrollingFull = false;
												whichDataIsBeingScrolled = "getMessagesUpdatesFromFriends";
												getMessagesUpdatesFromFriends(
														globalStart,
														globalPageSize,
														function(
																isScrollingFullArg) {
															isScrollingFull = isScrollingFullArg;
														});
											} else if (index == 4) {
												globalStart = 0;
												isScrollingFull = false;
												whichDataIsBeingScrolled = "listGroups";
												listGroups();
											}
											//	Now add class "active" to the selected/clicked tab
											$("#tabs_n li" + ".up" + index)
													.addClass("active");
											//	Hide all tab content
											$(".tab_content_n").hide();
											//	Here we get the href value of the selected tab
											var selected_tab = $(this)
													.find("a").attr("href");
											//	Show the selected tab content
											$(selected_tab).fadeIn();
											//	At the end, we add return false so that the click on the link is not executed
											return false;
										});

						$(".hover").mouseover(function() {
							$(this).css('width', 84);
							$(this).val('Unfollow');
						}).mouseout(function() {
							$(this).val('Following');
						});

						$("#search")
								.bind(
										'keyup',
										function() {
											if ($("#search").val() != "") {
												var criteria = $("#search")
														.val();
												if (criteria.length > 1) {
													globalStart = 0;
													isScrollingFull = false;
													whichDataIsBeingScrolled = "searchMessages";
													searchMessages(
															criteria,
															globalStart,
															globalPageSize,
															function(
																	isScrollingFullArg) {
																isScrollingFull = isScrollingFullArg;
															});
												}
											}
										});

						$("#msg")
								.bind(
										'keyup',
										function(event) {

											if ($("#msg").val() != "") {
												var msgVal = $("#msg").val();

												if (event.keyCode == 32) {
													var patt = /http:/g;
													if (patt.test(msgVal) == true) {
														var urlRegex = /(https?:\/\/[^\s]+)/g;
														msgVal
																.replace(
																		urlRegex,
																		function(
																				shorturl) {

																			$
																					.ajax({
																						type : "GET",
																						url : "${applicationScope.URLShortner}/url/shorten",
																						data : {
																							url : shorturl
																						},
																						success : function(
																								data) {
																							shorturl = shorturl
																									.replace(
																											shorturl,
																											data);
																							msgVal = msgVal
																									.replace(
																											urlRegex,
																											shorturl);
																							$(
																									"#msg")
																									.val(
																											msgVal);
																							//$("#msg").val("<a onclick='expand(\""+msgVal+"\")'>"+msgVal+"</a>");
																						},
																						error : function(
																								e) {
																							console
																									.log(e);
																							return false;
																						}
																					});

																		});
													}
												}
											}
										});

						$(".hover").mouseover(function() {
							$(this).css('width', 84);
							$(this).val('Unfollow');
						}).mouseout(function() {
							$(this).val('Following');
						});

					});

	$(".gray-btn col").click(function() {

		var msgVal = $("#msg").val();
		//alert(msgVal);
		if (msgVal && !msgVal.match(/^http([s]?):\/\/.*/)) {
			input.val('http://' + val);
			//alert(msgVal);
		}
	});

	function searchMessages(criteria, startIndex, pageSize, callback) {
		//alert('in searchMessage' + startIndex + ", " + pageSize);
		$
				.ajax({
					type : "GET",
					url : "${applicationScope.contextPath}/user/searchMessages",
					data : {
						criteria : criteria,
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(response) {
						if (response == "notfound") {
							//alert("not found");			
						} else {
							var messages = "";
							if (startIndex == 0) {
								messages = messages + "<ul id='msgUpdates'>";
							}
							for ( var i = 0; i < response.length; i++) {

								messages = messages
										+ "<li><img src='" +  response[i].profilePhoto + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
										+ response[i].username
										+ "\");'>"
										+ response[i].displayName
										+ "</a></span> @"
										+ response[i].username
										+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" />";
								messages = messages
										+ "<p>"
										+ getMessageFormatted(response[i].message)
										+ "</p>";
								messages = messages + "<p><br>"
										+ response[i].when + "</p></div>";
								messages = messages + "</li>";

							}
							if (startIndex == 0) {
								messages = messages + "</ul>";
								$('#tabMessages').html(messages);
							} else {
								$('#msgUpdates').append(messages);
							}

							if (data.length < pageSize) {
								callback(true);
							} else {
								callback(false);
							}
						}

					},
					error : function(e) {
						console.log(e);

						return false;
					}
				});
	}

	function setFriendsCount() {
		//alert('in setFriendsCount');
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/user/getCounts',
			success : function(data) {
				$("#friendNum").html(data.friendsLength + " <br /> Friends");
			}
		});
	}

	function checkFriendRequest() {
		//alert('in checkFriendRequest');
		$
				.ajax({
					type : 'POST',
					url : '${applicationScope.contextPath}/user/checkFriendRequest',
					success : function(data) {
						if (data.length > 0) {
							$(".noti-user")
									.html(
											"<img src=\"${applicationScope.contextPath}/resources/images/noti-user.jpg\" /><span>"
													+ data.length + "</span>");
							$("#friendRequestTab")
									.html(
											"Friend Request <span>"
													+ data.length
													+ "</span> <a class=\"right\">See more</a>");

							var friendRequestHtml = "<ul>";
							for ( var index = 0; index < data.length; index++) {
								friendRequestHtml = friendRequestHtml
										+ "<li><img height=\"40\" width=\"40\" src=\""+data[index].photoUrl+"\">";
								friendRequestHtml = friendRequestHtml + "<p>";
								friendRequestHtml = friendRequestHtml
										+ "<a href=\"#\">"
										+ data[index].displayName
										+ "</a> send you friend request";

								friendRequestHtml = friendRequestHtml
										+ "<a class=\"blue-btn\" href=\"javascript:approveFriendRequest('${activeUser.username}','"
										+ data[index].username
										+ "')\">Accept</a><a class=\"blue-btn\" href=\"javascript:rejectFriendRequest('${activeUser.username}','"
										+ data[index].username
										+ "')\">Reject</a>";
								friendRequestHtml = friendRequestHtml
										+ "</p></li>";
							}
							friendRequestHtml = friendRequestHtml + "</ul>";
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
							mouse_is_inside = true;

						} else {
							$(".noti-user")
									.html(
											"<img src=\"${applicationScope.contextPath}/resources/images/noti-user.jpg\" />");
							$("#friendRequestTab")
									.html(
											"Friend Request  <a class=\"right\">See more</a><ul><li>No New Friend Request</li></ul>");
						}
						//alert(data.length);
						//showAlert("You are now friend of @"+user);
						//	$("#friendNum").html(data.friendCount).append("<br /> Friends</a>");
					}
				});
	}

	function approveFriendRequest(userName, friendName) {
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/user/approveFriendRequest',
			data : {
				friendName : friendName,
				myName : userName
			},
			success : function(data) {
				showAlert("You are now friend of @" + friendName);
				setFriendsCount();
				checkFriendRequest();
			}
		});

	}

	function rejectFriendRequest(userName, friendName) {
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/user/rejectFriendRequest',
			data : {
				friendName : friendName,
				myName : userName
			},
			success : function(data) {
			}
		});
	}

	function addFriend(user, index) {

		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/user/addFriend',

			data : {
				friendUsername : user
			},

			success : function(data) {
				showAlert("You are now friend of @" + user);
				/* 	$("#friendNum").html(data.friendCount).append("<br /> Friends</a>"); */
				setFriendsCount();
			}
		});
	}
	function postMsgUrl() {
		var msgVal = $("#msg").val();
		var patt = /http:/g;
		if (patt.test(msgVal) == true) {
			var urlRegex = /(https?:\/\/[^\s]+)/g;
			msgVal.replace(urlRegex, function(shorturl) {

				$.ajax({
					type : "GET",
					url : "${applicationScope.URLShortner}/url/shorten",
					data : {
						url : shorturl
					},
					success : function(data) {
						shorturl = shorturl.replace(shorturl, data);
						msgVal = msgVal.replace(urlRegex, shorturl);
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

		else {
			postMessage();
		}
	}

	function setUserLocation() {
		var isUserLocationOn = $("#isUserLocationOn").val();
		var latVal = $("#latitude").val();
		var lonVal = $("#longitude").val();
		var countryVal = $("#country").val();
		var cityVal = $("#city").val();

		if (isUserLocationOn == true) {
			//alert("in condition");
			$.ajax({
				type : 'GET',
				url : '${applicationScope.contextPath}/user/setUserLocation',
				data : {
					latitude : latVal,
					longitude : lonVal,
					country : countryVal,
					city : cityVal
				},
				success : function(response) {
					//alert("Done");
				}
			});
		}
	}

	function postMessage() {
		var msgVal = $("#msg").val();
		var latVal = $("#latitude").val();
		var lonVal = $("#longitude").val();
		var countryVal = $("#country").val();
		var cityVal = $("#city").val();
		var isSharedVal = $("#isShared").val();
		var isUserLocationOn = $("#isUserLocationOn").val();

		//alert(msgVal + cityVal + " " + countryVal + " " + latVal + lonVal + isSharedVal + isUserLocationOn);
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/user/post',
			data : {
				msg : msgVal,
				latitude : latVal,
				longitude : lonVal,
				country : countryVal,
				city : cityVal,
				isShared : isSharedVal,
				isUserLocationOn : isUserLocationOn
			},
			success : function(data) {
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

		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getTweets',
					data : {
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(data) {

						var messages = "";
						if (startIndex == 0) {
							messages = messages + "<ul id='msgUpdates'>";
						}
						for ( var i = 0; i < data.length; i++) {

							var id = data[i].key; //startIndex + "-" + i;
							messages = messages
									+ "<li id=\"" + id + "\"><img src='" +  data[i].profilePhoto + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
									+ data[i].username
									+ "\");'>"
									+ data[i].displayName
									+ "</a></span> @"
									+ data[i].username
									+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /><a onclick='deleteMessage(\""
									+ data[i].message + "\",\"" + data[i].key
									+ "\");'>Delete</a>";
							messages = messages + "<p>"
									+ getMessageFormatted(data[i].message)
									+ "</p>";
							messages = messages + "<p><br>" + data[i].when
									+ "</p></div>";
							messages = messages + "</li>";

						}
						//getTrends();
						if (startIndex == 0) {
							messages = messages + "</ul>";
							$('#tabMessages').html(messages);
						} else {
							$('#msgUpdates').append(messages);
						}

						if (data.length < pageSize) {
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
		getMessagesUpdatesFromFriendsAndFollowing(globalStart, globalPageSize,
				function(isScrollingFullArg) {
					isScrollingFull = isScrollingFullArg;
				});
	}

	function deleteChatMessage(chatId, chatUser) {
		//alert(chatId);
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/chat/deleteChatMessage',
			data : {
				otherUser : chatUser,
				messageId : chatId
			},
			success : function(data) {
				//alert("delete success");
				refreshChatMessages(chatUser);
			}
		});
	}

	function getOlderChatMessages(chatUser, index) {

		//alert("11==="+d.getTime());
		var chatType = "Todays";
		if (index == 1) {
			chatType = "OneDay";
		} else if (index == 2) {
			chatType = "OneWeek";
		} else if (index == 3) {
			chatType = "OneMonth";
		} else if (index == 4) {
			chatType = "SixMonths";
		} else if (index == 5) {
			chatType = "AllOld";
		}
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/chat/getPreviousMessagesByType',
					data : {
						otherUser : chatUser,
						type : chatType,
					},
					success : function(data) {
						
						//var userMessages = allChatMessages[chatUser]["data"];
						var msgs = data;
						//alert(msgs.length);

						if (allChatMessages[chatUser]["toTime"] == undefined) {
							allChatMessages[chatUser]["toTime"] = 0;
							allChatMessages[chatUser]["fromTime"] = new Date()
									.getTime() + 24 * 60 * 60;
							allChatMessages[chatUser]["data"] = {};

						}
						allChatMessages[chatUser]["index"] = index;
						{
							var contents = "";
							contents = contents
									+ "<div class='chat-prev' id='chatPrev_"+chatUser+"'>";
							if (index <= 0) {
								contents = contents
										+ "<a href='javascript:;' onclick='getOlderChatMessages(\""
										+ chatUser + "\",1);'>Yesterday</a>";
							}
							if (index <= 1) {
								contents = contents
										+ "<a href='javascript:;' onclick='getOlderChatMessages(\""
										+ chatUser + "\",2);''>1 week</a>";
							}
							if (index <= 2) {
								contents = contents
										+ "<a href='javascript:;' onclick='getOlderChatMessages(\""
										+ chatUser + "\",3);'>1 month</a>";
							}
							if (index <= 3) {
								contents = contents
										+ "<a href='javascript:;' onclick='getOlderChatMessages(\""
										+ chatUser + "\",4);'>6 months</a>";
							}
							if (index <= 4) {
								contents = contents
										+ "<a href='javascript:;' onclick='getOlderChatMessages(\""
										+ chatUser + "\",5);'>All</a>";
							}
							contents = contents + "</div>";
							var chatPrevId = "#chatPrev_" + chatUser;
							$(chatPrevId).html(contents);
							//alert("Prev "+contents);
							contents = "";

							var thisUser = "${activeUser.username}";
							var chatContentId = "#chat_content_" + chatUser;

							for ( var i = msgs.length - 1; i >= 0; i -= 1) {
								var contents2 = "";

								if (allChatMessages[chatUser]["fromTime"] < msgs[i].date) {
									allChatMessages[chatUser]["data"].splice(0,
											0, msgs[i]);
									allChatMessages[chatUser]["fromTime"] = msgs[i].date;
									if (startIndex < 0) {
										startIndex = i;
									}
									allChatMessages[chatUser]["toTime"] = msgs[i].date;
									contents2 = contents2
											+ "<div class='chat-message'>";
									contents2 = contents2
											+ "<div class='chat-person'>"
											+ allChatMessages[chatUser]["data"][i].from
											+ ":</div>";
									contents2 = contents2
											+ "<div class='chat-msg'>"
											+ allChatMessages[chatUser]["data"][i].message
											+ "<br/>"
											+ allChatMessages[chatUser]["data"][i].fromWhen
											+ "</div>";

									if (thisUser == allChatMessages[chatUser]["data"][i].from) {
										contents2 = contents2
												+ "<div><span class='close_chat1' onclick='deleteChatMessage(\""
												+ allChatMessages[chatUser]["data"][i].id
												+ "\",\"" + chatUser
												+ "\");'>X</span></div>";
									}
									contents2 = contents2 + "</div>";
									$(chatContentId).prepend(contents2);

								}

							}
						}
					},
					error : function(errordata) {
						//alert(errordata);
					}
				});
	}
	
	function refreshChatMessages(chatUser) {
		//alert("11==="+d.getTime());
		var chatType = "Todays";
		var index = allChatMessages[chatUser]["index"];
		if (index == 1) {
			chatType = "OneDay";
		} else if (index == 2) {
			chatType = "OneWeek";
		} else if (index == 3) {
			chatType = "OneMonth";
		} else if (index == 4) {
			chatType = "SixMonths";
		} else if (index == 5) {
			chatType = "AllOld";
		}
		$.ajax({
				type : 'GET',
				url : '${applicationScope.contextPath}/chat/getPreviousMessagesByType',
				data : {
					otherUser : chatUser,
					type : chatType,
				},
				success : function(data) {
					//var userMessages = allChatMessages[chatUser]["data"];
					var msgs = data;

					if (allChatMessages[chatUser]["toTime"] == undefined) {
						allChatMessages[chatUser]["toTime"] = 0;
						allChatMessages[chatUser]["fromTime"] = new Date()
								.getTime() + 24 * 60 * 60;
						allChatMessages[chatUser]["data"] = {};

					}
					if (index > 0) {

					}

					var thisUser = "${activeUser.username}";
					var chatContentId = "#chat_content_" + chatUser;
					$(chatContentId).html("");
					for ( var i = 0; i < msgs.length; i += 1) {
						var contents1 = "";
							allChatMessages[chatUser]["data"][i] = msgs[i];
							allChatMessages[chatUser]["toTime"] = msgs[i].date;
							contents1 = contents1
									+ "<div class='chat-message'>";
							contents1 = contents1
									+ "<div class='chat-person'>"
									+ allChatMessages[chatUser]["data"][i].from
									+ ":</div>";
							contents1 = contents1
									+  "<div class='chat-msg'>";
							if(allChatMessages[chatUser]["data"][i].message == undefined) {
								contents1 = contents1 + "--- Message Removed ---";
							} else {				
								contents1 = contents1+ allChatMessages[chatUser]["data"][i].message;
							}
									
							contents1 = contents1		
									+ "<br/>"
									+ allChatMessages[chatUser]["data"][i].fromWhen
									+ "</div>";
							
							if (thisUser == allChatMessages[chatUser]["data"][i].from 
									&& allChatMessages[chatUser]["data"][i].message != undefined) {
								//alert(allChatMessages[chatUser]["data"][i].id);
								contents1 = contents1
										+ "<div><span class='close_chat1' onclick='deleteChatMessage(\""
										+ allChatMessages[chatUser]["data"][i].id
										+ "\",\"" + chatUser
										+ "\");'>X</span></div>";
							}
							contents1 = contents1 + "</div>";
							$(chatContentId).append(contents1);
						

					}
				},
				error : function(errordata) {
					//alert(errordata);
				}
			});
	}

	function getChatMessages(chatUser, index) {

		//alert("11==="+d.getTime());
		var chatType = "Todays";
		if (index == 1) {
			chatType = "OneDay";
		} else if (index == 2) {
			chatType = "OneWeek";
		} else if (index == 3) {
			chatType = "OneMonth";
		} else if (index == 4) {
			chatType = "SixMonths";
		} else if (index == 5) {
			chatType = "AllOld";
		}
		$.ajax({
				type : 'GET',
				url : '${applicationScope.contextPath}/chat/getPreviousMessagesByType',
				data : {
					otherUser : chatUser,
					type : chatType,
				},
				success : function(data) {
					//var userMessages = allChatMessages[chatUser]["data"];
					var msgs = data;

					if (allChatMessages[chatUser]["toTime"] == undefined) {
						allChatMessages[chatUser]["toTime"] = 0;
						allChatMessages[chatUser]["fromTime"] = new Date()
								.getTime() + 24 * 60 * 60;
						allChatMessages[chatUser]["data"] = {};

					}
					if (index > 0) {

					}

					var thisUser = "${activeUser.username}";
					var chatContentId = "#chat_content_" + chatUser;

					for ( var i = 0; i < msgs.length; i += 1) {
						var contents1 = "";
						if (allChatMessages[chatUser]["toTime"] < msgs[i].date) {
							allChatMessages[chatUser]["data"][i] = msgs[i];
							allChatMessages[chatUser]["toTime"] = msgs[i].date;
							contents1 = contents1
									+ "<div class='chat-message'>";
							contents1 = contents1
									+ "<div class='chat-person'>"
									+ allChatMessages[chatUser]["data"][i].from
									+ ":</div>";
							contents1 = contents1
									+ "<div class='chat-msg'>"
									+ allChatMessages[chatUser]["data"][i].message
									+ "<br/>"
									+ allChatMessages[chatUser]["data"][i].fromWhen
									+ "</div>";

							if (thisUser == allChatMessages[chatUser]["data"][i].from
									&& allChatMessages[chatUser]["data"][i].message != undefined) {
								//alert(allChatMessages[chatUser]["data"][i].id);
								contents1 = contents1
										+ "<div><span class='close_chat1' onclick='deleteChatMessage(\""
										+ allChatMessages[chatUser]["data"][i].id
										+ "\",\"" + chatUser
										+ "\");'>X</span></div>";
							}
							contents1 = contents1 + "</div>";
							$(chatContentId).append(contents1);
						}

					}
				},
				error : function(errordata) {
					//alert(errordata);
				}
			});
	}

	function sendChatMessage(toUser, msg) {
		//alert('in chat');

		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/chat/sendChatMessage',
			data : {
				otherUser : toUser,
				message : msg
			},
			success : function(data) {
				//alert("send success");
				var msgId = "#send_msg_" + toUser;
				$(msgId).val("");
				refreshChatMessages(toUser);
				//alert(data);
				//for ( var i = 0; i < data.length; i++) {
				//showAlert("Messages "+i+" from "+data[i].fromUser+" is "+data[i].message);
				//}
			}
		});
	}
	
	function showChatNotifications(e) {
		$('div.noti-li-frd').hide();
		$("#chat-notifications-all").show();
		$("#chat-notifications-all").css('display', "block");
		
		if(e != undefined) {
		$("#chat-notifications-all").css('top', 47).css(
					'left', e.pageX - 160);
		}
			
		if(chatNotifications.length>0) {
			//$('chat-notifications-all').css('display', "block");
			
				$(".pop-noti").css('display', "block");
			
				
			//$("div.noti-li-msg").show();
// 			$("#chat-notifications-all").show("fast");
// 			$("#chat-notifications").css('top', 47).css(
// 					'left', e.pageX - 160);
			$("#chat-notifications")
					.html(
							"Recent Chats <span>"
									+ chatNotifications.length
									+ "</span> <a class=\"right\">See more</a>");

			var chatHtml = "<ul>";
			for ( var index = 0; index < chatNotifications.length; index++) {
				var otherChatUsers = chatNotifications[index];
				//alert("users="+otherChatUsers[0]);
				chatHtml = chatHtml	+ "<li><div><a href='javascript:;' onclick='openChatWindow(\""
				+ otherChatUsers[0] + "\");'>"+otherChatUsers[0]+"</a><span class='right'  onclick='removeChatNotification(\""
				+ otherChatUsers[0]
				+ "\");'>X</span></div></li>";

				
			}
			chatHtml = chatHtml + "</ul>";
			$("#chat-notifications-all ul").remove();
			$("#chat-notifications-all").append(chatHtml);
	
	
		} else {
			$("#chat-notifications")
			.html("No recent chats");
			$("#chat-notifications-all ul").remove();
		}
		mouse_is_inside = true;
	}
//setRecentVisit

	function removeChatNotification(chatUser) {
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/chat/setRecentVisit',
			data : {
				otherUser : chatUser,
			},
			success : function(data) {
				getChatNotifications();
			}
		});
	}
	
	
	function getChatNotifications() {
		$.ajax({
			type : 'GET',
			url : '${applicationScope.contextPath}/chat/getRecentChats',
			success : function(data) {
				chatNotifications = data;
				if(chatNotifications.length > 0) {
					$(".noti-msg")
					.html(
							"<img src=\"${applicationScope.contextPath}/resources/images/noti-msg.jpg\" /><span>"
									+ chatNotifications.length + "</span>");
				} else {
					$(".noti-msg")
					.html(
							"<img src=\"${applicationScope.contextPath}/resources/images/noti-msg.jpg\" />");
				} 
				
			}
		});
	}
	
	

	function getMessagesUpdatesFromFriendsAndFollowing(startIndex, pageSize,
			callback) {
		//alert('in friends and followings');
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getMessagesUpdatesFromFriendsAndFollowing',
					data : {
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(data) {
						var messages = "";
						if (startIndex == 0) {
							messages = messages + "<ul id='msgUpdates'>";
						}
						for ( var i = 0; i < data.length; i += 1) {
							//alert(data[i].username + data[i].displayName + data[i].userPhotoUrl);
							var relation = "";
							if (data[i].relType == null) {
								relation = "Following";
							} else if (data[i].relType == "org.socialgraph.domain.Friend") {
								relation = "Friend";
							}

							messages = messages
									+ "<li><img src='" + data[i].userPhotoUrl + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
									+ data[i].username
									+ "\");'>"
									+ data[i].displayName
									+ "</a></span> "
									+ data[i].username
									+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /><a onclick='shareMessage(\""
									+ data[i].key + "\");'>Share</a>";

							messages = messages + "<p>"
									+ getMessageFormatted(data[i].message)
									+ "</p>";
							messages = messages + "<p><br>" + data[i].when
									+ "</p></div>";
							messages = messages + "</li>";
						}

						if (startIndex == 0) {
							messages = messages + "</ul>";
							$('#tabMessages').html(messages);
						} else {
							$('#msgUpdates').append(messages);
						}

						if (data.length < pageSize) {
							callback(true);
						} else {
							callback(false);
						}
					}
				});
	}

	function showChatPopUp(e, chatUser) {
		//var e = window.event;
		$(".man-li-up").show();
		$(".man-li-up").css('display', "block");
		$(".man-li-up").css('top', e.pageY).css('left', e.pageX);
		var contents = "<ul>";
		contents = contents + "<li><a href='#' onclick='openChatWindow(\""
				+ chatUser + "\")'>Chat to @" + chatUser + "</a></li>";
		contents = contents + "<li><a href='#' onclick='removeUserFromList(\""
				+ chatUser + "\")'>Remove from the list</a></li>";
		contents = contents + "<li><a href='#' onclick='blockChat(\""
				+ chatUser + "\")'>Block @" + chatUser + "</a></li>";
		contents = contents + "</ul>";
		$(".man-li-up").html(contents);
		mouse_is_inside = true;
	}
	
	function closeChatNotifications() {
		$('##chat-notifications-all').hide();
	}

	function openChatWindow(chatUser) {
		removeChatNotification(chatUser);
		
		$(".man-li-up").css('display', "none");
		
		var chatWindowId = "#chat-container_"+chatUser;
		//$(chatWindowId).remove();
		
		if ($(chatWindowId).length == 0) {
    
		var contents = "<div class='draggable_chat' id='chat-container_"+chatUser+"' style='float:left; margin-left: 100px;position:fixed;' >";
		contents = contents
				+ "<div class='chat' id='chat_"+chatUser+"' style='display:block;'>";
		contents = contents + "<div class='tit-chat' id='chatH_"+chatUser+"'>";
		contents = contents + chatUser;
		contents = contents
				+ "<span class='close_chat' onclick='closeChatWindow(\""
				+ chatUser + "\");'>X</span>";
		//contents = contents + "<a onclick='closeChatWindow(\""+chatUser+"\");' ></a>";
		contents = contents + "</div>";
		contents = contents
				+ "<div class='chat-prev' id='chatPrev_"+chatUser+"'>";
		contents = contents
				+ "<a href='javascript:;'><u>Yesterday</u></a> <a href='javascript:;'><u>7 days</u></a> <a href='javascript:;'><u>1 month</u></a> <a href='javascript:;'><u>6 months</u></a>";
		contents = contents + "</div>";
		contents = contents
				+ "<div class='chat-content' id='chat_content_"+chatUser+"'>";

		contents = contents + "</div>";
		contents = contents
				+ "<textarea name='' type='text' id='send_msg_"+chatUser+"'></textarea>";
		contents = contents + "</div></div>";
		
		//alert(msgId);
		$("#chat-windows").append(contents);
// 		alert($(chatWindowId).html());
		} else {
			$(chatWindowId).css('display', 'block');
		}
		var msgId = "#send_msg_" + chatUser;
		
		$(function() {
			$('.draggable_chat').draggable();
	    	//$( "#draggable" ).draggable();
	  	});
		contents = "";
		
		var index = 0;
		if(allChatMessages[chatUser] == undefined) {
			allChatMessages[chatUser] = {};
		} else {
			index = allChatMessages[chatUser]["index"];
		}
		if (index == undefined) {
			index = 0;
			allChatMessages[chatUser]["index"]=0;
		}
		//alert("openChatWindow index "+index);
		
		getOlderChatMessages(chatUser, index);

		
		$(msgId).keypress(function(e) {
			if (e.keyCode == 13) {
				sendChatMessage(chatUser, this.value);
				e.preventDefault();
			}
		});
		var chatFunc = "refreshChatMessages(\"" + chatUser + "\")";//"getChatMessages(\"" + chatUser + "\", -1)";
		setInterval(chatFunc, 5000);
		
		
	}

	function closeChatWindow(chatUser) {
		var chatWindowId = "#chat-container_"+chatUser;
		//$(chatWindowId).remove();
		$(chatWindowId).css('display', 'none');
		
	}

	function getMessagesUpdatesFromFollowing(startIndex, pageSize, callback) {

		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getUpdatesFromFollowing',
					data : {
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(data) {
						var messages = "";
						if (startIndex == 0) {
							messages = messages + "<ul id='ulFollowing'>";
						}
						for ( var i = 0; i < data.length; i += 1) {

							messages = messages
									+ "<li><img src=\"" + data[i].userPhotoUrl + "\" />";
							messages = messages
									+ "<div class=\"col prof-li\"><span class=\"tit-sml\">";
							messages = messages + "<a onclick='profile_pop(\""
									+ data[i].username + "\");'>"
							messages = messages
									+ data[i].displayName
									+ "</a></span>"
									+ data[i].username
									+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> "
									+ "<span class=\"right\"><a href=\"javascript:;\" onclick='showChatPopUp(event,\""
									+ data[i].username
									+ "\");' class=\"passinfo col\">"
									+ "<img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" />"
									+ "</a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Following\"  /></span>";
							messages = messages + "<p class=\"small-p\">"
									+ getMessageFormatted(data[i].message)
									+ "</p></div>";
							messages = messages + "</li>";
						}

						if (startIndex == 0) {
							messages = messages + "</ul>";
							$('#tabFollowing').html(messages);
						} else {
							$('#ulFollowing').append(messages);
						}

						if (data.length < pageSize) {
							callback(true);
						} else {
							callback(false);
						}
					}
				});
	}

	function getMessagesUpdatesFromFollowers(startIndex, pageSize, callback) {
		//alert('followers');
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getUpdatesFromFollowers',
					data : {
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(data) {
						var messages = "";
						if (startIndex == 0) {
							messages = messages + "<ul id='ulFollowers'>";
						}
						for ( var i = 0; i < data.length; i += 1) {
							messages = messages
									+ "<li><img src=\"" + data[i].userPhotoUrl + "\" />";
							messages = messages
									+ "<div class=\"col prof-li\"><span class=\"tit-sml\">";
							messages = messages + "<a onclick='profile_pop(\""
									+ data[i].username + "\");'>"
							messages = messages
									+ data[i].displayName
									+ "</a></span>"
									+ data[i].username
									+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> "
									+ "<span class=\"right\"><a href=\"javascript:;\" onclick='showChatPopUp(event,\""
									+ data[i].username
									+ "\");' class=\"passinfo col\">"
									+ "<img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" />"
									+ "</a><input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Follow\"  /></span>";
							messages = messages + "<p class=\"small-p\">"
									+ getMessageFormatted(data[i].message)
									+ "</p></div>";
							messages = messages + "</li>";
						}
						if (startIndex == 0) {
							messages = messages + "</ul>";
							$('#tabFollowers').html(messages);
						} else {
							$('#ulFollowers').append(messages);
						}

						if (data.length < pageSize) {
							callback(true);
						} else {
							callback(false);
						}
					}
				});
	}

	function getMessagesUpdatesFromFriends(startIndex, pageSize, callback) {
		//alert('Friends');
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getUpdatesFromFriends',
					data : {
						startIndex : startIndex,
						pageSize : pageSize
					},
					success : function(data) {
						//alert(data);
						var messages = "";
						if (startIndex == 0) {
							messages = messages + "<ul id='ulFriends'>";
						}
						for ( var i = 0; i < data.length; i += 1) {
							//alert('in loop');
							messages = messages
									+ "<li><img src=\"" + data[i].userPhotoUrl + "\" /><div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='profile_pop(\""
									+ data[i].username
									+ "\");'>"
									+ data[i].displayName
									+ "</a></span>"
									+ data[i].username
									+ "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> <span class=\"right\"><a onclick='showChatPopUp(event,\""
									+ data[i].username
									+ "\");' class=\"passinfo col\"><img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" /></a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Unfriend\"  /></span>";

							messages = messages + "<p class=\"small-p\">"
									+ getMessageFormatted(data[i].message)
									+ "</p></div>";
							messages = messages + "</li>";

							//messages = messages + "<li><img src=\"${applicationScope.contextPath}/resources/images/thumb_girl.jpg\" /><div class=\"col prof-li\"><span class=\"tit-sml\"><a href=\"javascript:profile_pop()\">JYOTI PATIL</a></span> @napasninja <img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> <span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\"><img src=\"${applicationScope.contextPath}/resources/images/man-icon.jpg\" /></a> <input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"Following\"  /></span>";
							//messages = messages + "<p class=\"small-p\">hey hi m icwa final student I am simple n sweet my frnds say that.... and I love my family</p></div>";
							//messages = messages + "</li>";
						}
						if (startIndex == 0) {
							messages = messages + "</ul>";
							$('#tabFriends').html(messages);
						} else {
							$('#ulFriends').append(messages);
						}

						if (data.length < pageSize) {
							callback(true);
						} else {
							callback(false);
						}
					}
				});
	}

	function deleteMessage(strMessage, key) {
		//alert('in delete');
		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/user/deleteMessage',
			data : {
				message : strMessage,
				key : key
			},
			success : function(data) {
				$("#messageCount").html(data.messageCount);
				showAlert("Message deleted !!!");
				$('#' + key).remove();
			}
		});
	}

	function shareMessage(key) {
		//alert('in share');
		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/user/shareMessage',
			data : {
				key : key
			},
			success : function(data) {
				$("#messageCount").html(data.messageCount);
				showAlert("Message shared !!!");
			}
		});
	}

	function setUserLocationOnOff(button) {
		$
				.ajax({
					type : 'POST',
					url : '${applicationScope.contextPath}/user/setUserLocationOnOff',
					success : function(data) {
						//alert('set to ' + data);//Set hidden field to blank
						if (data == false) {
							button.style.backgroundImage = "url(${applicationScope.contextPath}/resources/images/nolocation.png)";
							document.getElementById('location_city').innerHTML = "";

							document.getElementById('latitude').value = "";
							document.getElementById('longitude').value = "";
							document.getElementById('city').value = "";
							document.getElementById('country').value = "";
							document.getElementById('isUserLocationOn').value = false;
						} else {

							button.style.backgroundImage = "url(${applicationScope.contextPath}/resources/images/location.png)";
							document.getElementById('isUserLocationOn').value = true;
							if (geo_position_js.init()) {
								geo_position_js.getCurrentPosition(
										success_callback, error_callback, {
											enableHighAccuracy : true
										});
								geocoder = new google.maps.Geocoder();
							} else {
								//alert("Functionality not available");
							}
							setUserLocation();
						}

					}
				});

	}
	
	/* ]]> */
</script>
<script language="javascript" type="text/javascript">
	function caption() {
		$('#caption').css('display', 'block');
	}
	function clearCaption() {
		$('#caption').css('display', 'none');
	}
	function open_pop() {
		$('#form1-pop').css('display', 'block');
	}
	function close_pop() {
		$('#form1-pop').css('display', 'none');
	}

	function addChatMessages() {

	}

	function openChatwindow() {
		day = new Date();
		id = day.getTime();
		windowCol[id] = window
				.open(
						URL,
						id,
						'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=600,height=800,left = 650,top = 250');

	}

	function showMembers(groupId) {
		// 		$('.tab-creat-group').css('display', 'none');
		// 		$('.tab-group').css('display', 'none');
		// 		$(".prof-grp").css('display', 'block');
	}

	function showGroup(groupId) {
		// 		$('.tab-creat-group').css('display', 'block');
		// 		$('.tab-group').css('display', 'none');
		// 		$(".prof-grp").css('display', 'none');

		$('.tab-creat-group').css('display', 'block');
		//alert(groupId);
	}
	function listGroups() {
		// 		$('.tab-creat-group').css('display', 'none');
		// 		$('.tab-group').css('display', 'block');
		// 		$(".prof-grp").css('display', 'none');
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/group/listGroups',
					error : function(error) {
						alert("Error: " + error);
					},
					success : function(data) {
						//alert(data);
						var res = data.response;
						if (res.length > 0) {
							var groupButton = "<a href='javascript:showGroup("
									+ "-1"
									+ ");' class='cre-new blue-btn'><strong>Create New Group</strong></a>";
							var groupTable = "<table border='0' cellspacing='0' cellpadding='10' width='100%' class='table1'><tbody></tbody></table>";
							var tableContent = "<tr><th>My Group</th><th>Visibility</th><th>Members</th><th>Owner</th></tr>";
							$('#groupButtonDiv').html(groupButton);
							$('#groupTableDiv').html(groupTable);
							$('#groupTableDiv table tbody')
									.append(tableContent);
							var tableRow;
							for ( var i = 0; i < res.length; i++) {
								tableRow = "<tr><td><a href='javascript:;' onclick='showGroup("
										+ res[i].nodeId
										+ ");' class='name-clk'>"
										+ res[i].name
										+ "</a></td>";
								tableRow = tableRow
										+ "<td><a href='javascript:;'>"
										+ res[i].type + "</a></td>";
								tableRow = tableRow
										+ "<td><a href='javascript:showMembers("
										+ res[i].nodeId
										+ ");' class='member-clk'>"
										+ (res[i].admins.length + res[i].users.length)
										+ " members</a></td>";
								tableRow = tableRow
										+ "<td><a href='javascript:;'>"
										+ res[i].admins[0] + "</a></td></tr>";
								$('#groupTableDiv table tbody')
										.append(tableRow);
							}
							var pagingContent = "<div class='pagination-grp'><span>next</span><span>2</span><span>1</span><span>prev</span></div>";
							$('#groupTableDiv').append(pagingContent);
						}
					}
				});

	}

	function createGroup() {
		var mem = [];
		mem.push('mohana');
		mem.push('vrushali');
		//alert(mem[0]);
		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/group/createGroup2',
			data : {
				name : 'abc',
				type : 'Secret',
				members : 'mohana',
				info : 'xyz'
			},
			success : function(data) {
				alert(data);
			}
		});

	}
	if("${activeUser.username}" != undefined) {
		//setInterval('getChatNotifications()', 10*1000);
		setTimeout('getChatNotifications()', 10000);
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
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right" /></a>
				</div>
				<hr />

				<span><strong>Trends set to <a id="trendCountry">Worldwide
					</a> <a id="trendCity"></a>
				</strong><br /> </span>
				<div id="trendLocations"></div>
				<input class="blue-btn right" id="trendReset" type="button"
					value="Reset" name="" onclick="clearPrefs();"/> <input
					class="blue-btn right mar-rig-btn" id="trendSet" type="button"
					value="Done" name="" onclick="setCountryCity();"/>

						<div class="clear"></div>
			</div>
		</div>
	</div>
	<div id="gif-main" class="gif-main"></div>

	<div id="form1-pop" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop">
				<div class="close-btn">
					<div class="title-form">Update your profile image</div>
					<a href="javascript:close_pop();" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="col"/></a>
				</div>
				<form method="post" name="uploadForm"
					action="${applicationScope.contextPath}/user/upload"
					enctype="multipart/form-data">
					<span>Upload Image</span> <input name="fileData" type="file" /> <input
						type="submit" name="send" class="blue-btn" value="Upload" />
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

		if (geo_position_js.init()) {
			geo_position_js.getCurrentPosition(success_callback,
					error_callback, {
						enableHighAccuracy : true
					});
			geocoder = new google.maps.Geocoder();
			//alert('location det');
		} else {
			//alert("Functionality not available");
		}

		function success_callback(p) {
			//document.getElementById('point').innerHTML='lat='+p.coords.latitude+';lon='+p.coords.longitude;
			document.getElementById('latitude').value = p.coords.latitude;
			document.getElementById('longitude').value = p.coords.longitude;
			//alert(p.coords.latitude);
			codeLatLng(p.coords.latitude, p.coords.longitude);
		}

		function error_callback(p) {
			//alert('error='+p.message);
		}

		function setUserLocationIcon() {
			//	alert("Ajaxing");

			geo_position_js.getCurrentPosition(success_callback,
					error_callback, {
						enableHighAccuracy : true
					});

			//alert("Ajaxing end");
			//alert('Posted your Message successfully..!!!');
		}

		function codeLatLng(lat, lng) {
			var latlng = new google.maps.LatLng(lat, lng);
			geocoder
					.geocode(
							{
								'latLng' : latlng
							},
							function(results, status)

							{
								if (status == google.maps.GeocoderStatus.OK) {
									var city = "", country = "", location = "";
									//  console.log(results);
									if (results[1]) {
										for ( var i = 0; i < results[0].address_components.length; i++) {
											for ( var b = 0; b < results[0].address_components[i].types.length; b++) {

												if (results[0].address_components[i].types[b] == "locality") {

													city = results[0].address_components[i].long_name;
													//alert(city);
													document
															.getElementById('city').value = city;
													// alert(city);
													location = location + city
															+ ",";

												}

												if (results[0].address_components[i].types[b] == "country") {
													country = results[0].address_components[i].long_name;
													// window.location.href="http://"+ (country.short_name).toLowerCase() +".fanggle.com";		
													//alert(country);
													document
															.getElementById('country').value = country;
													//document.getElementById('country').value=country.long_name;

													location = location
															+ country;
												}

											}

										}

										$
												.ajax({
													type : 'GET',
													url : '${applicationScope.contextPath}/user/getUserLocationOnOffStatus',
													success : function(data) {

														if (data == false) {

															document
																	.getElementById("btnLoc").style.backgroundImage = "url(${applicationScope.contextPath}/resources/images/nolocation.png)";

															document
																	.getElementById('latitude').value = "";
															document
																	.getElementById('longitude').value = "";
															document
																	.getElementById('city').value = "";
															document
																	.getElementById('country').value = "";
															document
																	.getElementById('isUserLocationOn').value = false;
														} else {

															document
																	.getElementById("btnLoc").style.backgroundImage = "url(${applicationScope.contextPath}/resources/images/location.png)";
															document
																	.getElementById('location_city').innerHTML = location;
															document
																	.getElementById('isUserLocationOn').value = true;
														}
													}
												});

									} else {
										document.getElementById('location').innerHTML = 'Not available';
										//  window.location.href="http://www.fanggle.com";
									}
								} else {
									document.getElementById('location').innerHTML = 'Not available';
									//window.location.href="http://www.fanggle.com";
								}
							});

			setUserLocation();
		}
	</script>
	
	<div id="point"></div>
	<div class="head-home border">
		<div class="head-in">
			<span class="logo"><img
				src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png"
				title="Social Graph" alt="Social Graph" /></span>
			<div class="log-rig-new">
				<div class="right">
					<input name="" type="text" value="Search"
						onfocus="if(this.value=='Search'){this.value='';}"
						onblur="if(this.value==''){this.value='Search';}" id="search" />
					Welcome ${activeUser.displayName} |<a
						href="${applicationScope.contextPath}/auth/logout" title="Logout">Logout</a>
				</div>
				<ul class="noti-li">
					<li><a href="javascript:;" class="noti-msg" onclick="showChatNotifications(event);"><img src="${applicationScope.contextPath}/resources/images/noti-msg.jpg"/></a></li>
					<li><a href="javascript:;" class="noti-user"><img
							src="${applicationScope.contextPath}/resources/images/noti-user.jpg" />
							<!-- <span>35</span> --></a></li>
					<!-- <li><a href="javascript:;" class="noti-icon"><img src="${applicationScope.contextPath}/resources/images/noti-icon.jpg" /><span>355</span></a></li> -->
				</ul>
				<div class="tab-home">
					<div id="tabs_container">
						<ul id="tabs">
							<li class="active"><a href="#">Home</a></li>
							<li><a
								href="${applicationScope.contextPath}/activities/show">Activities</a></li>
							<li><a href="${applicationScope.contextPath}/find/show">Find</a></li>
							<li><a href="${applicationScope.contextPath}/media">Media</a></li>
							<li><a href="${applicationScope.contextPath}/user/profile">Profile</a></li>
							<li style="display: none;"><a href="#">new</a></li>
						</ul>
					</div>

				</div>
			</div>
		</div>
	</div>
	<div class="home-m">
		<div class="profile-div">
			<div class="img-prof">
				<a href="javascript:;" onclick="open_pop();"><span id="caption"
					onmouseover="caption();" onmouseout="clearCaption();">Change
						It</span><img src="${activeUser.profilePhoto}" id="profile_pic"
					style="width: 115px; height: 130px;" alt="Change Your Image"
					onmouseover="caption();" onmouseout="clearCaption();" /></a>
			</div>
			<div class="name col">
				<a onclick='profile_pop("${activeUser.username}");'>${activeUser.displayName}</a><br />
				<span><a onclick='profile_pop("${activeUser.username}");'>View
						my profile</a></span>
				<ul id="tabs_next">
					<li id="message"><a href="#tab1_n"><span id='messageCount'>${fn:length(activeUser.messages)}</span><br />
							Message</a></li>
					<li id="following"><a href="#tab2_n" id="followingNum">${fn:length(activeUser.following)}<br />
							Following
					</a></li>
					<li id="followers"><a href="#tab3_n">${fn:length(activeUser.followers)}<br />
							Followers
					</a></li>
					<li id="friends"><a href="#tab4_n" id="friendNum"><br />
							Friends</a></li>
				</ul>
			</div>
			<div class="send-txt">
				<!--  <form action="${applicationScope.contextPath}/user/post" method="post"> -->
				<textarea name="msg" id="msg" cols="" rows=""
					onfocus="if(this.value=='Compose New Message...'){this.value='';}"
					onblur="if(this.value==''){this.value='Compose New Message...';}">Compose New Message...</textarea>
				<!-- <input type="text" name="msg" value="Hello"/> -->
				<input name="latitude" id="latitude" type="hidden" /><input
					name="longitude" id="longitude" type="hidden" /> <input
					name="country" id="country" type="hidden" /><input name="city"
					id="city" type="hidden" /><input name="isShared" id="isShared"
					type="hidden" value="false" /><input name="isUserLocationOn"
					id="isUserLocationOn" type="hidden" value="false" /> <input
					name="" type="button" class="gray-btn col" value="Send"
					onclick="postMsgUrl();" />
				<!--</form>-->
				<input name="" type="button" id="btnLoc" class="loc-btn col"
					value="" onClick="setUserLocationOnOff(this);" /> <span
					class="country" id="location_city"></span>

			</div>
		</div>
	</div>
	<div class="main-content">
		<div class="tab-wrap col">
			<div id="tabs_container_n" class="col">
				<ul id="tabs_n">
					<li class="active up0" id="liMessage"
						onclick="onClickTabMessages(0,5);"><a href="#tab1_n">Messages</a></li>
					<li class="up1" id="liFollowings"><a href="#tab2_n">Following</a></li>
					<li class="up2" id="liFollowers"><a href="#tab3_n">Followers</a></li>
					<li class="up3" id="liFriends"><a href="#tab4_n">Friends</a></li>
					<li class="up4" id="liGroups"><a href="#tab5_n">Groups</a></li>
				</ul>
			</div>
			<!--<input name="" type="button" value="AddFriend" onClick="addFriend();"/>-->
			<div id="tabs_content_container_n" class="col">
				<div id="tab1_n" class="tab_content_n" style="display: block;">
					<!-- 			<a href="${applicationScope.contextPath}/user/getMessagesUpdatesFromFriendsAndFollowing">Get Message Updates from Friends</a> -->
					<!-- 			<input type="button" value="messages" onClick="getMessagesUpdatesFromFriendsAndFollowing();" />-->
					<div class="tab1" id="tabMessages"></div>
				</div>
				<div id="tab2_n" class="tab_content_n">
					<div class="tab1" id="tabFollowing"></div>
				</div>
				<div id="tab3_n" class="tab_content_n">
					<div class="tab1" id="tabFollowers"></div>
				</div>
				<div id="tab4_n" class="tab_content_n">
					<div class="tab1" id="tabFriends"></div>
				</div>
				<div id="tab5_n" class="tab_content_n" style="display: block;">
					<div class="tab-group">
						<div id="groupButtonDiv"></div>
						<div id="groupTableDiv"></div>





					</div>

					<div class="tab-creat-group" style="display: none;">
						<h4>ABC</h4>
						<div class="col onegrp">
							<img
								src="${applicationScope.contextPath}/resources/images/prof-pic.jpg"
								width="125" height="125" />
						</div>

						<div class="col twogrp">
							<input name="" type="text" value="ABC" /> <img
								src="${applicationScope.contextPath}/resources/images/edit.gif"
								class="edit-ic" /><br /> <input name="" type="text"
								value="About" /> <img
								src="${applicationScope.contextPath}/resources/images/edit.gif"
								class="edit-ic" />
						</div>
						<div class="col thrgrp">
							<a href="javascript:;"><img
								src="${applicationScope.contextPath}/resources/images/add_user.png"
								title="Add member" /></a><a href="javascript:;"> <img
								src="${applicationScope.contextPath}/resources/images/remove_user.png"
								title="Remove member" /></a>
						</div>
						<div class="col frgrp">
							<span><a href="javascript:;" class="sel-comb">Closed
									group <img
									src="${applicationScope.contextPath}/resources/images/edit.gif"
									class="edit-combo" />
							</a> <select name="" class="sel-com">
									<option>Public</option>
									<option>Private</option>
									<option>Closed group</option>
							</select></span> <span><a href="javascript:;">13 members</a></span> <span>Admin:
								<a href="javascript:;">Rao Ghuge</a>
							</span>
						</div>
						<div class="clear"></div>
						<textarea name="" cols="" rows="">Message</textarea>
						<input name="" type="submit" class="blue-btn right" value="Save"
							onclick="createGroup();" />
					</div>

					<div class="prof-grp tab1 bor-up" style="display: none;">

						<ul>
							<li><img
								src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"
								width="48" />
								<div class="col prof-li">
									<span class="tit-sml"><a href="javascript:profile_pop()">JYOTI
											PATIL</a></span><span class="right1"><a href="javascript:;">X</a>
									</span>
									<p>hey hi m icwa final student I am simple n sweet my frnds
										say that.... and I love my family</p>
									<p>
										<span class="p3"><img
											src="${applicationScope.contextPath}/resources/images/thumb1.jpg" />
											<img
											src="${applicationScope.contextPath}/resources/images/thumb2.jpg" />
											<img src="images/thumb3.jpg" /> <img
											src="${applicationScope.contextPath}/resources/images/thumb1.jpg" />
											<img
											src="${applicationScope.contextPath}/resources/images/thumb4.jpg" /></span>
									</p>
								</div></li>
							<li><img
								src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg"
								width="48" />
								<div class="col prof-li">
									<span class="tit-sml"><a href="javascript:profile_pop()">JYOTI
											PATIL</a></span> <span class="right1"><a href="javascript:;">X</a>
									</span>
									<p>hey hi m icwa final student I am simple n sweet my frnds
										say that.... and I love my family</p>
								</div></li>
						</ul>




					</div>
				</div>

				<!--         <div id="tab5_n" class="tab_content_n"> -->
				<!-- 			<div class="tab1"> -->
				<!--             Under Construction -->
				<!--             </div> -->
				<!-- 		</div> -->
			</div>
		</div>


		<%@ include file="suggestions.jsp"%>
		<%@ include file="trends.jsp"%>
		<%@ include file="messages.jsp"%>
	</div>

	<%@ include file="profile-popup.jsp"%>
	<div class="footer">
		<div class="head-in">
			<span class="col"><a href="javascript:;">About</a> | <a
				href="javascript:;">Help</a> | <a href="javascript:;">Terms</a> | <a
				href="javascript:;">Privacy</a> | <a href="javascript:;">Contact
					Us</a> <br /> Copyright &copy; 2013 Website Name. All rights reserved.</span>
			<span class="right">Site design and developed by <a
				href="javascript:;" class="txt-dec">Dream Solutions</a>.
			</span>
		</div>
	</div>
	<div class="man-li-up" style="display: none;">
		<!-- 		<ul> -->
		<!-- 			<li><a href="#">Chat to @ abc..</a></li> -->
		<!-- 			<li><a href="#">Add or remove from the list</a></li> -->
		<!-- 			<li><a href="#">Block @abc</a></li> -->
		<!-- 		</ul> -->
	</div>


	<div class="noti-li-up pop-noti">
		<div class="noti-tit">
			Notification <span>10</span> <a class="right">See more</a>
		</div>
		<ul>
			<li><img
				src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg" />
				<p>
					<a href="#">abc girl</a> provided some feedback on your design... <span>10
						minutes ago</span>
				</p></li>
			<li><img
				src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg" />
				<p>
					<a href="#">xyz boy</a> provided some feedback on your design... <span>10
						minutes ago</span>
				</p></li>
			<li class="last-li"><img
				src="${applicationScope.contextPath}/resources/images/thumb_boy.jpg" />
				<p>
					<a href="#">pnb boy</a> provided some feedback on your design... <span>10
						minutes ago</span>
				</p></li>
		</ul>
	</div>


	<div class="noti-li-frd pop-noti">
		<div class="noti-tit" id="friendRequestTab">
			Friend Request
			<!-- <span>10</span> -->
			<a class="right">See more</a>
		</div>
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

	<div class="noti-li-msg pop-noti" id="chat-notifications-all" style='display:block;'>
		<div class="noti-tit" id="chat-notifications">
		</div>
		
	</div>
	<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
	  <script>
	  $("html").mouseup(function(){ 
	        if(!mouse_is_inside) {
	        	$('div.noti-li-up').hide();
	    		$('div.noti-li-frd').hide();
	        	$('div.noti-li-msg').hide(); 	
	        	
	        }
	    });
  </script> 
	
	<!-- <div id="draggable" style="width: 150px; height: 150px; padding: 0.5em;" class="ui-widget-content">
	  <p>Drag me around</p>
	</div> -->
	 
	<div  id="chat-windows" style='display:block;'></div>
</body>
</html>
