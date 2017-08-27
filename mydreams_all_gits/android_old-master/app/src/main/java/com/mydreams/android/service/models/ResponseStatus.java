package com.mydreams.android.service.models;

public enum ResponseStatus
{
	Ok(0), Error(1), Unauthorized(2), Unknown(-1);

	private int id;

	ResponseStatus(int id)
	{
		this.id = id;
	}

	public int getId()
	{
		return id;
	}
}
