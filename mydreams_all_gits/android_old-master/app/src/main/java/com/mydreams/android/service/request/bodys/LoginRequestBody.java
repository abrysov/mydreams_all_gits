package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class LoginRequestBody
{
	@SerializedName("login")
	private String login;

	@SerializedName("password")
	private String password;

	public LoginRequestBody(String login, String password)
	{
		if (login == null)
			throw new IllegalArgumentException();

		if (password == null)
			throw new IllegalArgumentException();

		setLogin(login);
		setPassword(password);
	}

	public String getLogin()
	{
		return login;
	}

	public void setLogin(String login)
	{
		this.login = login;
	}

	public String getPassword()
	{
		return password;
	}

	public void setPassword(String password)
	{
		this.password = password;
	}
}
