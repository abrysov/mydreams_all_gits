package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.DreamDto;

public class GetDreamResponseBody
{
	@SerializedName("dream")
	private DreamDto dream;

	public DreamDto getDream()
	{
		return dream;
	}

	public void setDream(DreamDto dream)
	{
		this.dream = dream;
	}
}
