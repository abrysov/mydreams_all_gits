package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class ProposeDreamRequestBody
{
	@SerializedName("id")
	private int id;
	@SerializedName("userId")
	private int userId;

	public ProposeDreamRequestBody(int dreamId, int userId)
	{
		id = dreamId;
		this.userId = userId;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public int getUserId()
	{
		return userId;
	}

	public void setUserId(int userId)
	{
		this.userId = userId;
	}
}
