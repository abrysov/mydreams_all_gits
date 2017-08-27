package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class LocationDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("name")
	private String name;

	@SerializedName("parent")
	private String parent;

	public LocationDto()
	{
	}

	public LocationDto(int id, String name, String parent)
	{
		this.id = id;
		this.name = name;
		this.parent = parent;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getParent()
	{
		return parent;
	}

	public void setParent(String parent)
	{
		this.parent = parent;
	}
}
