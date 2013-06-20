package com.cloud.services;

import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.support.Neo4jTemplate;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cloud.config.PropertyConfiguration;
import com.cloud.domain.Member;
import com.cloud.domain.Member.Roles;
import com.cloud.domain.OAuth;
import com.cloud.repository.MemberRepository;
import com.cloud.repository.MemberRepositoryImpl;
import com.cloud.repository.OAuthRepository;

@Service

public class MemberService 
{
	
	@Autowired
	Neo4jTemplate template;
	
	@Autowired
	MemberRepository memberRepository;

	@Autowired
	OAuthRepository oAuthRepository;
	private static MemberRepositoryImpl MEMBER = new MemberRepositoryImpl();

	public void setMemberInSession(Member member) 
	{
			MEMBER.setUserInSession(member);	
	}

	public String getUserImage(String d, String gender) {
		try {
				return PropertyConfiguration.getStringProperty("ImageRepository",d)+"/"+gender+".png";
			} catch (Exception e) 
			{
				
				e.printStackTrace();
			}
		return null;	
		
	}

	@Transactional
	public Member save(String username, String displayName, String password,
			String info, String object, String gender, String email, String dob, Date lastLoggedIn, String provider, String tz, String location,
			long accountId, Roles roleUser) 
	{		
		Member m = new Member(username,displayName,password,info,object,gender,email,new Date(dob),lastLoggedIn,provider,tz,location,Roles.ROLE_USER);
		m.setAccountID(accountId);
		return memberRepository.save(m);
		
	}

	@Transactional
	public boolean validUsername(String username) 
	{
		Member m = memberRepository.findByUsername(username);
		if(m != null)		
		return false;
		else
		return true;
	}


	@Transactional
	public boolean validEmail(String email) 
	{
		Member m = memberRepository.findByEmail(email);
		if(m != null)		
		return false;
		else
		return true;
	}

	@Transactional
	public String findUserHome(String username) {
		Member m = memberRepository.findByUsername(username);
		if(m.getLastLogin() == null)
			return "profile";
		
		return m.getFavoritePage();
	}

	@Transactional
	public Member findByUsername(String name) {
		return memberRepository.findByUsername(name);
	}

	@Transactional
	public boolean updatePreferences(String name, String profileImage,
			String homePage) {
		Member member = memberRepository.findByUsername(name);
		member.setProfilePhoto(profileImage);
		member.setFavoritePage(homePage);
		Member m = memberRepository.save(member);		
		if(m != null)
		return true;
		else
			return false;
	}



	@Transactional
	public String validateUser(String username, String password, String accountId)
	{
		Member member = findByUsername(username);		
		if(member != null)
		{
		String pwd = member.getPassword();
		boolean valid = new Md5PasswordEncoder().isPasswordValid(pwd, password, "cewuiqwzie");
		if(valid)
		{
			OAuth oAuth = oAuthRepository.findByUsername(username);
			if(oAuth == null)
			{
				oAuth = new OAuth();
			}
			String access_token = RandomStringUtils.randomAlphanumeric(128);
			if(accountId != null)
				oAuth.setAccountID(Long.parseLong(accountId));
			else
				oAuth.setAccountID(member.getAccountID());
			oAuth.setAccessToken(access_token);			
			oAuth.setUsername(username);
			oAuth.setLastUpdated(Calendar.getInstance().getTimeInMillis());
			
			oAuthRepository.save(oAuth);
			setMemberInSession(member);
			return oAuth.getAccessToken();
		}
		}
		return null;
		
		
	}

}
