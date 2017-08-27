package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class LoginSocialNetworkRequestBody
{
	@SerializedName("token")
	private String token;

	public LoginSocialNetworkRequestBody(String token)
	{
		if (token == null)
			throw new IllegalArgumentException();

		setToken(token);
	}

	public String getToken()
	{
		return token;
	}

	public void setToken(String token)
	{
		this.token = token;
	}
}
