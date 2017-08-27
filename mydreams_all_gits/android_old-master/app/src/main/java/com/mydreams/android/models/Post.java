package com.mydreams.android.models;

import com.mydreams.android.service.models.PostDto;

public class Post extends PostInfo
{
	private UserInfo owner;
	private boolean liked;

	public Post()
	{
	}

	public Post(final PostDto dto)
	{
		super(dto);

		liked = dto.isLiked();
		owner = new UserInfo(dto.getOwner());
	}

	public UserInfo getOwner()
	{
		return owner;
	}

	public void setOwner(final UserInfo owner)
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
