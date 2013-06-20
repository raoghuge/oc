package com.cloud.domain;

import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.Indexed;
import org.springframework.data.neo4j.annotation.NodeEntity;

@NodeEntity
public class OAuth
{
	@GraphId
	Long nodeId;
	
	@Indexed
	private long accountID;
	@Indexed
	private String username;
	private String accessToken;
	private long lastUpdated;
	private String requestToken;

	public long getAccountID()
	{
		return accountID;
	}

	public void setAccountID(long accountID)
	{
		this.accountID = accountID;
	}

	
	public String getUsername()
	{
		return username;
	}

	public void setUsername(String username)
	{
		this.username = username;
	}

	public String getAccessToken()
	{
		return accessToken;
	}

	public void setAccessToken(String accessToken)
	{
		this.accessToken = accessToken;
	}

	public long getLastUpdated()
	{
		return lastUpdated;
	}

	public void setLastUpdated(long lastUpdated)
	{
		this.lastUpdated = lastUpdated;
	}

	public String getRequestToken()
	{
		return requestToken;
	}

	public void setRequestToken(String requestToken)
	{
		this.requestToken = requestToken;
	}

}
