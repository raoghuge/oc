<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph | Media</title>
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=false"></script>
<script type="text/javascript" src="${applicationScope.contextPath}/resources/js/alertHandler.js" language="javascript"></script>
<script src="${applicationScope.contextPath}/resources/js/geo-min.js"
	type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet"
	href="${applicationScope.contextPath}/resources/css/style.css"
	type="text/css" media="screen" />
<link rel="stylesheet"
	href="${applicationScope.contextPath}/resources/css/prettyPhoto.css"
	type="text/css" media="screen" />
<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/jquery.js"
	language="javascript"></script>
<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/custom.js"
	language="javascript"></script>
<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/jquery.prettyPhoto.js"
	language="javascript"></script>
<!--[if gte IE 7]>
 <script src='js/jquery.MultiFile.js' type="text/javascript" language="javascript"></script>
 <style>
 .up_btn{display:none;}
 </style>
<![endif]-->
<script type="text/javascript">
	var geocoder;
	if (geo_position_js.init()) {
		geo_position_js.getCurrentPosition(success_callback, error_callback, {
			enableHighAccuracy : true
		});
		geocoder = new google.maps.Geocoder();
	} else {
		//alert("Functionality not available");
	}
	function success_callback(p) {
		$
				.ajax({
					type : 'GET',
					url : '${applicationScope.contextPath}/user/getUserLocationOnOffStatus',
					success : function(data) {
						if (data == false) 
						{
/* 							document.getElementById('lat').value = "";
							document.getElementById('lon').value = "";
							document.getElementById('cty').value = "";
							document.getElementById('cntry').value = ""; */
							$('#lat').val(0);
							$('#lon').val(0);
							$('#cty').val("");
							$('#cntry').val("");
						}
						else 
						{
							$('#lat').val(p.coords.latitude);
							$('#lon').val(p.coords.longitude);
							/* document.getElementById('lat').value = p.coords.latitude;
							document.getElementById('longitude').value = p.coords.longitude; */
							codeLatLng(p.coords.latitude, p.coords.longitude);
						}
					}
				});

	}
	function error_callback(p) {
		//alert('error='+p.message);
	}
	function setUserLocationIcon() {
		geo_position_js.getCurrentPosition(success_callback, error_callback, {
			enableHighAccuracy : true
		});
	}

	function codeLatLng(lat, lng) {
		var latlng = new google.maps.LatLng(lat, lng);
		geocoder.geocode({'latLng' : latlng	},function(results, status) 
		{
				if (status == google.maps.GeocoderStatus.OK)
				{
					var city = "", country = "", location = "";
					if (results[1]) 
					{
						for(var i = 0; i < results[0].address_components.length; i++) 
						{
							for(var b = 0; b < results[0].address_components[i].types.length; b++) 
							{
								if (results[0].address_components[i].types[b] == "locality") 
								{
									city = results[0].address_components[i].long_name;
									//document.getElementById('cty').value = city;
									$('#cty').val(city);
									location = location + city+",";
								}
								if(results[0].address_components[i].types[b] == "country") 
								{
									country = results[0].address_components[i].long_name;
									//documentv.getElementById('cntry').value = country;
									$('#cntry').val(country);
									location = location + country;
								}
							}
						}
					} 
					else 
					{
						document.getElementById('location').innerHTML = 'Not available';
					}
				} 
				else 
				{
					document.getElementById('location').innerHTML = 'Not available';
				}
		});
	}
</script>

