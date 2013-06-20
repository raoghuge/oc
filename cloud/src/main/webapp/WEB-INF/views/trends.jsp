<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="janrain" uri="http://janrain4j.googlecode.com/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
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

	var country = "";
	var city = "";
	getTrends();
	
	 
	function getTrends() {

		var userUrl = "${applicationScope.contextPath}/trend/getTrendNames";
		$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						if (response == null) {
							//alert(response);
						} else {
							var follow = "";
							follow = follow + "<ul>";
							for ( var i = 0; i < response.length; i += 1) {

								follow = follow + "<li>";
								follow = follow
										+ "<a href='javascript:;' class='trend_click' onclick='showTrendMessages(\""
										+ response[i] + "\");'>" + response[i]
										+ "</a>";
								follow = follow + "</li>";

							}
							follow = follow + "</ui>";
							$('#trendTags').html(follow);
							
						}
					},
					error : function(e) {
						console.log(e);
						return false;
					}

				});
	}
	
	
	function showTrendMessages(userTag) {
		var userUrl = "${applicationScope.contextPath}/trend/getTrendMessages?includeHash=false&tag=";
		if(userTag.indexOf("#") == 0) {
		//	alert("hash exists");
			var tag = userTag.split("#")[1];
			//alert(tag);
			userUrl = "${applicationScope.contextPath}/trend/getTrendMessages?includeHash=true&tag="+tag;
		} else {
			userUrl = userUrl+userTag;	
		}
		$.ajax({
			type : "GET",
			url : userUrl,
			
			success : function(data) {
				if (data == null) {
					//alert(response);
				} else {
					var messages="";
					messages = messages +"<ul id='msgUpdates'>";
				    for ( var i = 0; i < data.length; i += 1) 
				    {
				    			//alert(data[i].username);	 
				    	messages = messages + "<li><img src='" + data[i].userPhotoUrl + "' /><div class=\"col prof-li\"><span class=\"tit-sml\"><a href=\"javascript:profile_pop('" + data[i].username + "')\">" + data[i].displayName + "</a></span> " + data[i].username + "<img src=\"${applicationScope.contextPath}/resources/images/lock.jpg\" />";
				    	messages = messages + "<p>" + getMessageFormatted(data[i].message) + "</p>";
				    	messages = messages + "<p><br>" + data[i].when + "</p></div>";
				    	messages = messages + "</li>";
				    }
				    messages = messages +"</ui>"; 
				    $('#tabMessages').html(messages);
				}
			},
			error : function(e) {
				console.log(e);
				
				return false;
	    	}
	    		
	    });
	}


	function trend_pop() {
		getTrendsCountries();
		document.getElementById('trends-block').style.display = 'block';
	}
	function trend_close() {
		document.getElementById('trends-block').style.display = 'none';
	}
	function getTrendsCountries() {

		var userUrl = "${applicationScope.contextPath}/trend/getTrendCountries";
		$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						if (response == null) {
							//alert(response);
						} else {
							var follow = "";
							follow = follow + "<ul>";
							for ( var i = 0; i < response.length; i += 1) {

								follow = follow + "<li>";
								follow = follow
										+ "<a onclick='getTrendCities(\""
										+ response[i] + "\");'>" + response[i]
										+ "</a>";
								follow = follow + "</li>";

							}
							follow = follow + "</ui>";
							//alert(follow);
							$('#trendLocations').html(follow);
						}
					},
					error : function(e) {
						console.log(e);
						return false;
					}

				});
	}
	
	function getTrendCities(userCountry) {
		country = userCountry;
		city = "";
		$('#trendCountry').html(country);
		
		var userUrl = "${applicationScope.contextPath}/trend/getTrendCities?country="+country;
		$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						if (response == null) {
							//alert(response);
						} else {
							
							var follow = "";
							follow = follow + "<ul>";
							for ( var i = 0; i < response.length; i += 1) {

								follow = follow + "<li>";
								follow = follow
										+ "<a onclick='setPrefs(\""+response[i]+"\");'>" + response[i]
										+ "</a>";
								follow = follow + "</li>";

							}
							follow = follow + "</ui>";
							$('#trendLocations').html(follow);
						}
					},
					error : function(e) {
						console.log(e);
						return false;
					}

				});
	}
	function setCountryCity() {
		//alert("Country == "+country+", City == "+city);
		if(city == undefined){
			city = '';
		}
		if(country == undefined) {
			country = '';
		}
		
		var userUrl = "${applicationScope.contextPath}/user/setPreferedLocation?country="+country+"&city="+city;
		$
				.ajax({
					type : "GET",
					url : userUrl,
					success : function(response) {
						showAlert("Changed prefered trends!!!");
					},
					error : function(e) {
						console.log(e);
						return false;
					}

				});
		trend_close();
		getTrends();
	}
	function setPrefs(userCity) {
		city=userCity;
		//alert("set prefs "+city);
		$('#trendCountry').html(country+"/"+city);
		
	}
function clearPrefs() {
		
		country= "";
		city="";
		$('#trendCountry').html("Worldwide");
		
		getTrendsCountries();
	}
$("#trendSet").click(function() {
	setCountryCity();
});
$("#trendReset").click(function() {
	clearPrefs();
});
</script>
</head>
<body>

	<div class="trend right">

		<span class="tit-sml">Trends</span> <a href="javascript:trend_pop();">Change</a>
		<div id="trendTags"></div>

	</div>

	<div id="trends-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop het">
				<div class="close-btn">
					<div class="title-form">Trends.</div>
					<a href="javascript:trend_close()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right"></a>
				</div>
				<hr />

				<span><strong>Trends set to <a id="trendCountry">Worldwide
					</a>
					<a id="trendCity"></a>
				</strong><br />
				
				</span>
				<div id="trendLocations"></div>
				<input class="blue-btn left" id="trendReset" type="button" value="Reset" name="" onclick="clearPrefs();">
				 <input class="blue-btn right" id="trendSet" type="button" value="Done" name="" onclick="setCountryCity();">

				<div class="clear"></div>
			</div>
		</div>
	</div>
</body>
</html>