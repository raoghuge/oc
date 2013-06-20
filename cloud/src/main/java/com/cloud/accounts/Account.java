package com.cloud.accounts;

import java.util.Date;

import org.codehaus.jackson.annotate.JsonProperty;
import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.Indexed;
import org.springframework.data.neo4j.annotation.NodeEntity;

@NodeEntity
public class Account
{
	@GraphId
	Long nodeId;

	@Indexed
	@JsonProperty
	private long accountID;
	@JsonProperty
	private String accountSecret;
	@JsonProperty
	private String accountName;
	@JsonProperty
	private Date created;
	@JsonProperty
	private Date expiry;

	public long getAccountID()
	{
		return accountID;
	}

	public void setAccountID(long accountID)
	{
		this.accountID = accountID;
	}

	public String getAccountSecret()
	{
		return accountSecret;
	}

	public void setAccountSecret(String accountSecret)
	{
		this.accountSecret = accountSecret;
	}

	public String getAccountName()
	{
		return accountName;
	}

	public void setAccountName(String accountName)
	{
		this.accountName = accountName;
	}

	public Date getCreated()
	{
		return created;
	}

	public void setCreated(Date created)
	{
		this.created = created;
	}

	public Date getExpiry()
	{
		return expiry;
	}

	public void setExpiry(Date expiry)
	{
		this.expiry = expiry;
	}

	@Override
	public String toString()
	{
		return "Account [nodeId=" + nodeId + ", accountID=" + accountID + ", accountSecret=" + accountSecret + ", accountName=" + accountName + ", created=" + created
				+ ", expiry=" + expiry + "]";
	}

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((nodeId == null) ? 0 : nodeId.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Account other = (Account) obj;
		if (nodeId == null)
		{
			if (other.nodeId != null)
				return false;
		} else if (!nodeId.equals(other.nodeId))
			return false;
		return true;
	}

}
