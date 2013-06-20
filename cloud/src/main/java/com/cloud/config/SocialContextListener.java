package com.cloud.config;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * Application Lifecycle Listener implementation class SocialContextListener
 *
 */
public class SocialContextListener implements ServletContextListener {

    /**
     * Default constructor. 
     */
    public SocialContextListener() {
        // TODO Auto-generated constructor stub
    }

	/**
     * @see ServletContextListener#contextInitialized(ServletContextEvent)
     */
    public void contextInitialized(ServletContextEvent arg0) {
      System.out.println("Context initialized....");      
      arg0.getServletContext().setAttribute("contextPath", arg0.getServletContext().getContextPath());
      try {
    	  arg0.getServletContext().setAttribute("GlobalSearchPath", PropertyConfiguration.getStringProperty("GlobalSearchPath", "http://54.234.75.138:8080/GlobalSearch"));
    	  arg0.getServletContext().setAttribute("URLShortner", PropertyConfiguration.getStringProperty("URLShortnerPath", "http://54.234.75.138:8080/urlshortner"));
    	  arg0.getServletContext().setAttribute("HostImages", PropertyConfiguration.getStringProperty("HostImagesPath", "http://54.234.75.138:8080/Media"));
      } catch(Exception e) {
    	  
      }
      ResourceAndFileUtils.setContextPath(arg0.getServletContext().getContextPath());
      ResourceAndFileUtils.setRealPath(arg0.getServletContext().getRealPath(""));
      
      System.out.println("Context Path :" + arg0.getServletContext().getContextPath());
      
      SocialContextService.setServletContext(arg0.getServletContext());
  	System.out.println("Servlet Context intialized....");
    }

	/**
     * @see ServletContextListener#contextDestroyed(ServletContextEvent)
     */
    public void contextDestroyed(ServletContextEvent arg0) {
       System.out.println("Context Distroyed");
    }
	
}
