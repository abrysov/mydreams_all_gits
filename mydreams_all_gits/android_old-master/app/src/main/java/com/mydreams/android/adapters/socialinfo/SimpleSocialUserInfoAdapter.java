package com.mydreams.android.adapters.socialinfo;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.viewholders.SocialUserInfoViewHolder;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.utils.Action1;

public class SimpleSocialUserInfoAdapter extends BaseSocialUserInfoAdapter
{
	public SimpleSocialUserInfoAdapter(Action1<Object> clickItem)
	{
		addBinder(new UserInfoBinder(holder -> handleClick(holder.getAdapterPosition())));
		addBinder(new DividerBinder());
		setClickItem(clickItem);
	}

	public static class UserInfoModel
	{
		public String capitalLetter;
		public String name;
		public Uri avatar;
		public UserInfo user;
		public boolean showCapitalLetter;

		public UserInfoModel(UserInfo user, boolean showCapitalLetter)
		{
			this.user = user;

			this.showCapitalLetter = showCapitalLetter;
			if (user.getFullAvatarUrl() != null)
				avatar = Uri.parse(user.getFullAvatarUrl());

			name = user.getFullName();

			capitalLetter = name.substring(0, 1).toUpperCase();
		}
	}

	public static class Divider
	{
	}

	public static class UserInfoBinder extends Binder<SimpleSocialUserInfoAdapter.ViewType>
	{
		private Action1<SocialUserInfoViewHolder> clickAction;

		public UserInfoBinder(Action1<SocialUserInfoViewHolder> clickAction)
		{
			super(ViewType.UserInfo);
			this.clickAction = clickAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof UserInfoModel;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new SocialUserInfoViewHolder(clickAction, parent);
		}
	}

	public static class DividerBinder extends Binder<SimpleSocialUserInfoAdapter.ViewType>
	{
		public DividerBinder()
		{
			super(ViewType.Divider);
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof Divider;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new BaseViewHolder(R.layout.row_social_info_divider, parent)
			{
				@Override
				public void setItem(@NonNull Object item)
				{
				}
			};
		}
	}
}
