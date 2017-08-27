package com.mydreams.android.fragments;

import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.flybook.FlybookDreamDoneFragment;
import com.mydreams.android.fragments.flybook.FlybookDreamFragment;
import com.mydreams.android.fragments.flybook.FlybookPostFragment;
import com.mydreams.android.fragments.flybook.FlybookUserInfoFragment;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.TabPageIndicator;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import butterknife.Bind;
import butterknife.ButterKnife;

public class FlybookFragment extends BaseFragment
{
	private static final String USER_INFO_EXTRA_NAME = "USER_INFO_EXTRA_NAME";
	@Bind(R.id.tabPageIndicator)
	TabPageIndicator mTabPageIndicator;
	@Bind(R.id.viewPager)
	ViewPager mViewPager;
	private ToolbarManager mToolbarManager;
	private UserPreference mUserPreference;
	@Nullable
	private UserInfo mFlybookUser;
	private PagerAdapter mPagerAdapter;

	public static Fragment getInstance(@Nullable UserInfo user)
	{
		Bundle args = new Bundle();

		if (user != null)
		{
			args.putParcelable(USER_INFO_EXTRA_NAME, Parcels.wrap(user));
		}

		Fragment result = new FlybookFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.flybook_menu, menu);

		MenuItem photosItem = menu.findItem(R.id.photos);

