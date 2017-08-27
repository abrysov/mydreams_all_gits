package com.mydreams.android.models;

import com.mydreams.android.service.models.DreamDto;

import org.parceler.Parcel;

@Parcel(Parcel.Serialization.BEAN)
public class Dream extends DreamInfo
{
	private UserInfo owner;
	private boolean isLiked;

	public Dream()
	{
	}

	public Dream(DreamDto dto)
	{
		super(dto);

		if (dto.getOwner() != null)
		{
			owner = new UserInfo(dto.getOwner());
		}

		isLiked = dto.isLiked();
	}

	public UserInfo getOwner()
	{
		return owner;
	}

	public void setOwner(UserInfo owner)
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
