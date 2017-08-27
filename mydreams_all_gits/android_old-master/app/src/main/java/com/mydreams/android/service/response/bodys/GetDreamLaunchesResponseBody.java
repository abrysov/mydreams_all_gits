package com.mydreams.android.service.response.bodys;

import android.support.annotation.NonNull;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.LaunchDto;

import java.util.ArrayList;
import java.util.List;

public class GetDreamLaunchesResponseBody
{
	@NonNull
	@SerializedName("stamps")
	private LaunchCollectionBody launchCollectionBody;

	public GetDreamLaunchesResponseBody()
	{
		launchCollectionBody = new LaunchCollectionBody();
	}

	@NonNull
	public LaunchCollectionBody getLaunchCollectionBody()
	{
		return launchCollectionBody;
	}

	public void setLaunchCollectionBody(@NonNull LaunchCollectionBody launchCollectionBody)
	{
		this.launchCollectionBody = launchCollectionBody;
	}

	public static class LaunchCollectionBody
	{
		@SerializedName("total")
		private int total;

		@NonNull
		@SerializedName("items")
		private List<LaunchDto> launches;

		public LaunchCollectionBody()
		{
			launches = new ArrayList<>();
		}

		@NonNull
		public List<LaunchDto> getLaunches()
		{
			return launches;
		}

		public void setLaunches(@NonNull List<LaunchDto> launches)
		{
			this.launches = launches;
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
