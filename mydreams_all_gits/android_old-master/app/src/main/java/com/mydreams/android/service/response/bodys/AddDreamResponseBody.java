package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;

public class AddDreamResponseBody
{
	@SerializedName("id")
	private int id;

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}
}
