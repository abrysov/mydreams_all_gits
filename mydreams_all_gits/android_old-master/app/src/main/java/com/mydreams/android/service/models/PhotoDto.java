package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class PhotoDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("url")
	private String url;

	@SerializedName("thumbUrl")
	private String thumbUrl;

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getThumbUrl()
	{
		return thumbUrl;
	}

	public void setThumbUrl(String thumbUrl)
	{
		this.thumbUrl = thumbUrl;
	}

	public String getUrl()
	{
		return url;
	}

	public void setUrl(String url)
	{
		this.url = url;
	}

}
