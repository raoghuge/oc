package com.cloud.security;


import org.springframework.dao.DataAccessException;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import com.cloud.domain.Member;


/**
 * @author mh
 * @since 08.11.11
 */
public interface GraphUserDetailsService extends UserDetailsService {
    @Override
    GraphUserDetails loadUserByUsername(String login) throws UsernameNotFoundException, DataAccessException;

    Member getUserFromSession();

  
}
