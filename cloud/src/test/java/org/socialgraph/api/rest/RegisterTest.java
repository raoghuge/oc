package org.socialgraph.api.rest;

import javax.ws.rs.core.MediaType;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

public class RegisterTest 
{
	private final static Logger log = LoggerFactory.getLogger(RegisterTest.class);
	public static final String HTTP_URL = "http://ourcloud.in:80/cloud/rs/";
	
	public WebResource webResourceCheckversion;
	public ClientResponse responseCheckversion;
	public Client client;
	
	@Before
	public void setUp() throws Exception 
	{
		client = Client.create();
	}

	@After
	public void tearDown() throws Exception 
	{
	}

	@Test
	public void test()
	{
		//fail("Not yet implemented");
	}
	
/*	@Test
	public void register()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "auth/signup");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion
				.queryParam("displayName","Rao R Ghuge")
				.queryParam("j_username","raog")
				.queryParam("j_password","raog")
				.queryParam("gender","male")
				.queryParam("dob","1/2/2010")
				.queryParam("email","rrg@gmail.com")
				.queryParam("account_id","55467")
				.queryParam("account_secret","dMeI4g3VQFVzz7U")
				.type(MediaType.APPLICATION_JSON)
				.post(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		System.out.println("Response is : "+response);
	}
	*/
	@Test
	public void login()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "auth/login");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion				
				.queryParam("username","raog")
				.queryParam("password","raog")
				.queryParam("account_id","55467")
				.queryParam("account_secret","dMeI4g3VQFVzz7U")
				.type(MediaType.APPLICATION_JSON)
				.post(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		System.out.println("Response is : "+response);
	}
	/*@Test
	public void createAccountTest()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "auth/account");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion				
				.queryParam("accountName","ourcloud.in")
				.queryParam("adminPassword","raoraorao")				
				.type(MediaType.APPLICATION_JSON)
				.post(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		System.out.println("Response is : "+response);
	}*/
}
