package com.mydreams.android.service.response.bodys;

import android.support.annotation.NonNull;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.LikeDto;

import java.util.ArrayList;
import java.util.List;

public class GetDreamLikesResponseBody
{
	@NonNull
	@SerializedName("likes")
	private LikeCollectionBody likeCollectionBody;

	public GetDreamLikesResponseBody()
	{
		likeCollectionBody = new LikeCollectionBody();
	}

	@NonNull
	public LikeCollectionBody getLikeCollectionBody()
	{
		return likeCollectionBody;
	}

	public void setLikeCollectionBody(@NonNull LikeCollectionBody likeCollectionBody)
	{
		this.likeCollectionBody = likeCollectionBody;
	}

	public static class LikeCollectionBody
	{
		@SerializedName("total")
		private int total;

		@NonNull
		@SerializedName("items")
		private List<LikeDto> likes;

		public LikeCollectionBody()
		{
			likes = new ArrayList<>();
		}

		@NonNull
		public List<LikeDto> getLikes()
		{
			return likes;
		}

		public void setLikes(@NonNull List<LikeDto> likes)
		{
			this.likes = likes;
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
