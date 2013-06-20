package com.cloud.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.NamedIndexRepository;
import org.springframework.data.neo4j.repository.RelationshipOperationsRepository;

import com.cloud.accounts.Account;
import com.cloud.domain.OAuth;

/**
 * @author Rao
 */
public interface OAuthRepository extends GraphRepository<OAuth>,
		NamedIndexRepository<OAuth>, RelationshipOperationsRepository<OAuth> {
	
	
	OAuth findByAccessToken(String accessToken);
	OAuth findByUsername(String username);
	
	
}
