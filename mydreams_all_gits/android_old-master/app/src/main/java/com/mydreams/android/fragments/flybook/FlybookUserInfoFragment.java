package com.mydreams.android.fragments.flybook;

import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.mydreams.android.R;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.UserResponse;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class FlybookUserInfoFragment extends BaseFragment
{
	private static final String USER_INFO_ARGS_NAME = "USER_INFO_ARGS_NAME";
	@Bind(R.id.userLayout)
	View userLayout;
	@Bind(R.id.progressBar)
	View progressBar;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
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
	private UserPreference mUserPreference;
	private User user;

	public static FlybookUserInfoFragment getInstance(@Nullable UserInfo user,@Nullable @StyleRes Integer theme)
	{
		final Bundle args = new Bundle();
		if (user != null)
			args.putParcelable(USER_INFO_ARGS_NAME, Parcels.wrap(user));

		if(theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		FlybookUserInfoFragment result = new FlybookUserInfoFragment();
		result.setArguments(args);
		return result;
	}

	@Nullable
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_flybook_user_info, container, false);
		ButterKnife.bind(this, result);

		return result;
	}

	@Override
	public void onResume()
	{
		super.onResume();

		if (user == null)
		{
			updateUser();
		}
		else
		{
			showCard();
		}
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		updateUser();
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

	private UserInfo getUserInfo()
	{
		if (getArguments().containsKey(USER_INFO_ARGS_NAME))
			return Parcels.unwrap(getArguments().getParcelable(USER_INFO_ARGS_NAME));

		return new UserInfo(mUserPreference.getUser());
	}

	private void showCard()
	{
		userLayout.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);

		if (user != null)
		{
			String avatar = user.getFullAvatarUrl();
			if (StringUtils.isNotBlank(avatar))
			{
				imgAvatar.setImageURI(Uri.parse(avatar));
			}

			layoutVip.setVisibility(user.isVip() ? View.VISIBLE : View.GONE);

			lblName.setText(String.format("%s, %s", user.getFullName(), user.getAge()));
			lblLocation.setText(StringUtils.defaultString(user.getLocation()));

			lblStatus.setText(StringUtils.defaultString(user.getQuote()));
			rowStatus.setVisibility(StringUtils.isBlank(user.getQuote()) ? View.GONE : View.VISIBLE);

			lblFriendCount.setText(String.format("%d", user.getFriendCount()));
			lblSubscriberCount.setText(String.format("%d", user.getSubscriberCount()));
			lblLaunchesCount.setText(String.format("%d", user.getLaunchesCount()));

			lblFriend.setText(getFriendsTitle(user.getFriendCount()));
			lblSubscriber.setText(getSubscribersTitle(user.getSubscriberCount()));
			lblLaunches.setText(getLaunchesTitle(user.getLaunchesCount()));
		}
		else
		{
			updateUser();
		}
	}

	private void showProgress()
	{
		userLayout.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
	}

	private void showRetry()
	{
		userLayout.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
	}

	private void updateUser()
	{
		showProgress();

		BaseSpiceRequest<UserResponse> requset = RequestFactory.getUser(getUserInfo().getId());
		getSpiceManager().execute(requset, new RequestListener<UserResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				showRetry();
			}

			@Override
			public void onRequestSuccess(UserResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					user = new User(response.getUser());

					Fragment fragment = getParentFragment();
					if (fragment != null && fragment instanceof FlybookFragment)
					{
						FlybookFragment dreamInfoFragment = (FlybookFragment) fragment;
						dreamInfoFragment.setDreamCount(user.getDreams());
						dreamInfoFragment.setPostCount(user.getPosts());
						dreamInfoFragment.setDreamDoneCount(user.getDreamsComplete());
					}

					showCard();
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						showRetry();
					}
				}
			}
		});
	}

}
