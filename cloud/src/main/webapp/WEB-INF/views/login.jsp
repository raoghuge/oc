<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="janrain" uri="http://janrain4j.googlecode.com/tags"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Social Graph</title>
  <link rel="shortcut icon" href="${applicationScope.contextPath}/resources/images/favicon.ico" />

<link rel="stylesheet"
	href="${applicationScope.contextPath}/resources/css/style.css"
	type="text/css" media="screen" />
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"
	type="text/javascript"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.2/jquery-ui.min.js"
	type="text/javascript"></script>
<script
	src="${applicationScope.contextPath}/resources/js/jquery.formLabels1.0.js"
	type="text/javascript"></script>
<script type="text/javascript">
	function open_pop() {
		document.getElementById('form1-pop').style.display = 'block';
		var fullname = document.getElementById("fullname").value;
		var email = document.getElementById("email").value;
		var password = document.getElementById("password").value;
		document.getElementById('popupfullname')
				.setAttribute('value', fullname);
		document.getElementById('popupemail').setAttribute('value', email);
		document.getElementById('popuppassword')
				.setAttribute('value', password);
	}
	function close_pop() {
		document.getElementById('form1-pop').style.display = 'none';
	}
	function open_forgot_pop() {
		document.getElementById('form2-pop').style.display = 'block';
	}
	function close_forgot_pop() {
		document.getElementById('form2-pop').style.display = 'none';
	}
	function open_forgot_send_pop() {
		document.getElementById('form3-pop').style.display = 'block';
	}
	function close_forgot_send_pop() {
		document.getElementById('form3-pop').style.display = 'none';
	}

	function open_pop_social() {
		document.getElementById('form-social-pop').style.display = 'block';

	}
	function close_pop_social() {
		document.getElementById('form-social-pop').style.display = 'none';

	}

	function send() {

		var forgotemailaddress = document.getElementById('forgotpopupemail').value;
		
		$
				.ajax({
					type : "GET",
					url : "${applicationScope.contextPath}/auth/forgotpassword",
					data : "forgotemailaddress=" + forgotemailaddress,
					success : function(response) {

						if (response == "notfound") {

						} else {
							//alert(response);
							
							$(".title-form").text(response);
							close_forgot_pop();
							open_forgot_send_pop();
							//window.location.href = "${applicationScope.contextPath}/auth/login";
						}
					},
					error : function(e) {
						console.log(e);

						return false;
					}
				});
	}
	
	function ok(){
		window.location.href = "${applicationScope.contextPath}/auth/login";
	}

	function validate() {
		var usernameForValidate = $("#popupchooseusername").val();
		var emailForValidate = $("#popupemail").val();
		var fullnameForValidate = $("#popupfullname").val();
		var passwordForValidate = $("#popuppassword").val();
		var kaptchaForValidate = $("#kaptcha").val();

		var email = $("#popupemail").val();
		var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		var testEmail = regex.test(email);

		if (fullnameForValidate.length == 0) {
			showSignUpErrorAlert("FullUserName is empty");
			$('#popupfullname').focus();
		} else if (emailForValidate.length == 0) {
			showSignUpErrorAlert("Email Address is empty");
			$("#popupemail").focus();
		} else if (testEmail == false) {
			showSignUpErrorAlert("Email Address is invalid.");
			$("#popupemail").focus();
		} else if (passwordForValidate.length == 0) {
			showSignUpErrorAlert("Password is empty");
			$("#popuppassword").focus();
		} else if (usernameForValidate.length == 0) {
			showSignUpErrorAlert("User Name is empty");
			$("#popupchooseusername").focus();
		} else if (kaptchaForValidate.length == 0) {
			showSignUpErrorAlert("Kaptcha is empty");
			$("#kaptcha").focus();
		} else {
			$.ajax({
				type : "GET",
				url : "${applicationScope.contextPath}/auth/validate",
				data : {
					username : usernameForValidate,
					email : emailForValidate,
					kaptcha : kaptchaForValidate,
					fullusername : fullnameForValidate,
					password : passwordForValidate
				},
				success : function(response) {

					if (response == "notfound") {

					} else {

						if (response != "signup") {
							showSignUpErrorAlert(response);
						} else {

							$("#createuser").submit();
						}
					}

				},
				error : function(e) {
					console.log(e);

					return false;
				}
			});
		}
	}

	function showAlert(msg) {
		$("#gif-main").html(msg);
		$('.gif-main').fadeIn(1000).fadeOut(3000);
	}
	function showSignUpErrorAlert(msg) {
		$("#error-main").html(msg);
		$('.error-main').fadeIn(1000).fadeOut(3000);
	}
</script>
<script type="text/javascript">
	$(function() {
		$('#kaptchaImage').click(
				function() {
					$(this).attr(
							'src',
							'${applicationScope.contextPath}/kaptcha.jpg?'
									+ Math.floor(Math.random() * 100));
				})
	});
</script>
<script>
	$(document).ready(function() {
		var abc = window.location.href;
		if (abc.indexOf("login_error=true") != -1) {
			
				showAlert('${error}');
			}
	
		var data = '${msg}';
		if(data != null && data != "")
		{
			showAlert(data);
		}
	});
</script>
</head>

