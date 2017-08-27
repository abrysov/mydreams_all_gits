package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.PostInfoViewHolder;
import com.mydreams.android.models.PostInfo;
import com.mydreams.android.utils.Action1;

public class FlybookPostAdapter extends DifferentViewAdapter<FlybookPostAdapter.ViewType>
{
	private Action1<PostInfo> clickItem;
	private Action1<PostInfo> clickComment;

	public FlybookPostAdapter(@NonNull Action1<PostInfo> clickItem, Action1<PostInfo> clickComment)
	{
		this.clickComment = clickComment;

		addBinder(new PostBinder(holder -> handleClick(holder.getAdapterPosition()), holder -> handleClickComment(holder.getAdapterPosition())));

		this.clickItem = clickItem;
	}

	private void handleClick(int position)
	{
		clickItem.invoke((PostInfo) getItem(position));
	}

	private void handleClickComment(int position)
	{
		clickComment.invoke((PostInfo) getItem(position));
	}

	enum ViewType
	{
		Post
	}

	public static class PostBinder extends Binder<FlybookPostAdapter.ViewType>
	{
		private Action1<PostInfoViewHolder> clickAction;
		private Action1<PostInfoViewHolder> clickCommentAction;

		public PostBinder(@NonNull Action1<PostInfoViewHolder> clickAction, Action1<PostInfoViewHolder> clickCommentAction)
		{
			super(ViewType.Post);
			this.clickAction = clickAction;
			this.clickCommentAction = clickCommentAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof PostInfo;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new PostInfoViewHolder(parent, clickAction, clickCommentAction);
		}
	}
}
