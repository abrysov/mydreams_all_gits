package com.mydreams.android.models;

import android.os.Parcel;
import android.os.Parcelable;

import com.mydreams.android.service.models.LocationDto;

public class Location implements Parcelable
{
	public static final Creator<Location> CREATOR = new Creator<Location>()
	{
		@Override
		public Location createFromParcel(Parcel in)
		{
			return new Location(in);
		}

		@Override
		public Location[] newArray(int size)
		{
			return new Location[size];
		}
	};

	private int id;
	private String name;
	private String parent;

	public Location()
	{
	}

	public Location(int id, String name, String parent)
	{
		this.id = id;
		this.name = name;
		this.parent = parent;
	}

	protected Location(Parcel in)
	{
		id = in.readInt();
		name = in.readString();
		parent = in.readString();
	}

	public static Location fromDto(LocationDto dto)
	{
		return new Location(dto.getId(), dto.getName(), dto.getParent());
	}

	@Override
	public int describeContents()
	{
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags)
	{
		dest.writeInt(getId());
		dest.writeString(getName());
		dest.writeString(getParent());
	}

	public LocationDto toDto()
	{
		return new LocationDto(getId(), getName(), getParent());
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
