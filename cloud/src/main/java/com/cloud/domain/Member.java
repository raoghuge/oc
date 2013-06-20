package com.cloud.domain;

import java.util.Date;

import org.codehaus.jackson.annotate.JsonProperty;
import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.Indexed;
import org.springframework.data.neo4j.annotation.NodeEntity;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.core.GrantedAuthority;

@NodeEntity
public class Member {
	private static final String SALT = "cewuiqwzie";
	
	@GraphId
	Long nodeId;

	@Indexed
	@JsonProperty
	String username;

	@Indexed
	String identifier;
	
	@JsonProperty
	String displayName;

	String password;

	String info;

	@JsonProperty
	String profilePhoto;

	String gender;

	@JsonProperty
	String email;

	Date dob;
	Date lastLogin;

	String address;
	String tz;
	String provider;
	
	String favoritePage;

	boolean isUserLocationOn = false;
	private Roles[] roles;

	private long accountID;
	
	public Member()
	{
	
	}
	public Member(String username, String displayName, String password,
			String info, String profilePhoto, String gender, String email, Date dob, Date lastLoggedIn, String provider, String tz, String location,
			Roles... roles)
	{
		this.username = username;
		this.displayName = displayName;
		this.password = encode(password);
		this.info = info;
		this.dob =dob;
		this.lastLogin = lastLoggedIn;
		this.gender=gender;
		this.profilePhoto = profilePhoto;
		this.tz = tz;
		this.address = location;
		this.provider = provider;
		this.roles=roles;
	}

	
	@Override
	public String toString() {
		return String.format("%s (%s)", displayName, username);
	}

	public void updatePassword(String old, String newPass1, String newPass2) {
		if (!password.equals(encode(old)))
			throw new IllegalArgumentException("Existing Password invalid");
		if (!newPass1.equals(newPass2))
			throw new IllegalArgumentException("New Passwords don't match");
		this.password = encode(newPass1);
	}

	public enum Roles implements GrantedAuthority {
		ROLE_USER, ROLE_ADMIN;

		@Override
		public String getAuthority() {
			return name();
		}
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;

		Member user = (Member) o;
		if (nodeId == null)
			return super.equals(o);
		return nodeId.equals(user.nodeId);

	}

	@Override
	public int hashCode() {

		return nodeId != null ? nodeId.hashCode() : super.hashCode();
	}

	private String encode(String password) {
		return new Md5PasswordEncoder().encodePassword(password, SALT);
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getInfo() {
		return info;
	}

	public void setInfo(String info) {
		this.info = info;
	}

	public String getProfilePhoto() {
		return profilePhoto;
	}

	public void setProfilePhoto(String profilePhoto) {
		this.profilePhoto = profilePhoto;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Date getDob() {
		return dob;
	}

	public void setDob(Date dob) {
		this.dob = dob;
	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getTz() {
		return tz;
	}

	public void setTz(String tz) {
		this.tz = tz;
	}

	public String getProvider() {
		return provider;
	}

	public void setProvider(String provider) {
		this.provider = provider;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String identifier) {
		this.identifier = identifier;
	}

	public boolean isUserLocationOn() {
		return isUserLocationOn;
	}

	public void setUserLocationOn(boolean isUserLocationOn) {
		this.isUserLocationOn = isUserLocationOn;
	}
	
	

	public String getFavoritePage() {
		return favoritePage;
	}
	public void setFavoritePage(String favoritePage) {
		this.favoritePage = favoritePage;
	}
	public Roles[] getRoles() {
		return roles;
	}

	public void setRoles(Roles[] roles) {
		this.roles = roles;
	}
	public long getAccountID()
	{
		return accountID;
	}
	public void setAccountID(long accountID)
	{
		this.accountID = accountID;
	}

	
}
