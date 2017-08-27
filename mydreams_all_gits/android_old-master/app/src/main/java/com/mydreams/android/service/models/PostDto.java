package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class PostDto extends PostInfoDto
{
	@SerializedName("isliked")
	private boolean liked;

	@SerializedName("owner")
	private UserInfoDto owner;

	public UserInfoDto getOwner()
	{
		return owner;
	}

	public void setOwner(final UserInfoDto owner)
	{
		this.owner = owner;
	}

	public boolean isLiked()
	{
		return liked;
	}

	public void setLiked(final boolean liked)
	{
		this.liked = liked;
	}
}
