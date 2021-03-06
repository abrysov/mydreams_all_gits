package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.DreamInfoViewHolder;
import com.mydreams.android.adapters.viewholders.DreamProposedViewHolder;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.utils.Action1;

public class FlybookDreamAdapter extends DifferentViewAdapter<FlybookDreamAdapter.ViewType>
{
	private Action1<Object> clickItem;
	private Action1<DreamInfo> clickComment;

	public FlybookDreamAdapter(@NonNull Action1<Object> clickItem, Action1<DreamInfo> clickComment)
	{
		this.clickComment = clickComment;

		addBinder(new DreamProposedBinder(holder -> handleClick(holder.getAdapterPosition()), holder -> remove(holder.getAdapterPosition())));
		addBinder(new DreamBinder(holder -> handleClick(holder.getAdapterPosition()), holder -> handleClickComment(holder.getAdapterPosition())));

		this.clickItem = clickItem;
	}

	private void handleClick(int position)
	{
		clickItem.invoke(getItem(position));
	}

	private void handleClickComment(int position)
	{
		clickComment.invoke((DreamInfo) getItem(position));
	}

	enum ViewType
	{
		DreamProposed, Dream
	}

	public static class DreamProposedBinder extends Binder<FlybookDreamAdapter.ViewType>
	{
		private Action1<DreamProposedViewHolder> clickAction;
		private Action1<DreamProposedViewHolder> clickClose;

		public DreamProposedBinder(@NonNull Action1<DreamProposedViewHolder> clickAction, @NonNull Action1<DreamProposedViewHolder> clickClose)
		{
			super(ViewType.DreamProposed);
			this.clickAction = clickAction;
			this.clickClose = clickClose;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof Integer;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamProposedViewHolder(parent, clickAction, clickClose);
		}
	}

	public static class DreamBinder extends Binder<FlybookDreamAdapter.ViewType>
	{
		private Action1<DreamInfoViewHolder> clickAction;
		private Action1<DreamInfoViewHolder> clickCommentAction;

		public DreamBinder(@NonNull Action1<DreamInfoViewHolder> clickAction, Action1<DreamInfoViewHolder> clickCommentAction)
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
			return new DreamInfoViewHolder(parent, clickAction, clickCommentAction);
		}
	}
}
