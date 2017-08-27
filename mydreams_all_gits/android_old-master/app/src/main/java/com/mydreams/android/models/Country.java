package com.mydreams.android.models;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.CountryDto;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;

@Parcel(Parcel.Serialization.BEAN)
public class Country
{
	@SerializedName("id")
	private int id;

	@SerializedName("name")
	private String name;

	public Country()
	{
	}

	public Country(CountryDto dto)
	{
		id = dto.getId();
		name = dto.getName();
	}

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
