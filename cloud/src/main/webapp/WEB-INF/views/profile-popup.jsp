<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<script language="javascript" type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/arbor.js"></script>
<script language="javascript" type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/arborGraphics.js"></script>
<script language="javascript" type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/graphRenderer.js"></script>
<script>
	$(document).ready(function() {
		$(".li1").click(function() {

			$(".prof-dis").hide();
			$(".conn-dis").show();
			$(".li2").removeClass('active');
			$(".li1").addClass("active");
		});
		$(".li2").click(function() {

			$(".prof-dis").show();
			$(".prof-dis").removeClass('none');
			$(".conn-dis").hide();
			$(".li1").removeClass('active');
			$(".li2").addClass("active");
		});

	});

	function showAlertForUser(msg)
	{
		//alert(msg);
		$('#user-profile-alert').html(msg);
		$('.user-profile-alert').fadeIn(1000).fadeOut(3000);
	}
	function open_inpop() {
		
		//if(graphIndex==0) return;
		document.getElementById('inpop-block').style.display = 'block';
		document.getElementById('profile-block').style.display = 'none';
		var canvasArea = "<canvas id='viewportBig' width='980' height='460'/>";
		$("#graph-tabBig").html(canvasArea);
		
		var sys = arbor.ParticleSystem(1000, 400, 0.9);
		sys.parameters({
			gravity : true
		});
		//alert("Big Image");
		sys.renderer = Renderer("#viewportBig");
		var response='{}';
		if (graphIndex == 1) {
			response = graphData1;
			
		} else {
			response = graphData2;
		}
		
		var data = $.parseJSON(response);
		if(data == null || data.nodes == null) {
			showAlertForUser(username1 +" has no relations currently");
			return;
		}
		//alert(data.nodes.length);
		for(var key=0; key<data.nodes.length; key+=1) {
			var nn = data.nodes;
			//alert(nn[key].name);
			sys.addNode(nn[key].name, nn[key].data);
		}
		for(var key=0; key<data.edges.length; key+=1) {
			var ee = data.edges;
			//alert(ee[key].source);
			sys.addEdge(ee[key].source, ee[key].target, ee[key].data);
		}
		$("#otherUserDisplayName1").text(username1);
		
	}

	function close_popin() {
		document.getElementById('inpop-block').style.display = 'none';
		document.getElementById('profile-block').style.display = 'block';
		setGraphData();
	}

	var username1 = "";
	var username2 = "";
	var graphData1;
	var graphData2;
	var graphIndex = 1;
	function profile_pop(user) {

		username1 = user;
		graphData1 = "";
		graphData2 = "";
		graphIndex = 1;
		$(".prof-dis").hide();
		$(".conn-dis").show();
		$(".li2").removeClass('active');
		$(".li1").addClass("active");
		getOtherUserData(user);
		document.getElementById('profile-block').style.display = 'block';
		getGraph(user);
	}
	function close_profile() {
		graphData1 = "";
		graphData2 = "";
		graphIndex = 1;
		document.getElementById('profile-block').style.display = 'none';
	}

	function getOtherUserData(user) {
		username2 = user;
		$.ajax({
			type : "GET",
			url : "${applicationScope.contextPath}/user/otherUserProfile?user="
					+ user,
			success : function(response) {
				if (response == "notfound") {
					//alert(response);
				} else {
					$("#otherUserMsgCount").html(response.messageCount).append(
							"<br/>Messages");
					$("#otherUserFollowCount").html(response.followingCount)
							.append("<br/>Following");
					$("#otherUserFollowerCount").html(response.followerCount)
							.append("<br/>Followers");
					$("#otherUserFriendCount").html(response.friendCount)
							.append("<br/>Friends");

					$("#otherUserPhoto").attr('src', response.photoUrl);

					$("#otherUserDisplayName").text(response.displayName);

					$("#otherUserUsername").text(response.username);
					//username2 = response.username;

					$("#otherUserUsername").text(response.username);
					getRelationship(user);
				}
			},
			error : function(e) {
				console.log(e);

				return false;
			}

		});
	}

	function getRelationship(user) {
		username2 = user;
		$
				.ajax({
					type : "GET",
					url : "${applicationScope.contextPath}/user/getRelationship?username="
							+ username1,
					success : function(response) {

						//alert(response);
						if (response.indexOf("Follows") != -1 || response.indexOf("SameUser") != -1) {
							$("#relateFollowing").hide();
						} else {
							$("#relateFollowing").show();
						}
						if (response.indexOf("Friend") != -1 || response.indexOf("SameUser") != -1) {
							$("#relateFriend").hide();
						} else {
							$("#relateFriend").show();
						}
						

					},
					/*error : function(e) {
						alert("Error" + e);
						console.log(e);

						return false;
					},*/
					error : function(xhr, ajaxOptions, thrownError) {

						console.log(e);

						return false;
					}

				});
	}

	function getGraphByTab(index) {
		//alert("index="+index);
		if (index == 1) {
			//alert("username1 = "+username1);
			graphIndex = 1;
			getGraph(username1);
		} else {
			graphIndex = 2;
			//alert("username2 = "+username2);
			getOtherUserConnections(username2);
		}
	}

	function getOtherUserConnections(user) {
		//alert(user);
		
		var graphTabArea = "<img src='${applicationScope.contextPath}/resources/images/loading.gif' width='50' height='50' style='margin-left:280px;' >";
		$("#graph-tab2").html(graphTabArea);
		if(graphData2 == "") {
			var userUrl = "${applicationScope.contextPath}/socialGraph/getUserConnections?username="
				+ username1;
			$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						if (response == "notfound") {
							//alert(response);
						} else {
							graphData2 = response;
							setGraphData();

						}
					},
					error : function(e) {
						console.log(e);

						return false;
					}

				});
		
		}
		if(graphData2 != "") {
			setGraphData();
		}
	}
	
	function setGraphData() {
		//alert("1");
		var graphId =  $("#graph-tab1");
		var viewportId = "viewport1";
		var graphData = graphData1;
		if(graphIndex != 1) {
			graphId = $("#graph-tab2");
			viewportId = "viewport2";
			graphData = graphData2;
		}
		//alert(viewportId);
		
		graphId.html("");
		var canvasArea = "<canvas id='"+viewportId+"' width='620' height='231' overflow= 'auto'/>";
		//alert(canvasArea);
		graphId.html(canvasArea);
		var sys = arbor.ParticleSystem(1000, 400, 0.9);
		sys.parameters({
			gravity : true
		});
		var data = $.parseJSON(graphData);
		if(data == null || data.nodes == null) {
			//alert("data null");
			showAlertForUser(username1 +" has no relations currently");
			return;
		}
		//alert("Data parsed"+data.nodes[0].name);
		sys.renderer = Renderer("#"+viewportId);
		
		//alert(data.nodes.length);
		for(var key=0; key<data.nodes.length; key+=1) {
			var nn = data.nodes;
			//alert(nn[key].name);
			sys.addNode(nn[key].name, nn[key].data);
		}
		for(var key=0; key<data.edges.length; key+=1) {
			var ee = data.edges;
			//alert(ee[key].source);
			sys.addEdge(ee[key].source, ee[key].target, ee[key].data);
		}
		
	}

	function getGraph(user) {
		//alert(user);
		
		var graphTabArea = "<img src='${applicationScope.contextPath}/resources/images/loading.gif' width='50' height='50' style='margin-left:280px;' >";
		$("#graph-tab1").html(graphTabArea);
		//getRelationship(user);
		var userUrl = "${applicationScope.contextPath}/socialGraph/getUserGraph?username="
				+ user;
		if(graphData1 == "") {
		$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						//alert("Success");
						if (response == "notfound") {
							//alert(response);
						} else {
							//alert(response);
							graphData1 = response;
							setGraphData();

						}
					},
					error : function(e) {
						//alert("Error");
						console.log(e);

						return false;
					}

				});
		}
		if (graphData1 != "") {
			setGraphData();
		}


	}
	function followUser() {
		//alert(username1);
		var userUrl = "${applicationScope.contextPath}/user/follow?user="
				+ username1;
		$.ajax({
			type : "GET",
			url : userUrl,
			success : function(response) {
				//alert(response);
				if (response == null) {
					//alert(response);
				} else {
					getOtherUserData(username1);
					showAlertForUser("You are now following @" + username1);
					$("#relateFollowing").hide();
				}

			},
			error : function(e) {
				alert("Error");
				console.log(e);
				return false;
			}

		});
	}
	function addFriendUser() {
		//alert(user);
		$.ajax({
			type : 'POST',
			url : '${applicationScope.contextPath}/user/addFriend',
			data : {
				friendUsername : username1
			},
			success : function(data) {
				//alert("Success");
				getOtherUserData(username1);
				//showAlertForUser("You are now friend of @" + username1);
				showAlertForUser("Your friend request is sent to @" + username1);
				$("#relateFriend").hide();
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

	<div id="inpop-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof-new">
				<div class="close-btn">
					<div class="title-form" id="otherUserDisplayName1"></div>
					<a href="javascript:close_popin()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right"></a>
				</div>
				<div id="graph-tabBig"></div>
			</div>
		</div>
	</div>



	<div id="profile-block" style="display: none;">
		
		<div class="trans"></div>
		<div class="pop">
			<div id="user-profile-alert" class="user-profile-alert"></div>
			<div class="main-pop-prof">
				
				<div class="close-btn">
				
		
					<div class="title-form" id="otherUserDisplayName"></div>
					<a href="javascript:close_profile()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right"></a>
				</div>
				<div class="data">
					<img id="otherUserPhoto"
						src="${applicationScope.contextPath}/resources/users/default_male.png" />
					<div class="col prof-li">
						<span class="tit-sml"><a href="javascript:;"
							id="otherUserUsername"></a></span> <img
							src="${applicationScope.contextPath}/resources/images/lock.jpg" />
						<p></p>
					</div>

					<ul>
						<li id="otherUserMsgCount">0<br /> Massage
						</li>
						<li id="otherUserFollowCount">0<br /> Following
						</li>
						<li id="otherUserFollowerCount">0<br /> Followers
						</li>
						<li id="otherUserFriendCount">0<br /> Friends
						</li>
						<li class="last-child col"><input name="" type="button"
							id="relateFollowing" value="Follow" onclick="followUser();"
							class="gray-btn" /> <input name="" type="button"
							id="relateFriend" value="Friend" class="gray-btn"
							onclick="addFriendUser();" /></li>
					</ul>
				</div>
				<hr />
				<div id="tabs_container">
					<ul id="tabs" class="mar-rig">
						<li class="li1 active" id="profile-pop-connection"><a
							onclick="getGraphByTab(1);" class="conn" href="javascript:;">
								Connection</a></li>
						<li class="li2" id="profile-pop-profile"><a
							onclick="getGraphByTab(2);" href="javascript:;"> Profile</a></li>
					</ul>
				</div>
				
				<div class="conn-dis">
				
				<a href="javascript:open_inpop()" class="right"
					style="margin:-10px 5px 0px; z-index:999999; color: #666666;"><img
						src="${applicationScope.contextPath}/resources/images/max.jpg"
						alt="Maximize" title="Maximize" class="right" width="20" height="20" /></a>
						<div  id="graph-tab1"></div>
				</div>


				<div class="prof-dis none" >
				<a href="javascript:open_inpop()" class="right"
					style="margin:-10px 5px 0px; z-index:999999; color: #666666;"><img
						src="${applicationScope.contextPath}/resources/images/max.jpg"
						alt="Maximize" title="Maximize" class="right" width="20" height="20" /></a>
						<div id="graph-tab2"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>