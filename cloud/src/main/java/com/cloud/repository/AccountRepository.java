package com.cloud.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.NamedIndexRepository;
import org.springframework.data.neo4j.repository.RelationshipOperationsRepository;

import com.cloud.accounts.Account;

/**
 * @author Rao
 */
public interface AccountRepository extends GraphRepository<Account>,
		NamedIndexRepository<Account>, RelationshipOperationsRepository<Account> {
	
	
	Account findByAccountID(String accountID);
	
	
}
