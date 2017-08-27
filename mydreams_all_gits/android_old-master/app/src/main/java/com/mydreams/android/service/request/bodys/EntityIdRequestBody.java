package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class EntityIdRequestBody
{
	@SerializedName("id")
	private int id;

	public EntityIdRequestBody()
	{
	}

	public EntityIdRequestBody(int id)
	{
		this.id = id;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}
}
