package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.DreamInfoFromTopViewHolder;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.utils.Action1;

public class DreamTopAdapter extends DifferentViewAdapter<DreamTopAdapter.ViewType>
{
	private Action1<DreamInfo> clickItem;
	private Action1<DreamInfo> clickComment;

	public DreamTopAdapter(@NonNull Action1<DreamInfo> clickItem, Action1<DreamInfo> clickComment)
	{
		this.clickComment = clickComment;

		addBinder(new DreamBinder(holder -> handleClick(holder.getAdapterPosition()), holder -> handleClickComment(holder.getAdapterPosition())));

		this.clickItem = clickItem;
	}

	private void handleClick(int position)
	{
		clickItem.invoke((DreamInfo) getItem(position));
	}

	private void handleClickComment(int position)
	{
		clickComment.invoke((DreamInfo) getItem(position));
	}

	enum ViewType
	{
		Dream
	}

	public static class DreamBinder extends Binder<DreamTopAdapter.ViewType>
	{
		private Action1<DreamInfoFromTopViewHolder> clickAction;
		private Action1<DreamInfoFromTopViewHolder> clickCommentAction;

		public DreamBinder(@NonNull Action1<DreamInfoFromTopViewHolder> clickAction, Action1<DreamInfoFromTopViewHolder> clickCommentAction)
		{
			super(ViewType.Dream);
			this.clickAction = clickAction;
			this.clickCommentAction = clickCommentAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof DreamInfo;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamInfoFromTopViewHolder(parent, clickAction, clickCommentAction);
		}
	}
}
