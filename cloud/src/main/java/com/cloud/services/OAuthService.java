package com.cloud.services;

import java.util.Collections;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.support.Neo4jTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cloud.consts.CloudConstants;
import com.cloud.domain.OAuth;
import com.cloud.repository.OAuthRepository;

@Service
public class OAuthService
{
	@Autowired
	Neo4jTemplate template;
	
	@Autowired
	OAuthRepository oAuthRepository;

	@Transactional
	public  Map<String, String> validateToken(String access_token)
	{
		OAuth oAuth = oAuthRepository.findByAccessToken(access_token);
		if(oAuth != null)
			return Collections.singletonMap(CloudConstants.USERNAME, oAuth.getUsername());
		else
			return Collections.singletonMap(CloudConstants.ERROR,"Invalid access token");
	}
	
}