<body>

	<div id="gif-main" class="gif-main"></div>

	<div id="form1-pop" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop">
				<div id="error-main" class="error-main"></div>
				<div class="close-btn">
					<div class="title-form">Join today.</div>
					<a href="javascript:close_pop()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="col" /></a>
				</div>
				<form action="${applicationScope.contextPath}/auth/signup"
					method="post" id="createuser">
					<span>Full Name</span> <input name="j_fullusername" type="text"
						value="" id="popupfullname" /> <span> Email Address</span> <input
						name="email" type="text" value="" id="popupemail" /> <span>Create
						Password</span> <input name="j_password" type="password" value=""
						id="popuppassword" /> <span>Choose your username</span> <input
						name="j_username" type="text" value="" id="popupchooseusername" />
					<span>Gender &nbsp;&nbsp;&nbsp;<input name="gender"
						type="radio" value="male" checked="checked" />Male <input
						name="gender" type="radio" value="female" />Female
					</span>
					<!--<input name="gender" type="text" value="" id="popupgender" />  -->
					<span>Type text in the box</span> <img id="kaptchaImage"
						src="${applicationScope.contextPath}/kaptcha.jpg" class="capimg" />
					<input name="kaptcha" type="text" value="" id="kaptcha"
						class="capt" /> <span class="captcha">Can't read the
						image? Click it to get a new one.</span> <input type="button"
						name="singnup" onclick="validate()" class="yellow-btn"
						value="Create my account" />
				</form>
			</div>
		</div>
	</div>

	<!-- Forgot Popup -->
	<div id="form2-pop" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop">
				<div class="close-btn">
					<div class="title-form">Forgot Password.</div>
					<a href="javascript:close_forgot_pop()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right" /></a>
				</div>

				<span>Enter your Email Address on which your password to be
					sent</span> <input name=forgotemailaddress type="text" value=""
					id="forgotpopupemail" /> <input type="submit" name="send"
					class="yellow-btn right" value="SEND" onclick="send()" style="width:80px" />
<div class="clear"></div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="clear"></div>
	</div>
	
	
	<!-- Message Sent for Forgot Password Popup -->
	<div id="form3-pop" style="display: none;">
		<div class="trans"></div>
		<div class="pop">
			<div class="main-pop">
				<div class="close-btn">
					<div class="title-form">Message.</div>
					<a href="javascript:close_forgot_send_pop()" title="Close"><img
						src="${applicationScope.contextPath}/resources/images/close.jpg"
						alt="Close" title="Close" class="right" /></a>
				</div>
					<!-- <span id="forgotSendMessage"></span> -->
					<input type="button" name="ok"	class="yellow-btn right" value="OK" onclick="ok()" style="width:80px" />
		<div class="clear"></div>
			</div>
			<div class="clear"></div>
		</div>
		<div class="clear"></div>
	</div>

	<div class="head-home">
		<div class="head-in">
			<span class="logo"><img
				src="${applicationScope.contextPath}/resources/images/logo_socialgraph.png"
				title="Social Graph" alt="Social Graph" /></span>
			<div class="log-rig">
				<form method="post"
					action="${applicationScope.contextPath}/j_spring_security_check"
					id="login">
					<input type="text" name="j_username" title="Username" value="Username" onfocus="if(this.value=='Username'){this.value='';}" onblur="if(this.value==''){this.value='Username';}"/>
					<input type="password" name="j_password"
						title="Password" value="Password" onfocus="if(this.value=='Password'){this.value='';}" onblur="if(this.value==''){this.value='Password';}" /> <input type="submit"
						class="sub blue-btn" value="Sign in"
						onclick="javascript:document.getElementById('login').submit();" />
				</form>
				<div class="clear"></div>
				<input name="" type="checkbox" value="" /><a href="">Remember
					me</a> | <a href="javascript:open_forgot_pop()">Forgot password?</a> <span>OR<br />
				<span class="login">Login with</span> <janrain:signInLink>
						<img
							src="${applicationScope.contextPath}/resources/images${applicationScope.contextPath}_icon.jpg"
							height="20"></img>
					</janrain:signInLink> <janrain:signInOverlay />
				</span>
			</div>
		</div>
	</div>

	<div class="home">
		<div class="head-log">
			<img
				src="${applicationScope.contextPath}/resources/images/home-bg.jpg"
				width="340" height="297" alt="" />
			<div class="log">
				<span>New user sign up</span> <input name="" type="text"
					value="Full Name" onfocus="if(this.value=='Full Name'){this.value='';}" onblur="if(this.value==''){this.value='Full Name';}" id="fullname" /> <input name=""
					type="text" value="Email" onfocus="if(this.value=='Email'){this.value='';}" onblur="if(this.value==''){this.value='Email';}" id="email" /> <input name=""
					type="password" value="Password" onfocus="if(this.value=='Password'){this.value='';}" onblur="if(this.value==''){this.value='Password';}" id="password" /> <input
					name="" type="submit" class="yellow-btn right" value="Sign up"
					onclick="open_pop()" />
			</div>
		</div>
	</div>

	<div class="home-m">
		<p></p>
	</div>

	<div class="footer">
		<div class="head-in">
			<span class="col"><a href="">About</a> | <a href="">Help</a> |
				<a href="">Terms</a> | <a href="">Privacy</a> | <a href="">Contact
					Us</a> <br /> Copyright &copy; 2013 Website Name. All rights reserved.</span>
			<span class="right">Site design and developed by <a href=""
				class="txt-dec">Dream Solutions</a>.
			</span>
		</div>
	</div>

</body>
</html>
