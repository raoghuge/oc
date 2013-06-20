package com.cloud.controllers;

import java.security.Principal;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cloud.consts.CloudConstants;
import com.cloud.domain.Member;
import com.cloud.domain.Member.Roles;

import com.cloud.services.MemberService;

/**
 * @author Rao Handles and retrieves the login or denied page depending on the
 *         URI template
 */
@Controller
@RequestMapping("/")
public class AuthController
{

	private final static Logger logger = LoggerFactory.getLogger(AuthController.class);

	@Autowired
	MemberService memberService;

	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(@RequestParam(value = "requestToken", required = false) String requestToken, @RequestParam(value = "login_error", required = false) boolean error,
			Principal principal, HttpSession session, Model model)
	{
		logger.debug("Received request to show login page, error " + error);
		if (requestToken != null)
		{
			session.setAttribute("requestToken", requestToken);
		}
		if (error)
		{
			model.addAttribute("error", "Invalid username or password!");
		}

		return "signin";
	}

	@RequestMapping(value = "/validate", method = RequestMethod.GET)
	public @ResponseBody
	boolean validate(@RequestParam("username") String username, @RequestParam("email") String email)
	{
		boolean validateUserName = memberService.validUsername(username);
		if (validateUserName)
		{
			boolean validateUserEmail = memberService.validEmail(email);
			if (validateUserEmail)
				return true;

		} else
		{
			return true;
		}
		return false;
	}

	@RequestMapping(method = RequestMethod.POST, value = "/signup")
	public String register(@RequestParam(value = "displayName") String displayName, @RequestParam(value = "j_username") String username,
			@RequestParam(value = "j_password") String password, @RequestParam(value = "gender") String gender, @RequestParam(value = "dob") String dob,
			@RequestParam(value = "email") String email, Principal principal, HttpSession session, HttpServletRequest request, Model model)
	{
		logger.debug("Request to register a User");
		String kaptchaExpected = (String) request.getSession().getAttribute("KAPTCHA_SESSION_KEY");
		String kaptchaReceived = request.getParameter("kaptcha");

		if (kaptchaReceived == null || !kaptchaReceived.equalsIgnoreCase(kaptchaExpected) && displayName == null && password == null && email == null && username == null)
		{

			logger.debug("Captcha Wrong !!!");
			return "login";
		} else
		{

			try
			{
				if (validate(username, email))
				{
					Member member = memberService.save(username, displayName, password, "Set your info here", memberService.getUserImage("default", "_" + gender), gender,
							email, dob, null, "Cloud", "GMT+5:30", "Mumbai",0, Roles.ROLE_USER);

					memberService.setMemberInSession(member);
					logger.debug(member + "Successfulley Registered");
					if (member != null)
					{
						session.setAttribute("activeMember", member);
					}

					else
					{
						model.addAttribute(CloudConstants.MESSAGE, "Either Username or Email exists");
						return "signup";
					}

				}

				return "redirect:/user";
			} catch (Exception e)
			{
				model.addAttribute("displayName", displayName);
				model.addAttribute("j_username", username);
				model.addAttribute("error", e.getMessage());
				logger.error("The user is unable to register" + e);
				e.printStackTrace();
				return "signin";
			}

		}
	}

	/*
	 * @RequestMapping(value = "/forgotpassword", method = RequestMethod.GET)
	 * public @ResponseBody String
	 * forgotpassword(@RequestParam("forgotemailaddress") String
	 * forgotEmailAddress) {
	 * logger.debug("Received request for forgot password"); String
	 * response=memberService.findUserByEmail(forgotEmailAddress); if
	 * (response.equals("Success")) {
	 * logger.debug("Message Successfully sent for the forgot password"); return
	 * "Email sent Successfully"; } else if (response.equals("Error")) {
	 * logger.error("Not able to sent messag for the forgot password"); return
	 * "Some Error occured,Please try later, or try with some other Email Id"; }
	 * else if (response.equals("user not found")) { logger.error(
	 * "Unable to sent message to the user because the Email doesn't Exist");
	 * return "Email doesn't Exist,Please try with some other Email Id"; }
	 * 
	 * return ""; }
	 */

	@RequestMapping(value = "/denied", method = RequestMethod.GET)
	public String denied()
	{
		logger.debug("Received request to show denied page");
		return "denied";
	}

	@RequestMapping(value = "/signup", method = RequestMethod.GET)
	public String registerPage()
	{
		logger.debug("Received request to show register page");
		return "signup";
	}
	/*
	 * @RequestMapping(value = "/provider", method = RequestMethod.POST) public
	 * String userFromProviders(HttpServletRequest request, Principal principal,
	 * HttpSession session, Model map) {
	 * 
	 * logger.debug("Recieved request to register User"); String token =
	 * request.getParameter("token");
	 * 
	 * // Get the EngageService EngageService engageService =
	 * EngageServiceFactory.getEngageService();
	 * 
	 * 
	 * try { // Retrieve the Janrain user data UserDataResponse userDataResponse
	 * = engageService.authInfo(token); // boolean supportsSetStatus =
	 * engageService.supportsSetStatus(token); Profile profile =
	 * userDataResponse.getProfile(); String provider =
	 * profile.getProviderName(); // Address address = profile.getAddress();
	 * Date birthday = profile.getBirthday(); String preferedUsername =
	 * profile.getPreferredUsername(); String gender = profile.getGender();
	 * String displayName = profile.getDisplayName();
	 * 
	 * String identifier = profile.getIdentifier(); String email =
	 * profile.getEmail(); String photo = profile.getPhoto();
	 * 
	 * // List<String> friends = userDataResponse.getFriends();
	 * 
	 * 
	 * // User u = userService.findByUsername(preferedUsername); User u =
	 * memberService.findByEmail(email);
	 * 
	 * if(u == null) { u = new User(); u.setModified(false);
	 * u.setProfilePhoto(photo);
	 * 
	 * }else if(u!=null && u.getProvider().equals(SocialConstants.SOCIAL)){
	 * map.addAttribute("msg", "User already exists with this Email Address");
	 * return "/auth/login"; } u.setEmail(email);
	 * u.setUserName(preferedUsername); u.setInfo("About me...");
	 * u.setDisplayName(displayName);
	 * u.setPassword(RandomStringUtils.randomAlphabetic(16));
	 * 
	 * u.setGender(gender); u.setDob(birthday);
	 * 
	 * u.setProvider(provider); u.setIdentifier(identifier);
	 * u.setRoles(Roles.ROLE_USER);
	 * 
	 * memberService.setSuggestionList(u);
	 * 
	 * memberService.save(u); session.setAttribute("activeUser",u);
	 * memberService.setUserInSession(u);
	 * 
	 * logger.debug("The user is successfully registered now"+preferedUsername);
	 * // Location location = new Location("default country", "default city",
	 * 0.0, 0.0); // userService.setPreferedLocation(u.getUsername(), location);
	 * // System.out.println("set user pref. location to default"); }
	 * catch(Exception e) { logger.error("Error in Registering User : "+e);
	 * e.printStackTrace(); } return "redirect:/user";
	 * 
	 * }
	 */
}