<script type="text/javascript">
$(document).click(function() {
    $('.man-li-album').hide();
});
	$(document).ready(function() {	
		
		$('.imgpht').bind('mouseenter', function(){
			$('.next').fadeIn();
			$('.prev').fadeIn();			
		});

		$('.imgpht').bind('mouseleave', function(){
			$('.next').fadeOut();
			$('.prev').fadeOut();			
		});
		
		$('.next').click(function(){
			var abc = $('.album-content li a').size();
			alert(abc);			
		});
		var moveLeft = -50;
		var moveDown = 0;
		$('a.passinfo').click(function(e) {
			$('div.man-li-up').toggle("fast");
			$("div.man-li-up").css('top', e.pageY).css('left', e.pageX);
			//   $("div.man-li-up").css('top', e.pageY + moveDown).css('left', e.pageX + moveLeft);

		});


		
		$(".callback").click(function() {
			$(".album-content").hide();
			$("#backButton").hide();
			$(".photo-one").show();
			location.href = "media";
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

		$(".tab-photo li a").click(function() {
			$(".photo-one").hide();
			$(".album-content").show();
			$("#backButton").show();
		});



		$(".sea-btn").click(function() {
			$('.tab1').show();
		});

		$(".hover").mouseover(function() {
			$(this).css('width', 84);
			$(this).val('Unfollow');
		}).mouseout(function() {
			$(this).val('Following');
		});

/* 		$(".album-content li a").click(function() 
		 {
			$("#photo-block").css('display','block');
		 });  */

		 $('#post_cmt').click(function(){
			 post_comments();
		 });
		 
		
		 //$('#deleteIt').prop('onclick','hello();');
		
		 
	});

	function close_in_album(event,object, photoId, albumName, userName)
	{		
	    $('div.man-li-album').toggle("fast");  
		$("div.man-li-album").css('top', event.pageY ).css('left', event.pageX);

		 $('#deleteIt').html("Delete.");
		 $('#deleteIt').live('click', function() {
			 deleteContent(object,photoId, albumName, userName);
		 });
		
		//deleteContent('"+object+"');
	}
	 function edit_ic ()
		{
			$(".main-pop-prof-pho .abt-span").hide();
			$(".main-pop-prof-pho .abt-edit").css("display","block");
			$(".main-pop-prof-pho .abt-edit").focus();
		  	$('.edit-ic').css('display','none');
		  	$('#save_desc').css('display','block');
		  	
		}	

	
	function close_photo (location)
	{
		 $('#photo-block').hide();
		 $('#comment_box').val('Write comment');
		 $('#_Main').attr('src','');
		//populateAlbum(description,userName,albumName,imageServerUrl);
		if(typeof location === "undefined")
		{
			populateAlbum(description,userName,albumName,imageServerUrl);
		}
		else
		{
			window.location = location;
		}
		
	}	

	function profile_pop() {
		document.getElementById('profile-block').style.display = 'block';
	}
	function close_profile() {
		document.getElementById('profile-block').style.display = 'none';
		$(".man-li-up").hide();
	}

	function location_pop() {
		document.getElementById('location-block').style.display = 'block';
	}
	function close_location() {
		document.getElementById('location-block').style.display = 'none';
	}

	function upload() {
		$('#fileUpload').click();
	}

	function submit() {
		$('form[name=uploadBean]').submit();
	}



	function readURL(input) {
		if (input.files && input.files[0])
		{
			var len = input.files.length;
			for ( var i = 0; i < len; i++) 
			{
				var label = $('<label>').attr({'id' : 'img' + i}).html(input.files[i].name+ "&nbsp;&nbsp;&nbsp;"
										+ Math.round(input.files[i].size / 1024)
										+ "KB"
										+ "&nbsp;&nbsp;&nbsp;"
										+ "<a onClick='$(this).parent().remove();' title='close'>X"
										+ "<\/a>"
										+ "<br><div class='clear'></div>")
						.appendTo($('#images'));
			}
		}
	}

	/* ]]> */
</script>
<script type="text/javascript">
var description,userName,albumName,imageServerUrl;
	function populateAlbum(description, userName, albumName, imageServerUrl) 
	{
		this.description = description;
		//this.userName = userName;
		this.ownerName = userName;
		this.albumName = albumName;
		this.imageServerUrl = imageServerUrl;
		var url = imageServerUrl;
		$(".photo-one").hide();
		$('#header_album').html(albumName);
		if(description!='')
		{
			$('#header_album').append(": "+description);	
		}
		$(".album-content").empty();
		$.ajax({
			type : "GET",
			url  : "${applicationScope.contextPath}/media/populateAlbum",
			data : "userName="+ownerName+"&albumName="+albumName,
			success : function(response) 
			{
				for(var i = 0; i < response.length; i++) 
				{
					var li = "<li><a href='#' onclick=\"photo_view('"+response[i].description+"','"+response[i].userName+"','"+(url+"viewImage?id="+response[i].photoId+"&type=_Main")+"','"+response[i].photoId+"','"+albumName+"');\">"+
										"<img src='"+url+"viewImage?id="+response[i].photoId+"&type=_Medium'/></a><a href=\"javascript:;\" onClick=\"close_in_album(event,1,'"+response[i].photoId+"','"+albumName+"','"+response[i].userName+"')\" ><img src=\"${applicationScope.contextPath}/resources/images/setting-alb.png\" class=\"sett\"/></a>"
										+"<label style=\"display: none;\" id=\"photoDescription"+response[i].photoId+"\">"+response[i].description+"</label></li>";
					
					$(".album-content").append(li);
				}
				$(".album-content").show();
			},
			error : function(err) 
			{
				if(err.status == 404)
				{
					window.location="${applicationScope.contextPath}/auth/login";;
				}
				console.log(err);
				return false;
			}
		});
	}
	var albumName;
	var photoId;
	var ownerName;
	function photo_view(description, userName, src, photoId, albumName)
	{
		this.photoId = photoId;
		this.albumName = albumName;
		this.ownerName = userName;
		if(userName!=null && userName!=''){
		$("#photo-block").css('display','block');	
		// for loading previous comments
		$.ajax({
			type : "GET",
			url  : "${applicationScope.contextPath}/media/loadComments",
			data : "userName="+ownerName+"&photoId="+photoId+"&albumName="+albumName,
			success: function(response)
			{
					$('#_Main').attr('src', src);
					$('.photo-comment h5').html(albumName);
					$("#lst_usrCmnt").empty();				
					if(response.length>0)
					{
						for(var i=0;i<response.length;i++)
						{						
							var cmntBean = "<li><img src='"+response[i].imageUrl+"viewImage?id="+response[i].user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response[i].user.displayName+"</a><span id=\"cmnt_body\">"+response[i].comments+"</span><span class=\"date\">"+response[i].dateAndTime+"</span></div><span onclick=\"removeComment('"+response[i].commentId+"','"+response[i].user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\" style=\"cursor: pointer;\">[X]</span></li>";
							$('#lst_usrCmnt').append(cmntBean);		
						}
					}
					else
					{
						$('#lst_usrCmnt').append("<li>No Comment yet posted..!</li>");
					}
	
					if(description!="null" && description!='')
					{
						$('.abt-span').html(description);
					}
					else
					{$('.abt-span').html("Add Description for this photo.");}
			},
			error: function(err)
			{
				if(err.status==404)
				{
					window.location="${applicationScope.contextPath}/auth/login";
				}
			}			
		});		
		}
		else{window.location="${applicationScope.contextPath}/auth/login";}
	}
	function deleteContent(object,photoId, albumName, userName)
	{

		 if(object==1)
		 {
				//
			$.ajax({
				type : "POST",
				url  : "${applicationScope.contextPath}/media/deletePhotoFromAlbum",
				data : "albumName="+albumName+"&photoId="+photoId+"&userName="+ownerName,
				success: function(photos)
				{$(".album-content").empty();
					for(var i = 0; i < photos.length; i++) 
					{
						var li = "<li><a href='#' onclick=\"photo_view('"+photos[i].description+"','"+photos[i].userName+"','"+(imageServerUrl+"viewImage?id="+photos[i].photoId+"&type=_Main")+"','"+photos[i].photoId+"','"+albumName+"');\">"+
											"<img src='"+imageServerUrl+"viewImage?id="+photos[i].photoId+"&type=_Medium'/></a><a href=\"javascript:;\" onClick=\"close_in_album(event,1,'"+photos[i].photoId+"')\" ><img src=\"${applicationScope.contextPath}/resources/images/setting-alb.png\" class=\"sett\"/></a>"
											+"<label style=\"display: none;\" id=\"photoDescription"+photos[i].photoId+"\">"+photos[i].description+"</label></li>";
						
						$(".album-content").append(li);
					}
					$(".album-content").show();
				},
				error: function(err)
				{
					if(err.status==404)
					{
						window.location="${applicationScope.contextPath}/auth/login";
					}
				}
			});
		 }
		 if(object==0)
		 {
			 $.ajax({
				 dataType: "JSON",
					type : "POST",
					url  : "${applicationScope.contextPath}/media/deleteAlbum",
					data : "albumName="+albumName+"&userName="+userName,
					success: function(response)
					{
						if(response=="true")
						{
							window.location="${applicationScope.contextPath}/media";
						}
						else
						{
							alert("photo album could not deleted.");
						}
					},
					error: function(err)
					{
						if(err.status==404)
						{
							window.location="${applicationScope.contextPath}/auth/login";
						}
					}
				});
		 }
	}
	   function save_description()
	   {
		   var description = $('input[name=photoDescription]').val();
				$.ajax({
					dataType: "json",
					type : "POST",
					url  : "${applicationScope.contextPath}/media/updateDescription", 
					data : "description="+description+"&photoId="+photoId+"&albumName="+albumName,
					success : function(response)
					{
						if((response.description)!='')
						{
							$('#edit_desc').css('display','block');
							$('.abt-edit').css('display','none');
							$('.abt-span').html(response.description);
							$('.abt-span').css('display','block');
							$('#save_desc').css('display','none');
						}
						else
						{
							$('#edit_desc').css('display','block');
							$('.abt-edit').css('display','none');
							$('.abt-span').html("Add Description for this photo.");	
							$('.abt-span').css('display','block');
							$('#save_desc').css('display','none');		
												
						}
					},
					error : function(err)
					{
						if(err.status==404)
						{
							window.location="${applicationScope.contextPath}/auth/login";
						}
					}
				});
			
	   }
	function removeComment(commentId, userName) 
	{
		var album = albumName;
		var pId = photoId;
		if(typeof albumName === "undefined" && typeof photoId === "undefined")
		{
			album = $('#tempAlbumName').val();
			pId = $('#tempPhotoId').val();
		}
		$.ajax({
			type : "POST",
			url  : "${applicationScope.contextPath}/media/removeComment",
			data : "commentId="+commentId+"&photoId="+pId+"&albumName="+album+"&userName="+userName,
			success : function(response)
			{
				$("#lst_usrCmnt").empty();
				if(response.length>0)
				{	
					for(var i=0;i<response.length;i++)
					{
						var cmntBean = "<li><img src='"+response[i].imageUrl+"viewImage?id="+response[i].user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response[i].user.displayName+"</a><span id=\"cmnt_body\">"+response[i].comments+"</span><span class=\"date\">"+response[i].dateAndTime+"</span></div><span onclick=\"removeComment('"+response[i].commentId+"','"+response[i].user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\">[X]</span></li>";
						$('#lst_usrCmnt').append(cmntBean);		
					}
				}
				else
				{
					$('#lst_usrCmnt').append("<li>No Comment yet posted..!</li>");
				}
			},
			error : function(error)
			{
				if(error.status==404)
				{
					window.location="${applicationScope.contextPath}/auth/login";
				}
			}

		});		
	}
	
	function post_comments(/* albumName, photoId */) {
		var album = albumName;
		var pId = photoId;
		if(typeof albumName === "undefined" && typeof photoId === "undefined")
		{
			album = $('#tempAlbumName').val();
			pId = $('#tempPhotoId').val();
		}
		var lat = $('#lat').val();
		var lon = $('#lon').val();
		var city = $('#cty').val();
		var country = $('#cntry').val();
		var cmnt = $('#comment_box').val();
		if(cmnt != 'Write comment'){
			if (lat != '' && lon != '' && city != '' && country != '') 
			{
				$.ajax({
					dataType: "json",
					type : "POST",
					url : "${applicationScope.contextPath}/media/addComment_loc_OverPhoto",
					data : "photoComment=" + cmnt + "&albumName=" + album
							+ "&latitude=" + lat + "&longitude=" + lon
							+ "&city=" + city + "&country=" + country+"&photoId="+pId,
					success : function(response) 
					{			
						if($("#lst_usrCmnt li").text()=='No Comment yet posted..!')
						{
							$("#lst_usrCmnt").empty();
							var cmntBean = "<li><img src='"+response.imageUrl+"viewImage?id="+response.user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response.user.displayName+"</a><span id=\"cmnt_body\">"+response.comments+"</span><span class=\"date\">"+response.dateAndTime+"</span></div><span onclick=\"removeComment('"+response.commentId+"','"+response.user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\">[X]</span></li>";
							$('#lst_usrCmnt').prepend(cmntBean);
						}
						else
						{
							var cmntBean = "<li><img src='"+response.imageUrl+"viewImage?id="+response.user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response.user.displayName+"</a><span id=\"cmnt_body\">"+response.comments+"</span><span class=\"date\">"+response.dateAndTime+"</span></div><span onclick=\"removeComment('"+response.commentId+"','"+response.user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\">[X]</span></li>";
							$('#lst_usrCmnt').prepend(cmntBean);	
						}
					},
					error : function(error) 
					{
						if(error.status==404)
						{
							window.location="${applicationScope.contextPath}/auth/login";
						}
					}
				});
			}
			else 
			{
				$.ajax({
					dataType: "json",
						type : "POST",
						url : "${applicationScope.contextPath}/media/addCommentOverPhoto",
						data : "photoComment=" + cmnt + "&albumName=" + album+"&photoId="+pId,
						success : function(response) 
						{
							if($("#lst_usrCmnt li").text()=='No Comment yet posted..!')
							{
								$("#lst_usrCmnt").empty();
								var cmntBean = "<li><img src='"+response.imageUrl+"viewImage?id="+response.user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response.user.displayName+"</a><span id=\"cmnt_body\">"+response.comments+"</span><span class=\"date\">"+response.dateAndTime+"</span></div><span onclick=\"removeComment('"+response.commentId+"','"+response.user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\">[X]</span></li>";
								$('#lst_usrCmnt').prepend(cmntBean);
							}
							else
							{
								var cmntBean = "<li><img src='"+response.imageUrl+"viewImage?id="+response.user.photoUrl+"&type=_SMALL' /><div class=\"new-li col\"><a href=\"javascript:;\" class=\"name-link\">"+response.user.displayName+"</a><span id=\"cmnt_body\">"+response.comments+"</span><span class=\"date\">"+response.dateAndTime+"</span></div><span onclick=\"removeComment('"+response.commentId+"','"+response.user.username+"')\" class=\"close_list_new\" style=\"cursor: pointer;\">[X]</span></li>";
								$('#lst_usrCmnt').prepend(cmntBean);	
							}
						},
						error : function(error) 
						{
							if(error.status==404)
							{
								window.location="${applicationScope.contextPath}/auth/login";
							}
						}
					});
			}
		}
		else
		{
			alert("Blank Comment could not be posted...!");
		}
	}


</script>

</head>

<body>
<div id="gif-main" class="gif-main"></div>
<c:choose>
	<c:when test="${route eq 'tempPhoto'}">
		<div id="photo-block" style="display: ${tempPhotoObj.display}">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof-pho">
				<div class="close-btn">
					<div class="title-form"></div>
					<a href="javascript:close_photo('${applicationScope.contextPath}/media')" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg" alt="Close" title="Close" class="right" /></a>
				</div>
				<div class="imgpht col">
				<!--<span class="abt-span"></span>-->
				<!--<input name="photoDescription" type="text" class="abt-edit"/>-->
				<!--<img src="${applicationScope.contextPath}/resources/images/edit.gif" id="edit_desc" class="edit-ic" onclick="edit_ic();" style="float:left; padding-top:5px;" />
				<img src="${applicationScope.contextPath}/resources/images/save.png" id="save_desc" class="edit-ic" onclick="save_description();" style="float:left; padding-top:5px; display: none;"/>-->
					<div class="clear"></div>
					<!--<div class="prev" style="display: none;"></div>-->
					<img src="${tempPhotoObj.imageUrl}" id="_Main"/>
					<!--<div class="next" style="display: none;"></div>
					<a href="javascript:;" onclick="close_in_album(event,1)" class="right" ><img src="${applicationScope.contextPath}/resources/images/setting-alb.png" class="sett"/></a>-->
					
					<!-- <span>3/6</span> -->
				</div>

				<div class="photo-comment">
					<h5>${tempPhotoObj.albumName}</h5>
					<!--<a href="">Comment</a> <a href="">Share</a> <a href="">Unfollow	message</a>-->
					<textarea id="comment_box" name="" class="editext" onfocus="if(this.value=='Write comment'){this.value='';}" onblur="if(this.value==''){this.value='Write comment';}" >Write comment</textarea>
					<a href="#" class="gray-btn rigray" id="post_cmt">Post</a>
						<div class="comm-follow">
						<input type="hidden" value="${tempPhotoObj.photoId}" id="tempPhotoId"/><input type="hidden" value="${tempPhotoObj.albumName}" id="tempAlbumName"/>
							<ul id="lst_usrCmnt">							
								<c:forEach var="comments" items="${tempPhotoObj.listComments}">
									<li><img src="${comments.imageUrl}viewImage?id=${comments.user.photoUrl}&type=_SMALL" /><div class="new-li col"><a href="javascript:;" class="name-link">${comments.user.displayName}</a><span id="cmnt_body">${comments.comments}</span><span class="date">${comments.dateAndTime}</span></div><span onclick="removeComment('${comments.commentId}','${comments.user.username}')" class="close_list_new" style="cursor: pointer;">[X]</span></li>
								</c:forEach>
							</ul>
						</div>
				</div>
			</div>
		</div>
	</div>
	</c:when>
	<c:otherwise>
		<div id="photo-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof-pho">
				<div class="close-btn">
					<div class="title-form"></div>
					<a href="javascript:close_photo()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg" alt="Close" title="Close" class="right" /></a>
				</div>
				<div class="imgpht col">
				<span class="abt-span"></span>
				<input name="photoDescription" type="text" class="abt-edit"/>
				<img src="${applicationScope.contextPath}/resources/images/edit.gif" id="edit_desc" class="edit-ic" onclick="edit_ic();" style="float:left; padding-top:5px;" />
				<img src="${applicationScope.contextPath}/resources/images/save.png" id="save_desc" class="edit-ic" onclick="save_description();" style="float:left; padding-top:5px; display: none;"/>
					<div class="clear"></div>
					<div class="prev" style="display: none;"></div>
					<img src="" id="_Main"/>
					<div class="next" style="display: none;"></div>
					<a href="javascript:;" onclick="close_in_album(event,1)" class="right" ><img src="${applicationScope.contextPath}/resources/images/setting-alb.png" class="sett"/></a>
					
					<!-- <span>3/6</span> -->
				</div>

				<div class="photo-comment">
					<h5></h5>
					<a href="">Comment</a> <a href="">Share</a> <a href="">Unfollow
							message</a> 
					<!-- <input name="" type="text" value="Write comment" /> -->
					<textarea id="comment_box" name="" class="editext" onfocus="if(this.value=='Write comment'){this.value='';}" onblur="if(this.value==''){this.value='Write comment';}" >Write comment</textarea>
					<a href="#" class="gray-btn rigray" id="post_cmt">Post</a>
						<div class="comm-follow">
							<ul id="lst_usrCmnt">							
							
							</ul>
						</div>
				</div>
			</div>
		</div>
	</div>
	</c:otherwise>
</c:choose>
	<div id="location-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof1">
				<div class="close-btn">
					<div class="title-form"></div>
					<a href="javascript:close_location()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right" /></a>
				</div>

				<div id="tabs_container">
					<ul id="tabs">
						<li class="li1 active"><a href="javascript:;" class="conn">
								Upload</a></li>
					</ul>
				</div>
				<div class="conn-dis">
					<form method="post"
						action="${applicationScope.contextPath}/upload/upload_photo_image"
						enctype="multipart/form-data" name="uploadBean">
						<div class="up_btn">
							<a href="#" onclick="upload();" class="gray-btn">Select Photo</a>
							<a href="#" onclick="submit();" class="gray-btn">Save</a>
						</div>

						<div class="ie">
							<input type="file" multiple="multiple" onchange="readURL(this);"
								name="files" id="fileUpload" class="multi" />
							<div id="images"></div>
						</div>
						<span>Album Name</span> <input name="albumName" type="text"
							class="in-txt" /> <span>Visible to</span> <select
							class="in-txt1" name="visibleLevel">
							<option value="0">Public</option>
							<option value="1">Private</option>
							<option value="2">Friends &amp; Followers</option>
						</select><span>Description</span><input name="description" type="text" class="in-txt"/>						
						<input name="latitude"  id="lat"   type="hidden" value="0"/>
						<input name="longitude" id="lon"   type="hidden" value="0"/>
						<input name="country"   id="cntry" type="hidden" value=""/>
						<input name="city"      id="cty"   type="hidden" value=""/>
					</form>

				</div>
				<div class="clear"></div>
			</div>
		</div>
	</div>

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
					value="Reset" name="" onclick="clearPrefs();" /> <input
					class="blue-btn right mar-rig-btn" id="trendSet" type="button"
					value="Done" name="" onclick="setCountryCity();" />

				<div class="clear"></div>
			</div>
		</div>
	</div>


	<div id="profile-block" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop-prof">
				<div class="close-btn">
					<div class="title-form">About me.</div>
					<a href="javascript:close_profile()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right" /></a>
				</div>
				<div class="data">
					<img
						src="${applicationScope.contextPath}/resources/images/thumb_girl.jpg" />
					<div class="col prof-li">
						<span class="tit-sml"><a href="javascript:;">JYOTI
								PATIL</a></span> @napasninja <img
							src="${applicationScope.contextPath}/resources/images/lock.jpg" />
						<p>
							Actor <br />hey hi m icwa final student I am simple n sweet my
							frnds say that.... and I love my family
						</p>
					</div>
					<ul>
						<li>10<br /> Massage
						</li>
						<li>220<br /> Following
						</li>
						<li>10<br /> Followers
						</li>
						<li>10<br /> Friends
						</li>
						<li class="last-child"><a href="javascript:;"
							class="passinfo col"><img src="images/man-icon.jpg" /></a> <input
							name="" type="button" class="gray-btn hover" value="Following" /></li>
					</ul>
				</div>
				<hr />
				<div id="tabs_container">
					<ul id="tabs">
						<li class="li1 active"><a href="javascript:;" class="conn">
								Connection</a></li>
						<li class="li2"><a href="javascript:;" class="prof-con">
								Profile</a></li>
					</ul>
				</div>
				<div class="conn-dis">
					<img src="images/pop-con.jpg" width="535" height="231" />
				</div>

				<div class="prof-dis none">
					<div class="data">
						<img src="images/thumb_girl.jpg" />
						<div class="col prof-li">
							<span class="tit-sml"><a href="javascript:;">JYOTI
									PATIL</a></span> @napasninja <img src="images/lock.jpg" />
							<p>
								Actor <br />hey hi m icwa final student I am simple n sweet my
								frnds say that.... and I love my family
							</p>
						</div>
					</div>

				</div>
			</div>
		</div>
	</div>

	<div class="head-home border">
		<div class="head-in">
			<span class="logo"><img
				src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png"
				title="Social Graph" alt="Social Graph" /> </span>
			<div class="log-rig-new">
				<!-- 				<ul class="noti-li">
					<li><a href="javascript:;"><img src="images/noti-msg.jpg" /><span>3</span></a></li>
					<li><a href="javascript:;"><img src="images/noti-user.jpg" /><span>35</span></a></li>
					<li><a href="javascript:;"><img src="images/noti-icon.jpg" /><span>355</span></a></li>
				</ul> -->
				<input name="" type="text" value="Search" /> Welcome
				${activeUser.displayName} | <a
					href="${applicationScope.contextPath}/auth/logout" title="Logout">Logout</a>
				<div class="tab-home">
					<div id="tabs_container">
						<ul id="tabs">
							<li><a href="${applicationScope.contextPath}/user">Home</a></li>
							<li><a
								href="${applicationScope.contextPath}/activities/show">Activities</a></li>
							<li><a href="${applicationScope.contextPath}/find/show">Find</a></li>
							<li class="active"><a
								href="${applicationScope.contextPath}/media">Media</a></li>
							<li><a href="${applicationScope.contextPath}/user/profile">Profile</a></li>
							<li><a href="#" style="display: none;">new</a></li>
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
					<li class="active"><a href="#tab1_n">Photos</a></li>
					<!--  -->
					<li><a href="#tab2_n">Video</a></li>

				</ul>
			</div>
			<div id="tabs_content_container_n" class="col">
			<c:if test="${!empty(targetUser)}">
				<span id="header_album">${targetUser}'s photos</span>
			</c:if>
			<c:if test="${empty(targetUser)}">
				<span id="header_album"></span>
			</c:if>
				<div id="tab1_n" class="tab_content_n" style="display: block;">
					<div class="tab-photo">

						<ul class="photo-one">
							<!--  -->
							<c:forEach items="${albums}" var="album">
								<c:if test="${album.albumName eq 'Untitled Album'}">
									<li><a href="javascript:;"
										onclick="javascript:populateAlbum('${album.description}','${album.userName}','${album.albumName}','${imageServerUrl}');">
											<c:forEach items="${album.photos}" begin="0" end="0"
												var="photo">
												<img
													src="${imageServerUrl}viewImage?id=${photo.photoId}&type=_Medium" />
											</c:forEach>
									</a><br /> <a href="javascript:;" class="tit-alb"
										onclick="javascript:populateAlbum('${album.description}','${album.userName}','${album.albumName}','${imageServerUrl}');">${album.albumName}</a>
										<span class="span-set" onClick="close_in_album(event,0,'','${album.albumName}','${album.userName}')"><img src="${applicationScope.contextPath}/resources/images/setting-alb.png" class="sett"/></span><span
										class="tit-pht">${fn:length(album.photos)} Photos</span></li>
								</c:if>
								<c:if test="${album.albumName ne 'Untitled Album'}">
									<li><a href="javascript:;"
										onclick="javascript:populateAlbum('${album.description}','${album.userName}','${album.albumName}','${imageServerUrl}');">
											<c:forEach items="${album.photos}" begin="0" end="0"
												var="photo">
												<img
													src="${imageServerUrl}viewImage?id=${photo.photoId}&type=_Medium" />
											</c:forEach>
									</a><br /> <a href="javascript:;" class="tit-alb"
										onclick="javascript:populateAlbum('${album.description}','${album.userName}','${album.albumName}','${imageServerUrl}');">${album.albumName}</a>
										<span class="span-set" onClick="close_in_album(event,0,'','${album.albumName}','${album.userName}')" ><img src="${applicationScope.contextPath}/resources/images/setting-alb.png" class="sett"/></span>
										<span class="tit-pht">${fn:length(album.photos)} Photos</span></li>
								</c:if>
							</c:forEach>
							<li><span onclick="location_pop();" class="new-alb">Upload
									Your Photos</span></li>
							<!--<li><a href="javascript:;"><img src="images/img.jpg" /></a><br />
									<a href="javascript:;" class="tit-alb">frdzzz!!!</a> <span
									class="tit-pht">2 photos</span></li> -->
						</ul>
						<div id="albumPhotos">
							<ul class="album-content gallery-pic clearfix photogallery"
								style="display: none;">

							</ul>
						</div>
						<div class="clear"></div>
						<div id="backButton" class="col none">
							<a class="callback gray-btn" href="javascript:;">Back</a>
						</div>
						<!-- 						<ul class="album-content gallery-pic clearfix photogallery"
								style="display: block;">
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>
							<li><a href="images/img.jpg" rel="prettyPhoto[gallery1]"><img
									src="images/img.jpg" /></a></li>

</ul> -->

					</div>
				</div>
				<div id="tab2_n" class="tab_content_n"></div>
			</div>
		</div>

		<%@ include file="suggestions.jsp"%>
		<%@ include file="trends.jsp"%>
	</div>



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
	<div class="man-li-up">
		<ul>
			<li><a href="#">Chat to @ abc..</a></li>
			<li><a href="#">Add or remove from the list</a></li>
			<li><a href="#">Block @abc</a></li>
		</ul>
	</div>

<div class="man-li-album">
    <ul>
    <li><a href="javascript:;" id="deleteIt"></a></li>
<!--     <li><a href="#">Add or remove Photoes</a></li>
    <li><a href="#">Block @abc</a></li> -->
    </ul>
    </div>

</body>
</html>
