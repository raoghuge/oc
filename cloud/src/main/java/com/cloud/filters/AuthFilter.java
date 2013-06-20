package com.cloud.filters;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.cloud.config.SocialContextService;
import com.cloud.consts.CloudConstants;
import com.cloud.exceptions.AuthException;
import com.cloud.services.MemberService;
import com.cloud.services.OAuthService;

/**
 * Servlet Filter implementation class AuthFilter
 */
public class AuthFilter implements Filter
{

	static ThreadLocal<String> token = new ThreadLocal<String>();

	/**
	 * Default constructor.
	 */
	public AuthFilter()
	{
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy()
	{
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException
	{

		HttpServletRequest req = (HttpServletRequest) request;
		String path = req.getRequestURI();

		if (!(path.contains("/login") || path.contains("/signup")))
		{
			String at = req.getParameter("access_token");
			if (at == null)
				at = req.getHeader("access_token");

			token.set(at);
		}
		else
		{
			String accountId = request.getParameter("account_id");
			String accountSecret = request.getParameter("account_secret");
			if(validateAccount(accountId,accountSecret))
			{
				token.set(accountId);
			}
		}

		chain.doFilter(request, response);

	}

	private boolean validateAccount(String accountId, String accountSecret)
	{		
		return true;
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException
	{
		// TODO Auto-generated method stub
	}

	public static String authorize() throws AuthException
	{
		OAuthService oAuthService = (OAuthService) SocialContextService.getBean("oAuthService");
		Map<String, String> response = oAuthService.validateToken(token.get());
		if (response != null && response.get(CloudConstants.ERROR) == null)
		{
			return response.get(CloudConstants.USERNAME);
		} else
			throw new AuthException(response.get(CloudConstants.ERROR));

	}
	
	public static String getAccountId()
	{
		return token.get();
	}
}
