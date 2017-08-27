package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.DreamProposedInfoViewHolder;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.utils.Action1;

public class DreamProposedAdapter extends DifferentViewAdapter<DreamProposedAdapter.ViewType>
{
	private final Action1<DreamInfo> clickItem;
	private final Action1<DreamInfo> clickComment;

	private final Action1<DreamInfo> clickAccept;
	private final Action1<DreamInfo> clickRemove;

	public DreamProposedAdapter(@NonNull Action1<DreamInfo> clickItem, Action1<DreamInfo> clickComment, final Action1<DreamInfo> clickAccept, final Action1<DreamInfo> clickRemove)
	{
		this.clickComment = clickComment;
		this.clickAccept = clickAccept;
		this.clickRemove = clickRemove;

		addBinder(new DreamBinder(holder -> handleClick(holder.getAdapterPosition()),
				holder -> handleClickComment(holder.getAdapterPosition()),
				holder -> handleClickAccept(holder.getAdapterPosition()),
				holder -> handleClickRemove(holder.getAdapterPosition())));

		this.clickItem = clickItem;
	}

	private void handleClick(int position)
	{
		clickItem.invoke((DreamInfo) getItem(position));
	}

	private void handleClickAccept(int position)
	{
		clickAccept.invoke((DreamInfo) getItem(position));
	}

	private void handleClickComment(int position)
	{
		clickComment.invoke((DreamInfo) getItem(position));
	}

	private void handleClickRemove(int position)
	{
		clickRemove.invoke((DreamInfo) getItem(position));
	}

	enum ViewType
	{
		Dream
	}

	public static class DreamBinder extends Binder<DreamProposedAdapter.ViewType>
	{
		private final Action1<DreamProposedInfoViewHolder> clickAction;
		private final Action1<DreamProposedInfoViewHolder> clickCommentAction;
		private final Action1<DreamProposedInfoViewHolder> clickAcceptAction;
		private final Action1<DreamProposedInfoViewHolder> clickRemoveAction;

		public DreamBinder(@NonNull Action1<DreamProposedInfoViewHolder> clickAction, Action1<DreamProposedInfoViewHolder> clickCommentAction, final Action1<DreamProposedInfoViewHolder> clickAcceptAction, final Action1<DreamProposedInfoViewHolder> clickRemoveAction)
		{
			super(ViewType.Dream);
			this.clickAction = clickAction;
			this.clickCommentAction = clickCommentAction;
			this.clickAcceptAction = clickAcceptAction;
			this.clickRemoveAction = clickRemoveAction;
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
			return new DreamProposedInfoViewHolder(parent, clickAction, clickCommentAction, clickAcceptAction, clickRemoveAction);
		}
	}
}
