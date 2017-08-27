package com.mydreams.android.service.response.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;

public class LoginResponseBody
{
	@Nullable
	@SerializedName("token")
	private String token;

	@Nullable
	public String getToken()
	{
		return token;
	}

	public void setToken(@Nullable String token)
	{
		this.token = token;
	}
}
