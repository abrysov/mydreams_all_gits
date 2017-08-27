package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class MarkDoneRequestBody
{
	@SerializedName("id")
	private int id;

	@SerializedName("done")
	private boolean done;

	public MarkDoneRequestBody(final int id, final boolean done)
	{
		this.id = id;
		this.done = done;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public boolean isDone()
	{
		return done;
	}

	public void setDone(final boolean done)
	{
		this.done = done;
	}
}
