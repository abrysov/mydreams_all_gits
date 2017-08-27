package com.mydreams.android.service.response.bodys;

import com.mydreams.android.service.models.UserDto;

public class AuthorizeUserBody
{
	private String token;
	private UserDto user;

	public AuthorizeUserBody(String token, UserDto user)
	{
		if (token == null)
			throw new IllegalArgumentException("token == null");

		if (user == null)
			throw new IllegalArgumentException("user == null");

		this.token = token;
		this.user = user;
	}

	public String getToken()
	{
		return token;
	}

	public void setToken(String token)
	{
		this.token = token;
	}

	public UserDto getUser()
	{
		return user;
	}

	public void setUser(UserDto user)
	{
		this.user = user;
	}
}
