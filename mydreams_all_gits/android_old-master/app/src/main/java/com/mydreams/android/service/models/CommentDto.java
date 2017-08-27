package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class CommentDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("user")
	private UserInfoDto user;

	@SerializedName("date")
	private String dateStr;

	@SerializedName("text")
	private String text;

	@SerializedName("isliked")
	private boolean isLiked;

	public boolean isliked()
	{
		return isLiked;
	}

	public String getDateStr()
	{
		return dateStr;
	}

	public void setDateStr(String dateStr)
	{
		this.dateStr = dateStr;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getText()
	{
		return text;
	}

	public void setText(String text)
	{
		this.text = text;
	}

	public UserInfoDto getUser()
	{
		return user;
	}

	public void setUser(UserInfoDto user)
	{
		this.user = user;
	}

	public void setLiked(boolean liked)
	{
		this.isLiked = liked;
	}
}
