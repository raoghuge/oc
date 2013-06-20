package com.cloud.services;

import java.util.Calendar;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.support.Neo4jTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cloud.accounts.Account;
import com.cloud.repository.AccountRepository;

@Service
public class AccountService 
{
	@Autowired
	Neo4jTemplate template;
	
	@Autowired
	AccountRepository accountRepository;

	/**
	 * Save account for user
	 * @param accountName
	 * @return
	 */
	@Transactional
	public Account saveAccount(String accountName)
	{
		Account account = new Account();
		account.setAccountID(Long.parseLong(RandomStringUtils.randomNumeric(5)));
		account.setAccountName(accountName);
		account.setAccountSecret(RandomStringUtils.randomAlphanumeric(15));
		account.setCreated(Calendar.getInstance().getTime());
		account = accountRepository.save(account);
		return account;
	}
	
	@Transactional
	public Account getByAccountName(String accountName)
	{
		return accountRepository.findByPropertyValue("accountName", accountName);
	}
}
