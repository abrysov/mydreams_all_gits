package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.LocationDto;
import com.mydreams.android.service.response.bodys.LocationsResponseBody;

import java.util.List;

public class LocationsResponse extends BaseServiceResponse<LocationsResponseBody>
{
	@Nullable
	public List<LocationDto> getLocations()
	{
		return getBody().getLocations();
	}
}
