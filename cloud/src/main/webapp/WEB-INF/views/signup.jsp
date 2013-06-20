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
      <script src="resources/js/html5shiv.js"></script>
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
              <li ><a href="#">Basic Information</a></li>
           <!--    <li><a href="#">Links</a></li>
             
              <li class="nav-header">Sidebar</li>
              <li><a href="#">Link</a></li>
             
              <li class="nav-header">Sidebar</li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li>
              <li><a href="#">Link</a></li> -->
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        
        
        <div class="span9">
          <div class="hero-unit">
          <form class="bs-docs-example" action="${applicationScope.contextPath}/signup" method="post">
            <fieldset>
              <legend>Sign Up</legend>
             <div class="group">
              <label>Username :    <input name="j_username" type="text" placeholder="Type your username"/></label>
              <label>Password : <input id="pwd" name="j_password" type="password" placeholder="Enter Password" data-toggle="popover" data-placement="right" data-content="Password should be min 6 characters long" data-original-title="Guidelines..." data-delay="{show: 500, hide: 100 }"> </input></label>
              <label>Re-Enter Password : <input type="password" placeholder="Enter password again"></input></label>
              <label>Email :    <input name="email" type="text" placeholder="Type your email"/></label>
              </div>
              <div class="group">
               <label>Display Name :    <input name="displayName" type="text" placeholder="Display name"/></label>
               <label>Gender:    <select name="gender"><option>Male</option><option>Female</option><option>Other</option></select></label>
                <label>Date of Birth:
                <div id="dob" class="input-append">
						<input name="dob" data-format="MM/dd/yyyy" type="text"></input>
						<span class="add-on"> 
						<i data-time-icon="icon-time" data-date-icon="icon-calendar"> </i> 
						</span>
				</div>
			
			 </label>
              </div>
             <div class="group">
              <label>Type text in the box 
              <img id="kaptchaImage" src="${applicationScope.contextPath}/kaptcha.jpg" class="capimg" /> <span class="help-block">Can't read the image? Click it to get a new one.</span>  </label>
               <label><input name="kaptcha" type="text" value="" id="kaptcha" class="capt" /></label> 
             </div>
              
                <div class="group">
              <label class="checkbox"> <input type="checkbox"> Remember me  </label>
             	
                <button type="submit" class="btn">Save</button>
              <hr> 
              </div>
            </fieldset>
          </form>
         </div>

       
	 
   
	 <%@ include file="bottom.html" %>
    </div><!--/.fluid-container-->

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
	
	</script>

  </body>
</html>
