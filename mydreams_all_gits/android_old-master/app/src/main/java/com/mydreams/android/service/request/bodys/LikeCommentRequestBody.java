package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class LikeCommentRequestBody
{
	@SerializedName("id")
	private int id;

	public LikeCommentRequestBody(int commentId)
	{
		id = commentId;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}
}
