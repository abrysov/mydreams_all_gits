package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class UserActivityDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("user")
	private UserInfoDto user;

	@SerializedName("date")
	private String date;

	@SerializedName("text")
	private String text;

	@SerializedName("photos")
	private List<PhotoDto> photos;

	@SerializedName("dream")
	private DreamInfoDto dream;

	public String getDate()
	{
		return date;
	}

	public void setDate(final String date)
	{
		this.date = date;
	}

	public DreamInfoDto getDream()
	{
		return dream;
	}

	public void setDream(final DreamInfoDto dream)
	{
		this.dream = dream;
	}

	public int getId()
	{
		return id;
	}

	public void setId(final int id)
	{
		this.id = id;
	}

	public List<PhotoDto> getPhotos()
	{
		return photos;
	}

	public void setPhotos(final List<PhotoDto> photos)
	{
		this.photos = photos;
	}

	public String getText()
	{
		return text;
	}

	public void setText(final String text)
	{
		this.text = text;
	}

	public UserInfoDto getUser()
	{
		return user;
	}

	public void setUser(final UserInfoDto user)
	{
		this.user = user;
	}
}
