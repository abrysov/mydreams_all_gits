package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class LikeDto
{
	@SerializedName("user")
	private UserInfoDto user;

	@SerializedName("date")
	private String dateStr;

	public String getDateStr()
	{
		return dateStr;
	}

	public void setDateStr(String dateStr)
	{
		this.dateStr = dateStr;
	}

	public UserInfoDto getUser()
	{
		return user;
	}

	public void setUser(UserInfoDto user)
	{
		this.user = user;
	}
}
