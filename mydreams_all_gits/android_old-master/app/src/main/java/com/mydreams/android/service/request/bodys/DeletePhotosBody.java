package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class DeletePhotosBody
{
	@SerializedName("ids")
	private List<Integer> ids;

	public DeletePhotosBody()
	{
	}

	public DeletePhotosBody(List<Integer> ids)
	{
		this.ids = ids;
	}

	public List<Integer> getIds()
	{
		return ids;
	}

	public void setIds(List<Integer> ids)
	{
		this.ids = ids;
	}
}
