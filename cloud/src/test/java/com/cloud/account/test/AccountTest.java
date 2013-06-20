package com.cloud.account.test;

import static org.junit.Assert.*;

import java.util.List;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.neo4j.template.Neo4jOperations;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.cloud.accounts.Account;
import com.cloud.services.AccountService;

/**
 * @author mh
 * @since 04.03.11
 */


@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({"/social-test-context.xml"})
@Transactional
public class AccountTest {
    @Autowired AccountService accountService;
    
    @Autowired Neo4jOperations template;

    @Before public void setUp() 
    {
    	
     	
    }
  

    @Test
    public void testFindTwoMoviesButRestrictToOne() throws Exception 
    {
    	Account account = accountService.saveAccount("ourcloud.in");
    	assertNotNull(account);
    	System.out.println(account.toString());
       
    }
}
