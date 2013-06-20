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

public class MessageTest 
{
	private final static Logger log = LoggerFactory.getLogger(MessageTest.class);
	public static final String HTTP_URL = "http://localhost:8080/social/gateway/rs/";
	
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
	public void getMessageUpdateFromFriends()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Messages/getMessagesFromFriend");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
	
	@Test
	public void getMessageUpdatesFromFollowing()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Messages/getMessageUpdatesFromFollowing");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
	
	@Test
	public void getMessageUpdatesFromFollowers()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Messages/getMessageUpdatesFromFollowers");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
	
	@Test
	public void getMessageUpdatesFromFriendsAndFollowing()
	{
		webResourceCheckversion = client.resource(HTTP_URL
				+ "Messages/getMessageUpdatesFromFriendsAndFollowing");
		System.out.println(webResourceCheckversion);
		responseCheckversion = webResourceCheckversion.queryParam("username","yasmeen").type(MediaType.APPLICATION_JSON).get(ClientResponse.class);
		String response = responseCheckversion.getEntity(String.class);
		log.debug("Response is : "+response);
	}
}
