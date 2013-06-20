<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet"
	href="${applicationScope.contextPath}/resources/css/style.css"
	type="text/css" media="screen" />
<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/jquery-1.9.1.js"
	language="javascript"></script>
	
<script>
	getSuggestions();
	function getSuggestions() {
		//alert("getSuggestions");
		$
				.ajax({
					type : "GET",
					url : "${applicationScope.contextPath}/user/whomToFollow?count=3",
					success : function(response) {
						if (response == "notfound") {
							//alert(response);
						} else {

							var follow = "";
							follow = follow + "<ul id='whomToFollowList'>";
							//alert(response.length);
							for ( var i = 0; i < response.length; i += 1) {
								//alert(response[i].username);
								follow = follow
										+ "<li><img src='"+response[i].photoUrl+"'/>";
								follow = follow + "<div class='new-li col'>";
								follow = follow + "<a onclick='profile_pop(\""
										+ response[i].username
										+ "\");' class='name-link'>"
										+ response[i].displayName + "</a>";
								follow = follow
										+ "<img src='${applicationScope.contextPath}/resources/images/live.png' /> @"
										+ response[i].username + "<br />";
								if (response[i].relationToOtherUser
										.indexOf("Follows") == -1) {
									follow = follow + "<a onclick='follow(\""
											+ response[i].username + "\", " + i
											+ ") ';' class='follow" + i

											+ "'>Follow</a>";
								}
								if (response[i].relationToOtherUser
										.indexOf("Friend") == -1) {
								follow = follow + "<a onclick='addFriend(\""
										+ response[i].username + "\", " + i
										+ ") ';' class='friend" + i
										+ "'>Friend</a>";
								}
								follow = follow
										+ "</div><span onclick='nextSuggestion("
										+ i + ", false,\""
										+ response[i].username
										+ "\");'>X</span>";
								follow = follow + "</li>";

							}
							follow = follow + "</ui>";
							$('#socialSuggestion').html(follow);
						}
					},
					error : function(e) {
						console.log(e);
						return false;
					}

				});

	}
	function nextSuggestion(index, toBlock, otherUser) {

		if (otherUser != null) {
			$.ajax({
				type : "GET",
				url : "${applicationScope.contextPath}/user/blockUser?user="
						+ otherUser,
				success : function(response) {

					showAlert("Blocked user @"+otherUser);
					getSuggestions();
					//$(".follow"+index).parent().parent().hide();

				},
				error : function(e) {
					console.log(e);
					return false;
				}

			});
		} else {
			getSuggestions();
		}
	}
	function follow(user, index) {
		//alert("--------"+user);
		var userUrl = "${applicationScope.contextPath}/user/follow?user="
				+ user;
		$.ajax({
			type : "GET",
			url : userUrl,
			success : function(response) {
				if (response == null) {
					//alert(response);
				} else {
					
					showAlert("You are now following @" + user);
					$(".follow" + index).parent().parent().hide();
					//alert(response.followingCount);
					$("#followingNum").html(response.followingCount + "<br /> Following</a>");
					nextSuggestion($('#whomToFollowList').child, null, null);
				}

			},
			error : function(e) {
				console.log(e);
				return false;
			}

		});
	}

	function addFriend(user, index) {
		//alert(user);
		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/user/addFriend',
			data : {
				friendUsername : user
			},
			success : function(data) {
				//alert("Success");
				//showAlert("You are now friend of @" + user);
				showAlert("Your friend request is sent to @" + user);
				$(".follow" + index).parent().parent().hide();
				//alert(response.followingCount);
		/* 		$("#friendNum").html(data.friendCount).append(
						"<br /> Friends</a>"); */
				nextSuggestion($('#whomToFollowList').child, null, null);
			},
			error : function(e) {
				//alert("Error");
				console.log(e);
				return false;
			}
		});
	}
</script>
</head>
<body>
	<div class="who-follow right">
		<span class="tit-sml">Who to follow</span> <a
			onclick="javascript:getSuggestions();">Refresh</a> <a
			href="javascript:;"></a>
		<div id="socialSuggestion"></div>

	</div>
</body>
</html>