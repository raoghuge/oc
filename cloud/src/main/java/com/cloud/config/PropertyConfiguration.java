package com.cloud.config;

import java.io.File;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URL;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;

public class PropertyConfiguration extends BasicPropertyConfiguration{
	
	private PropertyConfiguration() {

	}
	private static Object getProperty(Object propertySource, String key,
			Object defaultValue) throws ConfigurationException {
		Configuration c = null;
		if (propertySource instanceof String) {
			c = getPropertyConfiguration((String) propertySource);
		} else if (propertySource instanceof URL) {
			c = getPropertyConfiguration((URL) propertySource);
		} else if (propertySource instanceof File) {
			c = getPropertyConfiguration((File) propertySource);
		} else {
			c = getPropertyConfiguration();
		}

		if (defaultValue instanceof String) {
			return c.getString(key, (String) defaultValue);
		}
		if (defaultValue instanceof Integer) {
			return c.getInt(key, (Integer) defaultValue);
		}
		if (defaultValue instanceof BigDecimal) {
			return c.getBigDecimal(key, (BigDecimal) defaultValue);
		}
		if (defaultValue instanceof BigInteger) {
			return c.getBigInteger(key, (BigInteger) defaultValue);
		}
		if (defaultValue instanceof Boolean) {
			return c.getBoolean(key, (Boolean) defaultValue);
		}
		if (defaultValue instanceof Long) {
			return c.getLong(key, (Long) defaultValue);
		}
		// default
		return c.getString(key, (String) defaultValue);
	}

	/***
	 * PropertiesSource MUST be String=properties File Name or URL or a File
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static String getStringProperty(Object propertiesSource, String key,
			String defaultValue) throws ConfigurationException {
		return (String) getProperty(propertiesSource, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static String getStringProperty(String key, String defaultValue)
			throws ConfigurationException {
		return (String) getProperty(null, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @return
	 * @throws ConfigurationException
	 */
	public static String getStringPropertyRequired(String key)
			throws ConfigurationException {
		String s = (String) getProperty(null, key, null);

		if (s == null || s.isEmpty())
			throw new ConfigurationException("missing property " + key);

		return s;
	}

	/***
	 * PropertiesSource MUST be String=properties File Name or URL or a File
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static Integer getIntegerProperty(Object propertiesSource,
			String key, Integer defaultValue) throws ConfigurationException {
		return (Integer) getProperty(propertiesSource, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static Integer getIntegerProperty(String key, Integer defaultValue)
			throws ConfigurationException {
		return (Integer) getProperty(null, key, defaultValue);
	}

	public static Integer getIntegerPropertyRequired(String key)
			throws ConfigurationException {
		Integer s = (Integer) getProperty(null, key, null);

		if (s == null)
			throw new ConfigurationException("missing property " + key);

		return s;
	}

	/***
	 * PropertiesSource MUST be String=properties File Name or URL or a File
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static Boolean getBooleanProperty(Object propertiesSource,
			String key, Boolean defaultValue) throws ConfigurationException {
		return (Boolean) getProperty(propertiesSource, key, defaultValue);
	}

	/***
	 * PropertiesSource MUST be String=properties File Name or URL or a File
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static Boolean getBooleanProperty(String key, Boolean defaultValue)
			throws ConfigurationException {
		return (Boolean) getProperty(null, key, defaultValue);
	}

	/***
	 * PropertiesSource MUST be String=properties File Name or URL or a File
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static BigDecimal getBigDecimalProperty(Object propertiesSource,
			String key, BigDecimal defaultValue) throws ConfigurationException {
		return (BigDecimal) getProperty(propertiesSource, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static BigDecimal getBigDecimalProperty(String key,
			BigDecimal defaultValue) throws ConfigurationException {
		return (BigDecimal) getProperty(null, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static BigInteger getBigIntegerProperty(String key,
			BigInteger defaultValue) throws Exception {
		return (BigInteger) getProperty(null, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws Exception
	 */
	public static BigInteger getBigIntegerProperty(Object propertiesSource,
			String key, BigInteger defaultValue) throws ConfigurationException {
		return (BigInteger) getProperty(propertiesSource, key, defaultValue);
	}

	/***
	 * 
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws ConfigurationException
	 */
	public static Long getLongProperty(String key, Long defaultValue)
			throws ConfigurationException {
		return (Long) getProperty(null, key, defaultValue);
	}

	/***
	 * 
	 * @param propertiesSource
	 * @param key
	 * @param defaultValue
	 * @return
	 * @throws ConfigurationException
	 */
	public static Long getLongProperty(Object propertiesSource, String key,
			Long defaultValue) throws ConfigurationException {
		return (Long) getProperty(propertiesSource, key, defaultValue);
	}

}
