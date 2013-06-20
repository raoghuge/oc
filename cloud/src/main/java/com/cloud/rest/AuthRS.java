package com.cloud.rest;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import com.cloud.accounts.Account;
import com.cloud.config.SocialContextService;
import com.cloud.domain.Member;
import com.cloud.domain.Member.Roles;
import com.cloud.exceptions.APIException;
import com.cloud.filters.AuthFilter;
import com.cloud.services.AccountService;
import com.cloud.services.MemberService;

@Path("/auth")
public class AuthRS
{
	@javax.ws.rs.core.Context
	ServletContext context;

	@POST
	@Path("/signup")
	@Consumes({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML, })
	public Map<String,String> signup( @QueryParam(value = "displayName") String displayName,
			 @QueryParam(value = "j_username") String username,
			 @QueryParam(value = "j_password") String password,
			 @DefaultValue("other") @QueryParam(value = "gender") String gender,
			 @DefaultValue("1/1/2013") @QueryParam(value = "dob") String dob,
			 @DefaultValue("") @QueryParam(value = "email") String email)
			throws APIException
			{
		
			if(validateUser(username,email))
			{
				MemberService memberService = (MemberService) SocialContextService.getBean(context, "memberService");
				Member member = memberService.save(username,displayName,password,"Set your info here",memberService.getUserImage("default", "_" + gender),gender,email,dob,null,"Cloud","GMT+5:30","",Long.parseLong(AuthFilter.getAccountId()),Roles.ROLE_USER);
				
				if(member != null)
				{
					memberService.setMemberInSession(member);
					return Collections.singletonMap("result", "success");
				}
			}
			else
			{
			return Collections.singletonMap("result", "Username or email already present");
			}
			return Collections.singletonMap("result", "failed");
	}
			
	
	@POST
	@Path("/login")
	@Consumes({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML, })
	public Map<String,String> login(@QueryParam(value = "username") String username,
			 @QueryParam(value = "password") String password)
			throws APIException
			{
		
				MemberService memberService = (MemberService) SocialContextService.getBean(context, "memberService");
				String b = memberService.validateUser(username,password,AuthFilter.getAccountId());
							
				if(b != null)
				{			
					Map<String,String> result =  new HashMap<String,String>();
					result.put("result","success");
					result.put("access_token", b);
					return result;
					
				}
				else
				{
					return Collections.singletonMap("result", "Failed");
				}
			
			
	}
	
	@POST
	@Path("/account")
	@Consumes({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML })
	@Produces({ MediaType.APPLICATION_JSON, MediaType.APPLICATION_XML, })
	public Account createAccount(@QueryParam(value = "accountName") String accountName,@QueryParam(value = "adminPassword") String adminPassword)			
			{
		
			if(adminPassword.equals("raoraorao"))
			{
				AccountService accountService = (AccountService) SocialContextService.getBean(context, "accountService");
				
				Account account = accountService.getByAccountName(accountName);
				if(account != null)
					return account;
				else
					return accountService.saveAccount(accountName);
				
			}
			return null;
	}
			
	

	private boolean validateUser(String username, String email) 
	{
		MemberService memberService = (MemberService) SocialContextService.getBean(context, "memberService");
		boolean validateUserName = memberService.validUsername(username);
		if(validateUserName)
		{
		boolean validateUserEmail = memberService.validEmail(email);
		if(validateUserEmail)
			return true;		
		}
		else
		{
			return true;
		}
		return false;		
	}

}
