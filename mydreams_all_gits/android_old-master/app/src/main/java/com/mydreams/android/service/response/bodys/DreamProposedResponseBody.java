package com.mydreams.android.service.response.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.DreamDto;
import com.mydreams.android.service.models.DreamInfoDto;

import java.util.List;

public class DreamProposedResponseBody
{
	@Nullable
	@SerializedName("dreams")
	private DreamCollectionBody dreamCollection;

	@Nullable
	public DreamCollectionBody getDreamCollection()
	{
		return dreamCollection;
	}

	public void setDreamCollection(@Nullable DreamCollectionBody dreamCollection)
	{
		this.dreamCollection = dreamCollection;
	}

	public static class DreamCollectionBody
	{
		@SerializedName("total")
		private int total;

		@Nullable
		@SerializedName("items")
		private List<DreamInfoDto> dreams;

		@Nullable
		public List<DreamInfoDto> getDreams()
		{
			return dreams;
		}

		public void setDreams(@Nullable List<DreamInfoDto> dreams)
		{
			this.dreams = dreams;
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
