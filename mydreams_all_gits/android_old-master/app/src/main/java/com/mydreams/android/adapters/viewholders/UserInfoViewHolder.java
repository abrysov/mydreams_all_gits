package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.StringRes;
import android.support.v7.internal.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.models.User;

import org.apache.commons.lang3.StringUtils;

import butterknife.Bind;
import butterknife.ButterKnife;

public class UserInfoViewHolder extends BaseViewHolder
{
	@Bind(R.id.imgAvatar)
	SimpleDraweeView imgAvatar;

	@Bind(R.id.layoutVip)
	View layoutVip;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.lblLocation)
	TextView lblLocation;

	@Bind(R.id.rowStatus)
	View rowStatus;

	@Bind(R.id.lblStatus)
	TextView lblStatus;

	@Bind(R.id.lblFriendCount)
	TextView lblFriendCount;

	@Bind(R.id.lblFriend)
	TextView lblFriend;

	@Bind(R.id.lblSubscriberCount)
	TextView lblSubscriberCount;

	@Bind(R.id.lblSubscriber)
	TextView lblSubscriber;

	@Bind(R.id.lblLaunchesCount)
	TextView lblLaunchesCount;

	@Bind(R.id.lblLaunches)
	TextView lblLaunches;

	public UserInfoViewHolder(@NonNull ViewGroup parent, boolean isMyFlybook)
	{
		super(LayoutInflater.from(isMyFlybook ? parent.getContext() : new ContextThemeWrapper(parent.getContext(), R.style.GuestFlybookTheme)).inflate(R.layout.row_user_info, parent, false));
	}

	@Override
	public void onFindWidgets()
	{
		super.onFindWidgets();

		ButterKnife.bind(this, itemView);
	}

	@Override
	public void setItem(@NonNull Object item)
	{
		setItem((User) item);
	}

	public void setItem(@NonNull User item)
	{
		String avatar = item.getFullAvatarUrl();
		if (StringUtils.isNotBlank(avatar))
		{
			imgAvatar.setImageURI(Uri.parse(avatar));
		}

		layoutVip.setVisibility(item.isVip() ? View.VISIBLE : View.GONE);

		lblName.setText(String.format("%s, %d", item.getFullName(), item.getAge()));
		lblLocation.setText(StringUtils.defaultString(item.getLocation()));

		lblStatus.setText(StringUtils.defaultString(item.getQuote()));
		rowStatus.setVisibility(StringUtils.isBlank(item.getQuote()) ? View.GONE : View.VISIBLE);

		lblFriendCount.setText(String.format("%d", item.getFriendCount()));
		lblSubscriberCount.setText(String.format("%d", item.getSubscriberCount()));
		lblLaunchesCount.setText(String.format("%d", item.getLaunchesCount()));

		lblFriend.setText(getFriendsTitle(item.getFriendCount()));
		lblSubscriber.setText(getSubscribersTitle(item.getSubscriberCount()));
		lblLaunches.setText(getLaunchesTitle(item.getLaunchesCount()));
	}

	@NonNull
	private String getFriendsTitle(int count)
	{
		switch (count)
		{
			case 0:
				return getString(R.string.friends_count_caps_0);

			case 1:
				return getString(R.string.friends_count_caps_1);

			case 2:
			case 3:
			case 4:
				return getString(R.string.friends_count_caps_2_4);

			default:
				return getString(R.string.friends_count_caps_5);
		}
	}

	@NonNull
	private String getLaunchesTitle(int count)
	{
		switch (count)
		{
			case 0:
				return getString(R.string.launches_count_caps_0);

			case 1:
				return getString(R.string.launches_count_caps_1);

			case 2:
			case 3:
			case 4:
				return getString(R.string.launches_count_caps_2_4);

			default:
				return getString(R.string.launches_count_caps_5);
		}
	}

	private String getString(@StringRes final int stringId, final Object... formatArgs)
	{
		return itemView.getResources().getString(stringId, formatArgs);
	}

	@NonNull
	private String getSubscribersTitle(int count)
	{
		switch (count)
		{
			case 0:
				return getString(R.string.subscribers_count_caps_0);

			case 1:
				return getString(R.string.subscribers_count_caps_1);

			case 2:
			case 3:
			case 4:
				return getString(R.string.subscribers_count_caps_2_4);

			default:
				return getString(R.string.subscribers_count_caps_5);
		}
	}
}
