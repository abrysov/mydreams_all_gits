package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class TakeDreamRequestBody
{
	@SerializedName("id")
	private int id;

	public TakeDreamRequestBody(int dreamId)
	{
		id = dreamId;
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
