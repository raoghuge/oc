package com.cloud.repository;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.data.neo4j.template.Neo4jOperations;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.cloud.domain.Member;
import com.cloud.security.GraphUserDetails;
import com.cloud.security.GraphUserDetailsService;


/**
 * @author mh
 * @since 06.03.11
 */
public class MemberRepositoryImpl implements GraphUserDetailsService {

    @Autowired
    private Neo4jOperations template;
    
    @Autowired
    private MemberRepository repo;
    
       @Override
    public GraphUserDetails loadUserByUsername(String login) throws UsernameNotFoundException, DataAccessException {
        final Member user = findByUsername(login);
        if (user==null) throw new UsernameNotFoundException("Username not found: "+login);
        return new GraphUserDetails(user);
    }

    private Member findByUsername(String username) {
    	Member m = repo.findByUsername(username);
    	return m;
    	
    	
        //return template.lookup(Member.class,"username",username).to(Member.class).iterator().next();
    }

    @Override
    public Member getUserFromSession() {
        SecurityContext context = SecurityContextHolder.getContext();
        Authentication authentication = context.getAuthentication();
        Object principal = authentication.getPrincipal();
        if (principal instanceof GraphUserDetails) {
            GraphUserDetails userDetails = (GraphUserDetails) principal;
            return userDetails.getUser();
        }
        return null;
    }


  

    public void setUserInSession(Member user) {
        SecurityContext context = SecurityContextHolder.getContext();
        GraphUserDetails userDetails = new GraphUserDetails(user);
        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, user.getPassword(),userDetails.getAuthorities());
        context.setAuthentication(authentication);
    }


}
