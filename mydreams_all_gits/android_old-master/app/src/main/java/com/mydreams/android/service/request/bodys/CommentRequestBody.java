package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;

public class CommentRequestBody
{
	@SerializedName("id")
	private int id;

	@SerializedName("text")
	private String text;

	public CommentRequestBody(int id, String text)
	{
		this.id = id;
		this.text = text;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getText()
	{
		return text;
	}

	public void setText(String text)
	{
		this.text = text;
	}
}