		photosItem.setVisible(isCurrentUserFlybook());

		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		mFlybookUser = getUserInfo();
		if (mFlybookUser == null)
			mFlybookUser = new UserInfo(mUserPreference.getUser());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setThemeIdInArgs(getArguments(), mFlybookUser.isVip() ? R.style.PurpureTheme : R.style.LightBlueTheme);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_flybook, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_flybook_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		mPagerAdapter = new PagerAdapter(getActivity(), getChildFragmentManager(), mFlybookUser, getThemeIdFromArgs());
		mViewPager.setAdapter(mPagerAdapter);
		mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener()
		{
			@Override
			public void onPageScrollStateChanged(final int state)
			{
				getBaseActivity().hideSoftKeyboard();
			}

			@Override
			public void onPageScrolled(final int position, final float positionOffset, final int positionOffsetPixels)
			{

			}

			@Override
			public void onPageSelected(final int position)
			{

			}
		});
		mTabPageIndicator.setViewPager(mViewPager);

		return result;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case R.id.logout:
				getMainActivity().goToSignIn();
				return true;

			case R.id.edit:
				MainActivity mainActivity = (MainActivity) getActivity();
				mainActivity.putFragmentWithBackStack(EditUserFragment.getInstance(getThemeIdFromArgs()), false);
				return true;

			case R.id.request_friendship:
				requestFriendship();
				return true;

			case R.id.subscribe:
				subscribe();
				return true;

			case R.id.unsubscribe:
				unsubscribe();
				return true;

			case R.id.unfriend:
				unfriend();
				return true;

			case R.id.deny_friendship_request:
				denyRequestFriendship();
				return true;

			case R.id.photos:
				goToPhotos();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		mToolbarManager.onPrepareMenu();

		MenuItem editMenuItem = menu.findItem(R.id.edit);
		MenuItem requestFriendshipMenuItem = menu.findItem(R.id.request_friendship);
		MenuItem denyRequestFriendshipMenuItem = menu.findItem(R.id.deny_friendship_request);
		MenuItem subscribeMenuItem = menu.findItem(R.id.subscribe);
		MenuItem unsubscribeMenuItem = menu.findItem(R.id.unsubscribe);
		MenuItem unfriendMenuItem = menu.findItem(R.id.unfriend);

		editMenuItem.setVisible(isCurrentUserFlybook());

		if (mFlybookUser != null && !isCurrentUserFlybook())
		{
			subscribeMenuItem.setVisible(!mFlybookUser.isSubscribed());
			unsubscribeMenuItem.setVisible(mFlybookUser.isSubscribed());
			unfriendMenuItem.setVisible(mFlybookUser.isFriend());
			requestFriendshipMenuItem.setVisible(!mFlybookUser.isFriend() && !mFlybookUser.isFriendshipRequestSent());
			denyRequestFriendshipMenuItem.setVisible(mFlybookUser.isFriendshipRequestSent());
		}
		else
		{
			subscribeMenuItem.setVisible(false);
			unsubscribeMenuItem.setVisible(false);
			unfriendMenuItem.setVisible(false);
			requestFriendshipMenuItem.setVisible(false);
			denyRequestFriendshipMenuItem.setVisible(false);
		}

		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), mFlybookUser != null && mFlybookUser.isVip() ? R.color.purpure_dark : R.color.light_blue_dark);

		mToolbarManager.notifyNavigationStateChanged();
		mToolbarManager.notifyNavigationStateInvalidated();
	}

	public void setDreamCount(int dreamCount)
	{
		mPagerAdapter.setDreamCount(dreamCount);
	}

	public void setDreamDoneCount(int dreamDoneCount)
	{
		mPagerAdapter.setDreamDoneCount(dreamDoneCount);
	}

	public void setPostCount(int postCount)
	{
		mPagerAdapter.setPostCount(postCount);
	}

	private void denyRequestFriendship()
	{
		if (mFlybookUser != null)
		{
			mFlybookUser.setFriendshipRequestSent(false);
			mFlybookUser.setSubscribed(false);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.denyRequest(mFlybookUser.getId());
			getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					if (response.getCode() != ResponseStatus.Ok)
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.deny_request_friendship_failed);
						showToast(message);

						mFlybookUser.setFriendshipRequestSent(true);
						mFlybookUser.setSubscribed(true);
						getActivity().invalidateOptionsMenu();
					}
				}
			});

			getActivity().invalidateOptionsMenu();
		}
	}

	@Nullable
	private UserInfo getUserInfo()
	{
		Bundle args = getArguments();
		if (args != null)
		{
			if (args.containsKey(USER_INFO_EXTRA_NAME))
			{
				return Parcels.unwrap(args.getParcelable(USER_INFO_EXTRA_NAME));
			}
		}

		return null;
	}

	private void goToPhotos()
	{
		Fragment fragment = PhotosFragment.getInstance(getThemeIdFromArgs());
		MainActivity mainActivity = (MainActivity) getActivity();
		mainActivity.putFragmentWithBackStack(fragment);
	}

	private boolean isCurrentUserFlybook()
	{
		User user = mUserPreference.getUser();
		return getUserInfo() == null || (user != null && getUserInfo().getId() == user.getId());
	}

	private void requestFriendship()
	{
		UserInfo userInfo = getUserInfo();
		if (userInfo != null)
		{
			DialogInterface dialog = showProgressDialog(R.string.add_friend_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.requestFriendship(userInfo.getId());
			getSpiceManager().execute(spiceRequest, new com.octo.android.robospice.request.listener.RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					dialog.cancel();

					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					dialog.cancel();

					if (response.getCode() == ResponseStatus.Ok)
					{
						showToast(R.string.request_friendship_success);

						if (mFlybookUser != null)
						{
							mFlybookUser.setFriendshipRequestSent(true);
							mFlybookUser.setSubscribed(true);
						}
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.add_friend_failed);
							showToast(message);
						}
					}

					getActivity().invalidateOptionsMenu();
				}
			});
		}
	}

	private void subscribe()
	{
		if (mFlybookUser != null)
		{
			DialogInterface dialog = showProgressDialog(R.string.subscribe_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.subscribe(mFlybookUser.getId());
			getSpiceManager().execute(spiceRequest, new com.octo.android.robospice.request.listener.RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					dialog.cancel();

					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					dialog.cancel();

					if (response.getCode() == ResponseStatus.Ok)
					{
						showToast(R.string.subscribe_success);

						if (mFlybookUser != null)
						{
							mFlybookUser.setSubscribed(true);
							getActivity().invalidateOptionsMenu();
						}
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.subscribe_failed);
							showToast(message);
						}
					}
				}
			});
		}
	}

	private void unfriend()
	{
		if (mFlybookUser != null)
		{
			mFlybookUser.setFriend(false);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.unfriend(mFlybookUser.getId());
			getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					if (response.getCode() != ResponseStatus.Ok)
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.unfriend_failed);
						showToast(message);

						mFlybookUser.setFriend(true);
						mFlybookUser.setSubscribed(true);
						getActivity().invalidateOptionsMenu();
					}
				}
			});

			getActivity().invalidateOptionsMenu();
		}
	}

	private void unsubscribe()
	{
		if (mFlybookUser != null)
		{
			mFlybookUser.setSubscribed(false);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.unsubscribe(mFlybookUser.getId());
			getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					if (response.getCode() != ResponseStatus.Ok)
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.unsubscribe_failed);
						showToast(message);

						mFlybookUser.setSubscribed(true);
						getActivity().invalidateOptionsMenu();
					}
				}
			});

			getActivity().invalidateOptionsMenu();
		}
	}

	private enum Tab
	{
		Desc,
		Dreams,
		DreamsDone,
		Notes
	}

	private static class PagerAdapter extends FragmentStatePagerAdapter
	{
		private final UserInfo mUserInfo;
		private final Integer mTheme;
		private Context context;
		private Integer dreamCount;
		private Integer postCount;
		private Integer dreamDoneCount;

		public PagerAdapter(@NonNull Context context, @NonNull FragmentManager fm, UserInfo userInfo, @StyleRes Integer theme)
		{
			super(fm);
			this.context = context;
			mUserInfo = userInfo;
			mTheme = theme;
		}

		@Override
		public int getCount()
		{
			return Tab.values().length;
		}

		@Override
		public Fragment getItem(int position)
		{
			switch (Tab.values()[position])
			{
				case Desc:
					return FlybookUserInfoFragment.getInstance(mUserInfo, mTheme);
				case Dreams:
					return FlybookDreamFragment.getInstance(mUserInfo, mTheme);
				case DreamsDone:
					return FlybookDreamDoneFragment.getInstance(mUserInfo, mTheme);
				case Notes:
					return FlybookPostFragment.getInstance(mUserInfo, mTheme);
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		@Override
		public CharSequence getPageTitle(int position)
		{
			switch (Tab.values()[position])
			{
				case Desc:
					return context.getString(R.string.profile_caps);
				case Dreams:
					return getDreamTitle();
				case DreamsDone:
					return getDreamDoneTitle();
				case Notes:
					return getPostTitle();
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		public void setDreamCount(int dreamCount)
		{
			this.dreamCount = dreamCount;
			notifyDataSetChanged();
		}

		public void setDreamDoneCount(int dreamDoneCount)
		{
			this.dreamDoneCount = dreamDoneCount;
			notifyDataSetChanged();
		}

		public void setPostCount(int postCount)
		{
			this.postCount = postCount;
			notifyDataSetChanged();
		}

		@NonNull
		private String getDreamDoneTitle()
		{
			if (dreamDoneCount == null)
			{
				return context.getString(R.string.dream_done_caps);
			}
			else
			{
				switch (dreamDoneCount)
				{
					case 0:
						return context.getString(R.string.dream_done_count_format_caps_0, dreamDoneCount);

					case 1:
						return context.getString(R.string.dream_done_count_format_caps_1, dreamDoneCount);

					case 2:
					case 3:
					case 4:
						return context.getString(R.string.dream_done_count_format_caps_2_4, dreamDoneCount);

					default:
						return context.getString(R.string.dream_done_count_format_caps_5, dreamDoneCount);
				}
			}
		}

		@NonNull
		private String getDreamTitle()
		{
			if (dreamCount == null)
			{
				return context.getString(R.string.dream_caps);
			}
			else
			{
				switch (dreamCount)
				{
					case 0:
						return context.getString(R.string.dream_count_format_caps_0, dreamCount);

					case 1:
						return context.getString(R.string.dream_count_format_caps_1, dreamCount);

					case 2:
					case 3:
					case 4:
						return context.getString(R.string.dream_count_format_caps_2_4, dreamCount);

					default:
						return context.getString(R.string.dream_count_format_caps_5, dreamCount);
				}
			}
		}

		@NonNull
		private String getPostTitle()
		{
			if (postCount == null)
			{
				return context.getString(R.string.note_count);
			}
			else
			{
				switch (postCount)
				{
					case 0:
						return context.getString(R.string.note_count_format_caps_0, postCount);

					case 1:
						return context.getString(R.string.note_count_format_caps_1, postCount);

					case 2:
					case 3:
					case 4:
						return context.getString(R.string.note_count_format_caps_2_4, postCount);

					default:
						return context.getString(R.string.note_count_format_caps_5, postCount);
				}
			}
		}
	}
}
