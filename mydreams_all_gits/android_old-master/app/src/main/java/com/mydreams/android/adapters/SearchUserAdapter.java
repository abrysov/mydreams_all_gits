package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.SearchUserViewHolder;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.utils.Action1;

public class SearchUserAdapter extends DifferentViewAdapter<SearchUserAdapter.ViewType>
{
	@NonNull
	private Action1<UserInfo> clickItem;

	public SearchUserAdapter(@NonNull Action1<UserInfo> clickItem)
	{
		addBinder(new UserInfoBinder(holder -> handleClick(holder.getAdapterPosition())));
		this.clickItem = clickItem;
	}

	protected void handleClick(int position)
	{
		clickItem.invoke((UserInfo) getItem(position));
	}

	enum ViewType
	{
		UserInfo
	}

	public static class UserInfoBinder extends Binder<SearchUserAdapter.ViewType>
	{
		private Action1<SearchUserViewHolder> clickAction;

		public UserInfoBinder(Action1<SearchUserViewHolder> clickAction)
		{
			super(SearchUserAdapter.ViewType.UserInfo);
			this.clickAction = clickAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof UserInfo;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new SearchUserViewHolder(clickAction, parent);
		}
	}
}
