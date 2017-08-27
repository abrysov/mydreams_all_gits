package com.mydreams.android.adapters.dreaminfo;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.DifferentViewAdapter;
import com.mydreams.android.adapters.viewholders.DreamLikeViewHolder;
import com.mydreams.android.models.Like;
import com.mydreams.android.utils.Action1;

public class DreamLikeAdapter extends DifferentViewAdapter<DreamLikeAdapter.ViewType>
{
	private Action1<Integer> clickAction;

	public DreamLikeAdapter(Action1<Integer> clickAction)
	{
		this.clickAction = clickAction;
		addBinder(new DreamLikesBinder(this::handleClick));
	}

	private void handleClick(int position)
	{
		clickAction.invoke(position);
	}

	enum ViewType
	{
		Like
	}

	public static class LikeModel
	{
		private Like like;

		public LikeModel(Like like)
		{
			this.like = like;
		}

		public Like getLike()
		{
			return like;
		}
	}

	public static class DreamLikesBinder extends Binder<DreamLikeAdapter.ViewType>
	{
		private Action1<Integer> clickAction;

		public DreamLikesBinder(Action1<Integer> clickAction)
		{
			super(ViewType.Like);
			this.clickAction = clickAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof LikeModel;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamLikeViewHolder(parent, this::handleClick);
		}

		private void handleClick(DreamLikeViewHolder viewHolder)
		{
			clickAction.invoke(viewHolder.getAdapterPosition());
		}
	}
}
