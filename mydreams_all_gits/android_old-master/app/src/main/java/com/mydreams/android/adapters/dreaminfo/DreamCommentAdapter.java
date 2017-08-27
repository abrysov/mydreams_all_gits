package com.mydreams.android.adapters.dreaminfo;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.DifferentViewAdapter;
import com.mydreams.android.adapters.viewholders.DreamCommentViewHolder;
import com.mydreams.android.models.Comment;
import com.mydreams.android.utils.Action1;

public class DreamCommentAdapter extends DifferentViewAdapter<DreamCommentAdapter.ViewType>
{
	private Action1<Integer> clickAction;
	private Action1<Integer> clickLikeAction;

	public DreamCommentAdapter(Action1<Integer> clickAction, Action1<Integer> clickLikeAction)
	{
		this.clickAction = clickAction;
		this.clickLikeAction = clickLikeAction;
		addBinder(new DreamCommentBinder(this::handleClick, this::handleClickLike));
	}

	private void handleClick(int position)
	{
		clickAction.invoke(position);
	}

	private void handleClickLike(int position)
	{
		clickLikeAction.invoke(position);
	}

	enum ViewType
	{
		Comment
	}

	public static class CommentModel
	{
		private Comment comment;

		public CommentModel(Comment comment)
		{
			this.comment = comment;
		}

		public Comment getComment()
		{
			return comment;
		}
	}

	public static class DreamCommentBinder extends DifferentViewAdapter.Binder<DreamCommentAdapter.ViewType>
	{
		private Action1<Integer> clickAction;
		private Action1<Integer> clickLikeAction;

		public DreamCommentBinder(Action1<Integer> clickAction, Action1<Integer> clickLikeAction)
		{
			super(ViewType.Comment);
			this.clickAction = clickAction;
			this.clickLikeAction = clickLikeAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof CommentModel;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamCommentViewHolder(parent, this::handleClick, this::handleClickLike);
		}

		private void handleClick(DreamCommentViewHolder viewHolder)
		{
			clickAction.invoke(viewHolder.getAdapterPosition());
		}

		private void handleClickLike(DreamCommentViewHolder viewHolder)
		{
			clickLikeAction.invoke(viewHolder.getAdapterPosition());
		}
	}
}
