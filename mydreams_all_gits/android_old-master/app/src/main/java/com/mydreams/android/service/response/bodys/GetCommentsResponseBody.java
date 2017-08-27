package com.mydreams.android.service.response.bodys;

import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.CommentDto;

import java.util.ArrayList;
import java.util.List;

public class GetCommentsResponseBody
{
	@Nullable
	@SerializedName("comments")
	private CommentCollectionBody commentCollectionBody;

	public GetCommentsResponseBody()
	{
		commentCollectionBody = new CommentCollectionBody();
	}

	@Nullable
	public CommentCollectionBody getCommentCollectionBody()
	{
		return commentCollectionBody;
	}

	public void setCommentCollectionBody(@Nullable CommentCollectionBody commentCollectionBody)
	{
		this.commentCollectionBody = commentCollectionBody;
	}

	public static class CommentCollectionBody
	{
		@SerializedName("total")
		private int total;

		@NonNull
		@SerializedName("items")
		private List<CommentDto> comments;

		public CommentCollectionBody()
		{
			comments = new ArrayList<>();
		}

		@NonNull
		public List<CommentDto> getComments()
		{
			return comments;
		}

		public void setComments(@NonNull List<CommentDto> comments)
		{
			this.comments = comments;
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
