package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.UserActivityDto;
import com.mydreams.android.service.response.bodys.UserActivitiesResponseBody;

import java.util.ArrayList;
import java.util.List;

public class UserActivitiesResponse extends BaseServiceResponse<UserActivitiesResponseBody>
{
	@NonNull
	public List<UserActivityDto> getUserActivities()
	{
		UserActivitiesResponseBody.UserActivityCollectionBody collection = getBody().getUserActivityCollection();
		if (collection != null)
		{
			List<UserActivityDto> activities = collection.getActivities();
			if (activities != null)
				return activities;
		}

		return new ArrayList<>();
	}
}
