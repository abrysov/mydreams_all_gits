package com.mydreams.android.service.models;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;

import org.apache.commons.lang3.StringUtils;

public class CountryDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("name")
	private String name;

	public int getId()
	{
		return id;
	}

	public void setId(final int id)
	{
		this.id = id;
	}

	@NonNull
	public String getName()
	{
		return name != null ? name : StringUtils.EMPTY;
	}

	public void setName(@Nullable final String name)
	{
		this.name = name;
	}
}
