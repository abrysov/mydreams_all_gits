package com.mydreams.android.service.models;

public enum SexType
{
	Male(1), Female(2), Unknown(-1);

	private int id;

	SexType(int id)
	{
		this.id = id;
	}

	public int getId()
	{
		return id;
	}
}
