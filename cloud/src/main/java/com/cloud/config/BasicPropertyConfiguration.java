package com.cloud.config;

import java.io.File;
import java.net.URL;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;



public abstract class BasicPropertyConfiguration {
	private static final String defaultPropertyFile = "common.properties";
	private static Configuration _defaultConfiguration = null;
	public BasicPropertyConfiguration() {

	}
	public static String getDefaultConfigurationFile() {
		return defaultPropertyFile;
	}
	protected static Configuration getPropertyConfiguration() throws ConfigurationException {
		if (_defaultConfiguration == null) 
		{
			_defaultConfiguration = getPropertyConfiguration(defaultPropertyFile);
		}
		return _defaultConfiguration;
	}
	protected static Configuration getPropertyConfiguration(
			String propertiesFile) throws ConfigurationException {
		try
		{
			return new PropertiesConfiguration(propertiesFile);
		}
		catch (org.apache.commons.configuration.ConfigurationException e)
		{
			throw new ConfigurationException(e);
		}
	}
	protected static Configuration getPropertyConfiguration(File file)
			throws ConfigurationException {
		try
		{
			return new PropertiesConfiguration(file);
		}
		catch (org.apache.commons.configuration.ConfigurationException e)
		{
			throw new ConfigurationException(e);
		}
	}
	protected static Configuration getPropertyConfiguration(URL url)
			throws ConfigurationException {
		try
		{
			return new PropertiesConfiguration(url);
		}
		catch (org.apache.commons.configuration.ConfigurationException e)
		{
			throw new ConfigurationException(e);
		}
	}
}
