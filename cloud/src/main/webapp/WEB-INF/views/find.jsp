<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph</title>
  <link rel="shortcut icon" href="${applicationScope.contextPath}/resources/images/favicon.ico" />
<link rel="stylesheet"
	href="${applicationScope.contextPath}/resources/css/style.css"
	type="text/css" media="screen">
	<script type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/jquery.js"
		language="javascript"></script>
	
	<script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/arbor.js"></script>
	<script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/arborGraphics.js"></script>
	<script language="javascript" type="text/javascript"
		src="${applicationScope.contextPath}/resources/js/graphRenderer.js"></script>
		<script type="text/javascript" src="${applicationScope.contextPath}/resources/js/alertHandler.js"
		language="javascript"></script>
       

	<script>
	
	function getInvalidMethodNumber(callback) { 
		//alert('in get invalid method number');
		//alert('in our own Algorithm search');
		$.ajax({
			type: 'GET',
			url: '${applicationScope.contextPath}/find/getInvalidMethodNumber',
			success: function(response) {
				callback(response);
			}, 
			error : function(e) {
				//alert('GlobalSearch service is NOT up..!!!');
				console.log(e);
				return false;
			}
			});
		}
	
	function createSuggestionDictionary() { 
		//alert(crt);
		alert('test');
		$.ajax({
			type: 'GET',
			url: '${applicationScope.contextPath}/find/createSuggestionDictionary',
			success: function(response) {
				alert(response);
			}, 
			error : function(e) {
				//alert('GlobalSearch service is NOT up..!!!');
				console.log(e);
				return false;
			}
			});
		}
	
	function googleSearch(crt)
	{
			$("#search").val(crt);
			$("#suggestions").hide();
			
			$.ajax({
				type: 'GET',
				url: '${applicationScope.contextPath}/find/getGoogleSearchResults',
				data: {criteria: crt},
				success: function(response) {
					//alert("response: " + response);
					var messages="";
					messages = messages +"<ul id='followers'>";
					//alert("response length: " + response.length);
				    for ( var i = 0; i < response.length; i += 1) 
				    {
				    	//alert(response[i].title + " " + response[i].link);
				    	messages = messages + "<li>" + response[i].title + "<br>";
				    	messages = messages + "<a onclick='open_in_new_tab(\"" + response[i].link + "\")'>" + response[i].link + "</a></li>";
				    	
				    }
				    messages = messages +"</ui>"; 
				    $('#listView').html(messages);
				}
			});
		
	}
	
	function open_in_new_tab(url)
	{
	  var win=window.open(url, '_blank');
	  win.focus();
	}
	
	function gd() 	//setGraphData, try to use this function from some common js file, communicate with Gayatri.
	{
		var graphId =  $("#graphView");
		var viewportId = "viewport1";
		var graphData = graphData1;
		if(graphIndex != 1) {
			graphId = $("#graphView");
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
	
	function setListData(data) {
		var messages="";
		messages = messages +"<ul id='followers'>";
	    for ( var i = 0; i < data.length; i += 1) 
	    {
	    	messages = messages + "<li><img src=\"" + data[i].userPhotoUrl + "\" />";
	    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\">";
	    	messages = messages + "<a onclick='profile_pop(\"" + data[i].username + "\");'>"
	    	messages = messages + data[i].displayName + "</a></span>" + data[i].username +
	    	"<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" /> "+
	    	"<span class=\"right\"><a href=\"javascript:;\" class=\"passinfo col\"></a>";
	
	    	var relations = data[i].relationToUser.split(",");
	    	var action = null;
	    	
	    	for(var j=0; j<relations.length; j++) {
	    		var relation = relations[j].trim();
		    	if(relation=="Friend") {
		    		action = "Unfriend";
		    	} else if(relation=="Follows") {
		    		action = "Unfollow";
		    	} else if(relation=="FollowedBy") {
		    		action = "Block";
		    	} 
		    	if(action!=null) {
		    		messages = messages + "<input name=\"\" type=\"button\" class=\"gray-btn hover\" value=\"" + action + "\"  /> ";
		    	}
	    	}
	    	messages = messages + "</span>";
	    	messages = messages + "<p>" + getMessageFormatted(data[i].message) + "</p>";
	    	if(data[i].when!=null) {
	    		messages = messages + "<p><br>" + data[i].when + "</p></div>";
	    	}
	    	messages = messages + "</li>";

	    }
	    messages = messages +"</ui>"; 
	    $('#listView').html(messages);
	}

	function graphSearch(methodNumber, crt, formula)
	{
			//alert(crt);
			$("#search").val(crt);
			$("#suggestions").hide();
			
			var invalidMethodNum=-1;
		
			getInvalidMethodNumber(function(val){
				if(methodNumber==val) {
					googleSearch(crt);
				} else {
					$.ajax({
						type: 'GET',
						url: '${applicationScope.contextPath}/find/graphSearchPeople',
						data: {criteria: crt, methodNumber: methodNumber, formula: formula},
						success: function(response) {
							var data = response.results;
							graphData1 = response.graphData;
							
						    setListData(data);
							gd();
				
						}
					});
				}
			
			});	
			//alert("method num" + methodNumber);	
	}
	
	function getFasterLoadingSuggestions(crt, page, size, faster) { 
		$.ajax({
			type: 'GET',
			url: '${applicationScope.contextPath}/find/getFindSuggestions',
			data: {criteria: crt, page: page, size: size, faster: faster},
			async: true,
			success: function(response) {
				var messages="";
				if(response.length!=0) {
				    for ( var i = 0; i < response.length; i ++) 
				    {
				    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='graphSearch(\"" + response[i].method + "\", \"" + response[i].suggestion + "\", \"" + response[i].formula +"\");'>" + response[i].suggestion + "</a></span>";
						messages = messages + "</div><br>";
				    }
				    messages = messages + "<div id=\"dynamicSuggestions\"></div>";
				  //  var pageRec = page + 1;
				   // messages = messages + "<br><a id=\"loadmore\" onclick='getFasterLoadingSuggestions(\"" + crt + "\", " + pageRec + ", " + size + ", " + faster + ");'>Load More</a>";
				} 
				//if(page==0) {
			   		$('#suggestions').html(messages);
				/* } else {
					$('#loadmore').remove();
					$('#suggestions').append(messages);
				} */
			   
			}, 
			error : function(e) {
				//alert('GlobalSearch service is NOT up..!!!');
				console.log(e);
				return false;
			}
			});
		}
	
	function loadSlowerLoadingSuggestions(crt, page, size, faster) { 
		//alert('in slower loading sug');
		$('#dynamicSuggestions').html("<br>Loading Dynamic suggestions..");
		$.ajax({
			type: 'GET',
			url: '${applicationScope.contextPath}/find/loadSlowerLoadingSuggestions',
			data: {criteria: crt, page: page, size: size, faster: faster},
			async: true,
			success: function(response) {
				if(response.length!=0) {
					var messages="<br>--------------<br>Dynamically generated suggestions:-";
				 	for ( var i = 0; i < response.length; i++) 
				    {
				    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='graphSearch(\"" + response[i].method + "\", \"" + response[i].suggestion + "\", \"" + response[i].formula +"\");'>" + response[i].suggestion + "</a></span>";
						messages = messages + "</div><br>";
				    }

				 	$('#dynamicSuggestions').html(messages);
				} 
			}, 
			error : function(e) {
				//alert('GlobalSearch service is NOT up..!!!');
				console.log(e);
				return false;
			}
			});
		}
	
/* <![CDATA[ */
$(document).ready(function()
{

	var criteria = $("#search").val();
	if(criteria!="") {
		$("#suggestions").show();
		//getFindSuggestions(criteria, 0, 5);
	} else {
		$("#suggestions").hide();
	}
	
	//$(".suggestion").fadeOut("slow");
	var tab="message";	
	var moveLeft = -50;
	var moveDown = 0;  
	
	$("#search").bind('keyup', function(event) {
		var criteria = $("#search").val();
		
		if(event.keyCode == 13) {	//when you click Enter key
			if ($("#search").val() != "") {
				
				if(criteria.length>1) {
					graphFunctionNumberForTheSearchCriteria(criteria);
				}
			}
		} 
		//if(criteria.length>0) {		// after one word entered call findSuggestions on every keyup
			if(criteria!="") {
				$("#suggestions").show();
				getFasterLoadingSuggestions(criteria, 0, 5, true);
			} else {
				$("#suggestions").hide();
			}
		//}
	});
	
	var graphData1 = "";




//getGraph("${applicationScope.contextPath}/socialGraph/getUserRelations?relation=FOLLOWER");

/* function getFindSuggestions(crt, page, size, faster) { 
	
	var asyncCall = faster; 
	
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/find/getFindSuggestions',
		data: {criteria: crt, page: page, size: size, faster: faster},
		async: true,
		success: function(response) {
			var messages="";
			if(response.length!=0) {
			    for ( var i = 0; i < response.length; i ++) 
			    {
			    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='graphSearch(\"" + response[i].method + "\", \"" + response[i].suggestion + "\", \"" + response[i].formula +"\");'>" + response[i].suggestion + "</a></span>";
					messages = messages + "</div><br>";
			    }
			} else if(faster==false) {
				//messages = "<br>No suggestions found..!!!<br>";
			}
			
			if(faster==true) {
				messages = "<div id=\"slowerSuggestions\">Loading..</div>" + messages;
		   		$('#suggestions').html(messages + "--------------------");
		   	} else {
		    	$('#slowerSuggestions').html(messages + "------------------");
		   	}
			
			if(faster==true) {
				//alert('making 2nd call');
		    	page = page + 1;
		    	getFindSuggestions(crt, page, size, false);		//call to load dynamic (slower, time consuming) suggestions
		    }
		}, 
		error : function(e) {
			alert('GlobalSearch service is NOT up..!!!');
			console.log(e);
			return false;
		}
		});
	} */
	function getDefaultSuggestions() { 
		alert('in getDefaultSuggestions');	
		$.ajax({
			type: 'GET',
			url: '${applicationScope.contextPath}/find/getDefaultSuggestions',
			async: true,
			success: function(response) {
				var messages="";
				if(response.length!=0) {
				    for ( var i = 0; i < response.length; i ++) 
				    {
				    	messages = messages + "<div class=\"col prof-li\"><span class=\"tit-sml\"><a onclick='graphSearch(\"" + response[i].method + "\", \"" + response[i].suggestion + "\", \"" + response[i].formula +"\");'>" + response[i].suggestion + "</a></span>";
						messages = messages + "</div><br>";
				    }
				} else {
					messages = "No suggestions found..!!!";
				}
				
			   	$('#suggestions').html(messages);
			   
			}, 
			error : function(e) {
				//alert('GlobalSearch service is NOT up..!!!');
				console.log(e);
				return false;
			}
			});
		}
	
function graphFunctionNumberForTheSearchCriteria(crt) { 
	//alert(crt);
	//alert('in our own Algorithm search');
	$.ajax({
		type: 'GET',
		url: '${applicationScope.contextPath}/find/getFunctionNumberForTheSearchCriteria',

		data: {criteria: crt},

		success: function(response) {
			//alert("method number identified by Algo:" + response);
		
			getInvalidMethodNumber(function(invalidMethodNum) {
				if(response.method==invalidMethodNum) {
					//alert("going for Google Search");
					googleSearch(crt);
				} else {
					//alert("going for GRAPH Search");
					graphSearch(response.method, crt, response.formula);	//response is integer, a method number
				}
			});
			
		}, 
		error : function(e) {
			//alert('GlobalSearch service is NOT up..!!!');
			console.log(e);
			return false;
		}
		});
	}
	
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
	$(".sea-btn").click(function () {
	$('.tab1').show();
	});
	
	 $(".hover").mouseover(function() {
$(this).css('width',84);
$(this).val('Unfollow');
}).mouseout(function(){
$(this).val('Following');
});

});




/* ]]> */
</script>
</head>

<body>



<%@ include file="profile-popup.jsp" %> 

	<!-- <input type="button" value="createSuggestions" onclick="createSuggestionDictionary();" /> -->
	
	<div id="profile-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof">
				<div class="close-btn">
					<div class="title-form">About me.</div>
					<a href="javascript:close_profile()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right">
					</a>
				</div>
				<div class="data">
				
				</div>
				<hr />
				<div id="tabs_container">
					<ul id="tabs">
						<li class="li1 active"><a href="javascript:;" class="conn">
								Connection</a>
						</li>
						<li class="li2"><a href="javascript:;" class=" prof-con">
								Profile</a>
						</li>
					</ul>
				</div>
				<div class="conn-dis">
					<img
						src="${applicationScope.contextPath}/resources/images/pop-con.jpg"
						width="535" height="231" />
				</div>

				<div class="prof-dis none">
					<div class="data">
					
					</div>

				</div>
			</div>
		</div>
	</div>
	</div>


<div id="gif-main" class="gif-main"></div>
	
	<div class="head-home border">
		<div class="head-in">
			<span class="logo"><img
				src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png"
				title="Social Graph" alt="Social Graph" />
			</span>
			<div class="log-rig-new">
				<input name="" id="search" type="text" placeholder="Search" />
				<div class="suggestion" id="suggestions"></div>Welcome
				${activeUser.username} |<a
					href="${applicationScope.contextPath}/auth/logout" title="Logout">Logout</a>
				<div class="tab-home">
					<div id="tabs_container">
						<ul id="tabs" class="mar-rig">
							<li><a href="${applicationScope.contextPath}/user">Home</a>
							</li>
							<li><a
								href="${applicationScope.contextPath}/activities/show">Acitivities</a>
							</li>
							<li class="active"><a
								href="${applicationScope.contextPath}/find/show">Find</a>
							</li>
							<li><a href="${applicationScope.contextPath}/user/profile">Profile</a>
							</li>
						</ul>
					</div>

				</div>
			</div>
		</div>
	</div>

	<div class="main-content">
		<div class="tab-wrap col">
			<div id="tabs_container_n" class="col">
				<ul id="tabs_n">
					<li class="active"><a href="#tab1_n">List</a>
					</li>
					<li><a href="#tab2_n">Graph</a>
					</li>

				</ul>
			</div>
			<div id="tabs_content_container_n" class="col" >
				<div id="tab1_n" class="tab_content_n" style="display: block;">
					<div class="tab-mes" id="listView">
		
					</div>
				</div>
				<div id="tab2_n" class="tab_content_n">
					<div class="tab-mes" id="graphView">
					
					</div>
				<!--	<div class="tab-frd">
						<strong>Search your address book for friends</strong>
						<ul>
							<li><img
								src="${applicationScope.contextPath}/resources/images/Gmail-icon.png" />
								Gmail <a href="javascript:;" class="gray-btn right sea-btn">Search
									contacts</a></li>

							<li><img
								src="${applicationScope.contextPath}/resources/images/Yahoo-icon.png" />
								Yahoo <a href="javascript:;" class="gray-btn right sea-btn">Search
									contacts</a></li>
							<li><img
								src="${applicationScope.contextPath}/resources/images/FacebookIcon.png" />
								Facebook <a href="javascript:;" class="gray-btn right sea-btn">Search
									contacts</a></li>
							<li><strong>Search friends on social graph</strong><br /> <input
								name="" type="text" value="Search friends on social graph" /><a
								href="javascript:;" class="gray-btn right sea-btn">Search
									friends</a></li>


							<li><strong> Invite friends via email</strong><br /> <textarea
									name="" cols="" rows="">Invite friends via email</textarea> <a
								href="javascript:;" class="gray-btn right sea-btn">Invite
									friends</a> <span> Separate multiple email addresses with
									commas. </span></li>


						</ul>
					</div> -->

					<div class="tab1 none">
						
					</div>



				</div>



			</div>
		</div>
		<%@ include file="suggestions.jsp"%>
		<%@ include file="trends.jsp"%>
		<%@ include file="messages.jsp" %> 
	</div>


	<div class="footer">
		<div class="head-in">
			<span class="col"><a href="javascript:;">About</a> | <a
				href="javascript:;">Help</a> | <a href="javascript:;">Terms</a> | <a
				href="javascript:;">Privacy</a> | <a href="javascript:;">Contact
					Us</a> <br /> Copyright &copy; 2013 Website Name. All rights reserved.</span>
			<span class="right">Site design and developed by <a
				href="javascript:;" class="txt-dec">Dream Solutions</a>.</span>
		</div>
	</div>
	<div class="man-li-up">
		<ul>
			<li><a href="#">Chat to @ abc..</a>
			</li>
			<li><a href="#">Add or remove from the list</a>
			</li>
			<li><a href="#">Block @abc</a>
			</li>
		</ul>
	</div>
	
<!-- <div id="graphDemo">hello</div>	<input type="button" value="getGraph" onClick="getGraph();" />  -->
</body>
</html>
