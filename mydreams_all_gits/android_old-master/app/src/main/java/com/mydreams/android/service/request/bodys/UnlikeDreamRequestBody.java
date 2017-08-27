package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class UnlikeDreamRequestBody
{
	@SerializedName("id")
	private int id;

	public UnlikeDreamRequestBody(int dreamId)
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
