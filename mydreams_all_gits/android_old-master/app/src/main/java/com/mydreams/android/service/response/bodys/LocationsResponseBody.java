package com.mydreams.android.service.response.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.LocationDto;

import java.util.Collections;
import java.util.List;

public class LocationsResponseBody
{
	@Nullable
	@SerializedName("locations")
	private List<LocationDto> locations;

	@Nullable
	public List<LocationDto> getLocations()
	{
		return locations != null ? Collections.unmodifiableList(locations) : null;
	}

	public void setLocations(@Nullable List<LocationDto> locations)
	{
		this.locations = locations;
	}
}
