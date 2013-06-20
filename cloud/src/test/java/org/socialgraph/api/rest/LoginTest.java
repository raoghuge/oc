package org.socialgraph.api.rest;

import static org.junit.Assert.*;

import javax.ws.rs.core.MediaType;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;


public class LoginTest {

	private final static Logger log = LoggerFactory.getLogger(LoginTest.class);
	public static final String HTTP_URL = "http://localhost:8080/social/rs/";
	
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
	
	@Test
	public void testValidity()
	{
		webResourceCheckversion = client.resource(HTTP_URL+ "RegistrationRestService/validate");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").queryParam("email","yasmeenubest@gmail.com").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
	
	@Test
	public void Login()
	{
		/*webResourceCheckversion = client.resource(HTTP_URL+ "RegistrationRestService/validate");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").queryParam("email","yasmeenubest@gmail.com").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);*/
	}
	
}
