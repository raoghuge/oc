package com.cloud.config;

public class ResourceAndFileUtils 
{
	public static String USER_IMG_PATH;
	public static String CONTEXT_PATH;
	public static String REAL_PATH;
	public static String URL = "http://54.234.75.138:8080/social";	
//	public static String URL = "http://192.168.1.55:8080/social";
//	public static String URL = "http://localhost:8080/social";
	

	public static String getUserDefaultImageByGender(String gender) 
	{
		if(gender.trim().equals("male"))		
			return URL+"/resources/users/default_male.png";
		else
			return URL+"/resources/users/default_female.png";
	}

	public static String getUserImageURL(String imageFileName) 
	{		
			return REAL_PATH+"/resources/users/"+imageFileName;		
	}
	public static String getRealPath() 
	{		
			return REAL_PATH+"/resources/users/";		
	}
	public static String getDefaultImagePath() 
	{		
			return REAL_PATH+"/resources/users/";		
	}
	public static String getUserPublicImageURL(String imageFileName) 
	{		
			return URL+"/resources/users/"+imageFileName;		
	}
	
	
	public static void setContextPath(String contextPath) {
		CONTEXT_PATH = contextPath;
		
	}

	public static void setRealPath(String realPath) {
		REAL_PATH = realPath;
		
	}

	public static void setURL(String string) {
		URL = string;
		
	}
	

}
