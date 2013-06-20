package com.cloud.config;

import javax.servlet.ServletContext;
import javax.xml.ws.WebServiceContext;
import javax.xml.ws.handler.MessageContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

public class SocialContextService
{
	static WebApplicationContext webAppCtxt ;
	private static ClassPathXmlApplicationContext ctx;
	private static ServletContext servletContext;
	

	public static ServletContext getServletContext() {
		return servletContext;
	}



	public static void setServletContext(ServletContext servletContext) {
		SocialContextService.servletContext = servletContext;
	}



	public static Object getBean(WebServiceContext context,
			String beanName) {
		
		if (webAppCtxt != null)
            return webAppCtxt.getBean(beanName) ;
		
		ServletContext servletContext = (ServletContext) context.getMessageContext().get(MessageContext.SERVLET_CONTEXT);
		webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(servletContext); 
		return webAppCtxt.getBean(beanName);
	}



	public static Object getBean(String beanName) 
	{
		if (webAppCtxt != null)
		{
			return webAppCtxt.getBean(beanName) ;
		}
		if (webAppCtxt == null && servletContext != null)
		{
			webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(servletContext); 
			return webAppCtxt.getBean(beanName);
		}
		else
			try 
			{
				throw new Exception("Context not initialized...");
			} catch (Exception e) 
			{
				
				e.printStackTrace();
			}
		return null;
		
		
	}



	public static Object getBean(ServletContext context, String beanName)
	{
		if (servletContext != null)
		{
			webAppCtxt = WebApplicationContextUtils.getWebApplicationContext(servletContext); 
			return webAppCtxt.getBean(beanName);
		}
		else
			try {
				throw new Exception("Context not initialized...");
			} catch (Exception e) 
			{
				
				e.printStackTrace();
			}
		return null;
	}	
}
