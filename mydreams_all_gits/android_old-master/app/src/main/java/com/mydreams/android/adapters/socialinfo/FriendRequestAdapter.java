package com.mydreams.android.adapters.socialinfo;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.ViewGroup;

import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.viewholders.UserRequestViewHolder;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.utils.Action1;

public class FriendRequestAdapter extends BaseSocialUserInfoAdapter
{
	private final Action1<Integer> clickAccept;
	private final Action1<Integer> clickRemove;

	public FriendRequestAdapter(Action1<Integer> clickAccept, Action1<Integer> clickRemove)
	{
		this.clickAccept = clickAccept;
		this.clickRemove = clickRemove;

		addBinder(new UserRequestBinder(this::handleClickAccept, this::handleClickRemove));
	}

	private void handleClickAccept(int position)
	{
		clickAccept.invoke(position);
	}


	private void handleClickRemove(int position)
	{
		clickRemove.invoke(position);
	}

	public static class FriendRequestModel
	{
		private UserInfo user;

		public FriendRequestModel(UserInfo user)
		{
			this.user = user;
		}

		public String getAge()
		{
			return user.getAge();
		}

		@Nullable
		public Uri getAvatarUrl()
		{
			if (user.getFullAvatarUrl() != null)
				return Uri.parse(user.getFullAvatarUrl());

			return null;
		}

		public String getFullName()
		{
			return user.getFullName();
		}

		public String getLocation()
		{
			return user.getLocation();
		}

		public UserInfo getUser()
		{
			return user;
		}
	}

	public static class UserRequestBinder extends Binder<SimpleSocialUserInfoAdapter.ViewType>
	{
		private final Action1<Integer> clickAccept;
		private final Action1<Integer> clickRemove;

		public UserRequestBinder(Action1<Integer> clickAccept, Action1<Integer> clickRemove)
		{
			super(ViewType.UserInfo);
			this.clickAccept = clickAccept;
			this.clickRemove = clickRemove;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof FriendRequestModel;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new UserRequestViewHolder(this::handleClickAccept, this::handleClickRemove, parent);
		}

		private void handleClickAccept(UserRequestViewHolder viewHolder)
		{
			clickAccept.invoke(viewHolder.getAdapterPosition());
		}

		private void handleClickRemove(UserRequestViewHolder viewHolder)
		{
			clickRemove.invoke(viewHolder.getAdapterPosition());
		}
	}
}
