package com.mydreams.android.service.response.bodys;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.PostInfoDto;

import java.util.ArrayList;
import java.util.List;

public class GetPostsResponseBody
{
	@Nullable
	@SerializedName("posts")
	private PostCollectionBody postCollection;

	@Nullable
	public PostCollectionBody getPostCollection()
	{
		return postCollection;
	}

	public void setPostCollection(@Nullable PostCollectionBody postCollection)
	{
		this.postCollection = postCollection;
	}

	public static class PostCollectionBody
	{
		@SerializedName("total")
		private int total;

		@Nullable
		@SerializedName("items")
		private List<PostInfoDto> posts;

		@NonNull
		public List<PostInfoDto> getPosts()
		{
			return posts != null ? posts : new ArrayList<>();
		}

		public void setPosts(@Nullable final List<PostInfoDto> posts)
		{
			this.posts = posts;
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
