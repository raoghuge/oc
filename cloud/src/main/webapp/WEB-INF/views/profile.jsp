<!DOCTYPE html>
<%@ include file="global-include.jsp" %>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>?</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <!-- Le styles -->
    <link href="${applicationScope.contextPath}/resources/css/bootstrap.css" rel="stylesheet">
    <link href="${applicationScope.contextPath}/resources/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
     
      .sidebar-nav {
        padding: 9px 0;
      }
      .capimg {
		float: center;
		height: 31px;
		//width: 190px;
		}

      @media (max-width: 980px) {
        /* Enable use of floated navbar text */
        .navbar-text.pull-right {
          float: none;
          padding-left: 5px;
          padding-right: 5px;
        }
      }
    </style>
    <link href="${applicationScope.contextPath}/resources/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="../${applicationScope.contextPath}/resources/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="${applicationScope.contextPath}/resources/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="${applicationScope.contextPath}/resources/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="${applicationScope.contextPath}/resources/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="${applicationScope.contextPath}/resources/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="${applicationScope.contextPath}/resources/ico/favicon.png">


  </head>

  <body>
  		<%@ include file="top.jsp" %>

        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Sign Up</li>
              <li><a href="#">Basic Information</a></li>
              <li class="active"><a href="#">Preferrences & Picture</a></li>          
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        
        
        <div class="span9">
          <div class="hero-unit" style="visibility: block;">
        
            <fieldset>
              <legend>Choose your Profile Picture & Preferences</legend>
             <div class="group">
               <form class="bs-docs-example" id="imageUpload" action="${applicationScope.contextPath}/user/upload" enctype="multipart/form-data" method="post">
              <label>Profile Picture :    <input name="fileData" id="photo" type="file" placeholder="Browse file from here"/>         
              </form>
              </label>
              
              <c:if test="${not empty ProfileImage}">
              <div id="image">
              <img src="${ProfileImage}" width="150" height="180"></img>
              
              </div>
              </c:if>
             
              <form class="bs-docs-example" id="imageUpload" action="${applicationScope.contextPath}/user/savePreferences" method="post">
              <input type="hidden" name="profileImage" value="${ProfileImage}"></input>
              <label>Preferred Home Screen : 
              	<select name="homePage">
              		<option value="news">News</option>
              		<option value="mycloud">My Cloud</option>
              		<option value="social">Social</option>
              		
              	</select>
              </label>
              </div>
              
			 
              </div>
                         
                <div class="group">
                          	
                <button type="submit" class="btn">Save</button>
                <hr> 
          		</form>
              </div>
            </fieldset>
          
         </div>
	
         
	
   
	 <%@ include file="bottom.html" %>
    <!--/.fluid-container-->
</div> 
   <%@ include file="include.html" %>
	<script type="text/javascript">
	$(function() {
		$('#kaptchaImage').click(
				function() {
					$(this).attr(
							'src',
							'${applicationScope.contextPath}/kaptcha.jpg?'
									+ Math.floor(Math.random() * 100));
				});
	});
	
	
	 $(function() {
	    $('#dob').datetimepicker({
	      language: 'en',
	      pick12HourFormat: false	      
	    });
	  });
	 
	 $('#pwd').popover();
	
	 
	 $('#photo').mouseout(function() {
		
		 if($('#photo').val().length > 2 && "${ProfileImage}".length < 2)
		 {
			 alert('Upload request');			 
			 $('#imageUpload').submit();
		 }
		 
		});
	 
	</script>

  </body>
</html>
