package com.mydreams.android.service.response.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.UserActivityDto;

import java.util.ArrayList;
import java.util.List;

public class UserActivitiesResponseBody
{
	@Nullable
	@SerializedName("events")
	private UserActivityCollectionBody userActivityCollection;

	@Nullable
	public UserActivityCollectionBody getUserActivityCollection()
	{
		return userActivityCollection;
	}

	public void setUserActivityCollection(@Nullable UserActivityCollectionBody userActivityCollection)
	{
		this.userActivityCollection = userActivityCollection;
	}

	public static class UserActivityCollectionBody
	{
		@SerializedName("total")
		private int total;

		@SerializedName("items")
		private List<UserActivityDto> activities;

		public UserActivityCollectionBody()
		{
			activities = new ArrayList<>();
		}

		public List<UserActivityDto> getActivities()
		{
			return activities;
		}

		public void setActivities(List<UserActivityDto> activities)
		{
			this.activities = activities;
		}

		public int getTotal()
		{
			return total;
		}

		public void setTotal(int total)
		{
			this.total = total;
		}
	}
}
