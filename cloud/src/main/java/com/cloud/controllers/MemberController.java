package com.cloud.controllers;

import java.io.File;
import java.security.Principal;

import javax.servlet.http.HttpSession;
import javax.ws.rs.Produces;

import org.apache.commons.configuration.ConfigurationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.cloud.beans.ImageUpload;
import com.cloud.config.PropertyConfiguration;
import com.cloud.consts.CloudConstants;
import com.cloud.domain.Member;
import com.cloud.services.MemberService;

@Controller
@RequestMapping("/user")
public class MemberController 
{

	private final static Logger logger = LoggerFactory.getLogger(MemberController.class);
	
	@Autowired
	MemberService memberService;


	@RequestMapping(method = RequestMethod.GET)
	public String userHome(Principal principal, HttpSession session, Model model) 
	{	
		String username = principal.getName();
		session.setAttribute(CloudConstants.loggedInUsername, username);
		Member member = memberService.findByUsername(principal.getName());
		if(member != null && member.getProfilePhoto() != null && !member.getProfilePhoto().equals(""))
			model.addAttribute("ProfileImage",member.getProfilePhoto());
		return member.getFavoritePage();
		
		
	}
	
	
	@RequestMapping(value = "/profile", method = RequestMethod.GET)
	public String showProfile(Principal principal, HttpSession session, Model model) 
	{	
	
		 return "profile";
	}
	
	@RequestMapping(value="/savePreferences", method =RequestMethod.POST)
	public String savePreferences(@RequestParam String profileImage, @RequestParam String homePage,Principal principal)
	{
		boolean updated = memberService.updatePreferences(principal.getName(),profileImage, homePage);
		
		return "signup";
	}

	@RequestMapping(value = "/upload", method = RequestMethod.POST)
	public String uploadImage(ImageUpload uploadForm, Model model, HttpSession session, Principal principal) {
		try {
			logger.debug("Request to upload image of the User : "+principal.getName());
			MultipartFile file = uploadForm.getFileData();
			if (file != null) 
			{				
				if (file.getSize() > 0) 
				{
					
					String filePath = PropertyConfiguration.getStringProperty("profileImagesPath", "/cloud/user/");
					File p = new File(filePath);
					if(!p.exists() || !p.isDirectory())
						p.mkdir();
					
					File f = new File(filePath+file.getOriginalFilename());
					
					file.transferTo(f);
					String uploadedFile = getPublicPath(file.getOriginalFilename());
					model.addAttribute("ProfileImage",uploadedFile);
				}
			}
		}
		catch (Exception e) {
			logger.error("Error in Uploading Image of the User : "+principal.getName()+" The Error Details :"+e);
		}
		return "profile";
	}


	private String getPublicPath(String fileName) {
		String imageURL;
		try {
			imageURL = PropertyConfiguration.getStringProperty("profileImageURL", "http://ourcloud.in/user/");
			return  imageURL+fileName;
		} catch (ConfigurationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}


}

