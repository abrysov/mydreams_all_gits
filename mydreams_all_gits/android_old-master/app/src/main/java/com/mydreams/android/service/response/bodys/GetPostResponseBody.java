package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.PostDto;

public class GetPostResponseBody
{
	@SerializedName("post")
	private PostDto post;

	public PostDto getPost()
	{
		return post;
	}

	public void setPost(final PostDto post)
	{
		this.post = post;
	}
}
