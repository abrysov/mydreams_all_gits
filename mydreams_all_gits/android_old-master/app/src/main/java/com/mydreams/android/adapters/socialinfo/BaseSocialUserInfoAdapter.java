package com.mydreams.android.adapters.socialinfo;

import android.support.annotation.Nullable;

import com.mydreams.android.adapters.DifferentViewAdapter;
import com.mydreams.android.utils.Action1;

public abstract class BaseSocialUserInfoAdapter extends DifferentViewAdapter<BaseSocialUserInfoAdapter.ViewType>
{
	@Nullable
	private Action1<Object> clickItem;

	protected BaseSocialUserInfoAdapter()
	{
	}

	protected void handleClick(int position)
	{
		if (clickItem != null)
		{
			clickItem.invoke(getItem(position));
		}
	}

	public void setClickItem(@Nullable Action1<Object> clickItem)
	{
		this.clickItem = clickItem;
	}

	enum ViewType
	{
		UserInfo, Divider
	}
}
