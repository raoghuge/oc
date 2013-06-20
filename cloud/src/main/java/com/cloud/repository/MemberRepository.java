package com.cloud.repository;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.data.neo4j.repository.NamedIndexRepository;
import org.springframework.data.neo4j.repository.RelationshipOperationsRepository;

import com.cloud.domain.Member;
import com.cloud.security.GraphUserDetailsService;

/**
 * @author Rao
 */
public interface MemberRepository extends GraphRepository<Member>,
		NamedIndexRepository<Member>, RelationshipOperationsRepository<Member>,
		GraphUserDetailsService {
	
	
	Member findByUsername(String username);
	
	Member findByDisplayName(String displayName);

	Member findByNodeId(Long nodeId);
	
	Member findByEmail(String email);
	
	/*	
	Iterable<User> findByUsernameLike(String criteria);
	
	Page<User> findByUsernameLike(String criteria, Pageable pageable);
	
	@Query(value="START m = node:__types__(className=\"org.socialgraph.domain.User\") WHERE m.displayName? =~ {like} RETURN m", elementClass = User.class)
	Page<User> findByDisplayNameLike(@Param("like") String like, Pageable pageable);
	
	@Query(value="START m = node:__types__(className=\"org.socialgraph.domain.User\") WHERE m.displayName? =~ {like} RETURN m", elementClass = User.class)
	Iterable<User> findByDisplayNameLike(@Param("like") String like);

	@Query("start user=node({0}) "
			+ " match user-[r:RATED]->movie<-[r2:RATED]-other-[r3:RATED]->otherMovie "
			+ " where r.stars >= 3 and r2.stars >= r.stars and r3.stars >= r.stars "
			+ " return user, avg(r3.stars) as rating, count(*) as cnt"
			+ " order by rating desc, cnt desc" + " limit 10")
	List<User> searchByUsernameOrName(String criteria);

	

	// find other users for start
	@Query(value = "start user=node({0}), user2=node:__types__(className=\"org.socialgraph.domain.User\")"
			+ " where not user-[:FOLLOW|FRIEND]->user2 and user=user2" +
			"  return user2  limit 20", elementClass = User.class)
	Iterable<User> getFollowSuggestionsOnStartUp(User user);

	// find optimized

	@Query("start user=node({0}), fof=node(*)	match p=shortestPath(user-[user2:FOLLOW|FRIEND*..2]->fof) 	where (not user-[:FRIEND|FOLLOW]->fof and user=fof)  and length(p)> 1 and not user-[:BLOCKED]->fof return distinct fof as toFollow, length(p) as followers order by followers limit 20")
	List<FollowSuggestion> getSuggestions(User user);

	
	
	//optimised connectors
	@Query("start user=node({0}), fof=node({1}) match p=(user-[:FOLLOW|FRIEND*1..2]->fof) where (not user-[:FOLLOW|FRIEND]->fof and user=fof) and (not user-[:BLOCKED]->fof) and (user<>fof) return distinct extract(n in nodes(p) : n.displayName) as usernames")
	List<List<String>> getGraph(User user1, User user2);
	

	@Query(value = "start m=node({0})" + " MATCH m-[s:SEND]->n"
			+ " return m.username as username,m.displayName as displayName,m.profilePhoto as profilePhoto, n.message as message, n.key? as key, s.when? as when ORDER BY when desc", elementClass = IMessageUIElement.class)
	List<IMessageUIElement> getMessagesOfUser(User user); 
	
//	@Query(value = "start m=node({0})" + " MATCH m-[s:SEND]->n"
//			+ " return m.username as username,m.displayName as displayName,m.profilePhoto as profilePhoto, n.message as message, n.key? as key, s.when? as when, s.viaUsername? as viaUsername ORDER BY when desc", elementClass = IMessageUIElement.class)
//	Page<IMessageUIElement> getMessagesOfUser(User user, Pageable page); 
	
	@Query(value = "start b=node({0})" + " MATCH b-[s:SEND]->c"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " ORDER BY s.when desc", elementClass = IFindStatus.class)
	Page<IFindStatus> getMessagesOfUser(User user, Pageable page); 

	@Query(value = "start root=node({0})" + " MATCH root-[:FRIEND]-a"
			+ " return a", elementClass = User.class)
	Iterable<User> getFriendsOfUser(User user);

	// @Query(value = "START root1=node({0}), root2=node({1})"
	// + " MATCH root1-[r:FRIEND]-root2"
	// + " delete r")
	// boolean removeFriend(User me, User friend);

	@Query(value = "START root1=node(*), root2=node(*)"
			+ " MATCH root1-[r:FRIEND]-root2"
			+ " WHERE root1.username={meusername} AND root2.username={friendusername}"
			+ " delete r")
	void removeFriend(@Param("meusername") String meusername,
			@Param("friendusername") String friendusername);

	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->b-[:SEND]->c "
			+ " return  b.username as username, b.displayName as displayName, c.message as message, "
			+ " c.when as when order by when desc limit 20")
	List<TrendResult> getMessageUpdatesFromFollowing(User user);

	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOWED_BY]->b-[:SEND]->c "
			+ " return  b.username as username, b.displayName as displayName, c.message as message, "
			+ " c.when as when order by when desc limit 20")
	List<TrendResult> getMessageUpdatesFromFollower(User user);

	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW|FRIEND]-b-[s:SEND]->c"
			+ " match a-[r]->b-[s:SEND]->c, a-[f]-b-[s:SEND]->c"
			+ " where type(r)=\"FOLLOW\" OR (type(f)=\"FRIEND\" AND f.status=" + SocialConstants.ACTIVE + ")"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when desc", elementClass = IFindStatus.class)
	Page<IFindStatus> getMessageUpdatesFromFriendsAndFollowing(User user, Pageable pageable);

	@Query(value = "start a=node({0})"
			+ " match a-[r]->b-[s:SEND]->c, a-[f]-b-[s:SEND]->c"
			+ " where type(r)=\"FOLLOW\" OR (type(f)=\"FRIEND\" AND f.status=" + SocialConstants.ACTIVE + ")"
			+ UserController.TRENDS_RETURN_CLAUSE_MESSAGE_FROM_SOME_RELATION
			+ " order by when desc")
	List<IMessageUIElement> getMessageUpdatesFromFriendsAndFollowing(User user);

//	@Query(value = "start a=node({0})"
//			+ " match a-[r:FOLLOW]->b-[:SEND]->c "
//			+ " return  distinct b.username as username, b.displayName as displayName, c.message as message, c.key? as key, r.__type__? as relType,"
//			+ " c.when? as when order by when desc")
//	List<IQueryResponse> findMessagesOfMyFollowing(User user);
	
//	@Query(value = "start a=node({0})"
//			+ " match a<-[r:FOLLOWED_BY]-b-[:SEND]->c "
//			+ " return  distinct b.username as username, b.displayName as displayName, c.message as message, c.key? as key, r.__type__? as relType,"
//			+ " c.when? as when order by when desc")
//	List<IQueryResponse> findMessagesOfMyFollowers(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FRIEND]-b-[:SEND]->c "
			+ " return  b.username as username, b.displayName as displayName, c.message as message, "
			+ " c.when? as when order by when desc limit 20")
	List<TrendResult> getMessageUpdatesFromFriends(User user);


	
	@Query(value = "start a=node({0})"
			+ " match a-[:FRIEND]-b-[:SEND]->c "
			+ " return distinct  b.username as username, b.displayName as displayName, c.message as message, "
			+ " c.when? as when order by when desc limit 20")
	List<TrendResult> getLatestUpdateFromFriends(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:IS_AT]->b"
			+ " return b", elementClass = Location.class)
	Location getUserLocation(User user);
	
	@Query(value = "start a=node(*)"
			+ " match a-[r:SEND]->b"
			+ " where a.username?={Username} AND b.key={Key}"
			+ " delete r")
	void deleteMessage(@Param("Username") String username, @Param("Key")String key);

	@Query(value="start a=node:__types__(className=\"org.socialgraph.domain.User\")"
		+ " match a-[:SEND]->m"
		+ " with a, m, max(m.when) as latest"
		+ " where a.username?={username} AND m.when?=latest"
		+ " return m", elementClass = Message.class)
	Message getLatestStatusOfUser(@Param("username") String username);
	
	@Query(value="start a=node({0})"
			+ " match a-[s:SEND]->m"
			+ " with m,s, max(s.when) as latest"
			+ " where s.when?=latest"
			+ " return m", elementClass = Message.class)
		Message getLatestStatusOfUser(User user);
	
//---------functions needed by FindService methods-------------------
	@Query(value = "start a=node({0})"
			+ " match a-[r:FOLLOWED_BY]->b"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFollowersByUser(User user);

	@Query(value = "start a=node({0})"
			+ " match a-[r:FOLLOW]->b"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFollowingByUser(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFriendsByUser(User user);
	
 //----------------------------------------------------------------
	@Query(value = "START root=node({0})"
			+ " match root-[r:FOLLOWED_BY]->b-[:IS_AT]->loc"
			+ " where loc.city?={1}"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFollowersOfUserFromLocation(User me, String city);
	
	@Query(value = "START root=node({0})"
			+ " match root-[r:FOLLOW]->b-[:IS_AT]->loc"
			+ " where loc.city?={1}"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFollowingsOfUserFromLocation(User me, String city);
	
	@Query(value = "START root=node({0})"
			+ " match root-[r:FRIEND]-b-[:IS_AT]->loc"
			+ " WHERE r.status=" + SocialConstants.ACTIVE + " AND loc.city?={1}"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findFriendsOfUserFromLocation(User me, String city);
	
 //------------------------------------------------------------------ 

	@Query(value = "START b=node:__types__(className=\"org.socialgraph.domain.User\")"
			+ " match b-[:IS_AT]->loc"
			+ " where loc.city?={0}"
			+ UserController.FIND_USER_RETURN_CLAUSE
			+ " ORDER BY b.username")
	List<IFindUser> findPeopleFromLocation(String city);
	
	//-=----------------Fetch Followers and Friends of users ------------------------	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]-b"
			+ " RETURN a")
	List<User> findFollowerOfUser(User user);
	
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ " RETURN a")
	List<User> findFriendsOfUser(User user);
	
	//------------------------------------------
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d<-[:FOLLOW]-b"
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowerOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d-[:FOLLOW]->b"
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowingOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d-[r:FRIEND]-b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFriendOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->d<-[:FOLLOW]-b"
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowerOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->d-[:FOLLOW]->b"
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowingOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->d-[r:FRIEND]-b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFriendOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-d<-[:FOLLOW]-b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowerOfFriend(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-d-[:FOLLOW]->b"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFollowingOfFriend(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r1:FRIEND]-d-[r2:FRIEND]-b"
			+ " WHERE r1.status=" + SocialConstants.ACTIVE + " AND r2.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_USER_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY b.displayName?")
	List<IFindUser> findFriendOfFriend(User user);
	
//-------messages of own, follower, following, friend-----------------

	@Query(value = "start b=node({0})"
			+ " match b-[s:SEND]->c"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesByUser(User user);
	
	@Query(value = "start b=node(*)"
			+ " match b-[s:SEND]->c"
			+ " where b.username?={username}"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesByUser(@Param("username")String username);
	
	@Query(value = "start b = node:__types__(className=\"org.socialgraph.domain.User\")"
			+ " match b-[s:SEND]->c-[:SENT_FROM]->l"
			+ " where l.city={city}"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	@Query(value = "start b = node:__types__(className=\"org.socialgraph.domain.User\"), loc = node:__types__(className=\"org.socialgraph.domain.Location\")"
			+ " match b-[s:SEND]->c"
			+ " where s.locationNodeId=loc.locationId AND loc.city?={city} "
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> getMessagesSentFromDynamicLocation(@Param("city") String city);
	
	@Query(value = "start b = node:__types__(className=\"org.socialgraph.domain.User\"), loc = node:__types__(className=\"org.socialgraph.domain.Location\")"
			+ " match b-[s:SEND]->c"
			+ " where s.locationNodeId=loc.locationId AND b.username={username} AND loc.city?={city} "
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> getMessagesSentByDynamicUserFromDynamicLocation(@Param("city") String city, @Param("username") String user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FOLLOWED_BY]->b-[s:SEND]->c"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FOLLOW]->b-[s:SEND]->c"
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-b-[s:SEND]->c"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_STATUS_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFriend(User user);

//-------------------messages of fof------------------------------------------
	
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d<-[:FOLLOW]-b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	@Query(value = "START a=node({0})"
			+ " MATCH a<-[:FOLLOW]-d<-[:FOLLOW]-b"
			+ " WITH distinct a,d,b"
			+ " MATCH b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " ORDER BY when desc")
	List<IFindStatus> findMessagesOfFollowerOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d-[:FOLLOW]->b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowingOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a<-[:FOLLOW]-d-[r:FRIEND]-b-[s:SEND]->c"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFriendOfFollower(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->b<-[:FOLLOW]-b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowerOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->b-[:FOLLOW]->b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowingOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FOLLOW]->d-[r:FRIEND]-b-[s:SEND]->c"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFriendOfFollowing(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[r:FRIEND]-d<-[:FOLLOW]-b-[s:SEND]->c"
			+ " WHERE r.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowerOfFriend(User user);
	
	@Query(value = "start a=node({0})"
			+ " match a-[:FRIEND]-d-[:FOLLOW]->b-[s:SEND]->c"
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFollowingOfFriend(User user);

	@Query(value = "start a=node({0})"
			+ " match a-[r1:FRIEND]-d-[r2:FRIEND]-b-[s:SEND]->c"
			+ " WHERE r1.status=" + SocialConstants.ACTIVE + " AND r2.status=" + SocialConstants.ACTIVE
			+ UserController.FIND_STATUS_2ND_LEVEL_RELATION_RETURN_CLAUSE
			+ " order by s.when? desc")
	List<IFindStatus> findMessagesOfFriendOfFriend(User user);

	//--------------------------------------------------------------------
//	@Query(value = "start a=node({0})"
//			+ " match a-[r:FRIEND|FOLLOW]->b"
//			+ " return b"
//			+ " order by b.username")
//	List<User> getListOfFriendsAndFollowings(User user);
	
	@Query(value = "start a=node:User(username={username})"
			+ " match a-[r:FRIEND|FOLLOW]->b"
			+ " return b"
			+ " order by b.username")
	List<User> getListOfFriendsAndFollowings(@Param("username") String username);
	
	@Query(value="start m = node(*) where m.username? =~ {like} return m")
	List<User> getUsersFromSocialGraph(@Param("like") String like);
	
	@Query(value="START a=node(*) match a<-[r:FRIEND]-b where has(r.status) and r.status = -1 and b.username={Username} RETURN a")
	List<User> checkFriendRequest(@Param("Username") String username);
	
	@Query(value="START a=node(*) match a-[r:FRIEND]-b where a.username?={me} and b.username?={friend} RETURN r")
	Friend getFriendRelationship(@Param("me") String me, @Param("friend") String friend);
	@Query(value="START root=node:__types__(className=\"org.socialgraph.domain.User\") where root.username?={username} or root.email?={email} RETURN root")
	User findByUsernameAndEmail(@Param("username") String username, @Param("email") String email);
	
	*/
}
