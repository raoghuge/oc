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

public class LocationTest 
{
	private final static Logger log = LoggerFactory.getLogger(LocationTest.class);
	public static final String HTTP_URL = "http://localhost:8080/cloud/rs/";
	
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
	public void getLocation()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Location/getLocation");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","harshana").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
	
	
	@Test
	public void setLocation()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Location/setLocation");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").queryParam("city","Mumbai").queryParam("country","India").queryParam("latitude","1.2644").queryParam("longitude","13.64561").type(MediaType.APPLICATION_JSON).post(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}

}
