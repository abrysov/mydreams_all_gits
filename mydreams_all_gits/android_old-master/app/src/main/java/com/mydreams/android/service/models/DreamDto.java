package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class DreamDto extends DreamInfoDto
{
	@SerializedName("owner")
	private UserInfoDto owner;

	@SerializedName("isliked")
	private boolean isLiked;

	public UserInfoDto getOwner()
	{
		return owner;
	}

	public void setOwner(UserInfoDto owner)
	{
		this.owner = owner;
	}

	public boolean isLiked()
	{
		return isLiked;
	}

	public void setIsLiked(boolean isLiked)
	{
		this.isLiked = isLiked;
	}
}
