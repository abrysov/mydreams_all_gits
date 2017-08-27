package com.mydreams.android.fragments;

import android.app.SearchManager;
import android.content.Context;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.util.SparseArray;
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
import com.mydreams.android.fragments.socialinfo.BaseSocialInfoFragment;
import com.mydreams.android.fragments.socialinfo.FriendRequestFragment;
import com.mydreams.android.fragments.socialinfo.FriendsFragment;
import com.mydreams.android.fragments.socialinfo.SubscribedFragment;
import com.mydreams.android.fragments.socialinfo.SubscribersFragment;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.SocialStatResponse;
import com.mydreams.android.service.response.bodys.SocialStatResponseBody;
import com.mydreams.android.utils.ActivityUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.TabPageIndicator;

import org.apache.commons.lang3.StringUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SocialInfoFragment extends BaseFragment implements SearchView.OnQueryTextListener
{
	@Bind(R.id.tabPageIndicator)
	TabPageIndicator mTabPageIndicator;

	@Bind(R.id.viewPager)
	ViewPager mViewPager;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.progressBar)
	View progressBar;
	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	@Nullable
	private SearchView mSearchView;
	private PagerAdapter mPagerAdapter;
	@Nullable
	private MenuItem mSearchItem;
	@Nullable
	private SocialStatResponseBody mSocialStat;

	public static Fragment getInstance(@StyleRes int theme)
	{
		final Bundle args = new Bundle();

		setThemeIdInArgs(args, theme);

		Fragment result = new SocialInfoFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.social_info_menu, menu);
		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_social_info, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle("");
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		mPagerAdapter = new PagerAdapter(getContextByArgsTheme(), getChildFragmentManager());
		mViewPager.setAdapter(mPagerAdapter);
		mTabPageIndicator.setViewPager(mViewPager);
		mTabPageIndicator.setOnPageChangeListener(new ViewPager.OnPageChangeListener()
		{
			@Override
			public void onPageScrollStateChanged(int state)
			{
			}

			@Override
			public void onPageScrolled(int arg0, float arg1, int arg2)
			{
			}

			@Override
			public void onPageSelected(int position)
			{
				toolbar.setTitle(Tab.values()[position].nameResId);

				if (mSearchView != null)
				{
					BaseSocialInfoFragment fragment = getCurrentFragment();
					if (fragment != null)
					{    //TODO сделать нормально
						mSearchView.setQuery(fragment.getCurrentFilter(), false);
						mSearchView.clearFocus();
					}
					else
					{
						mSearchView.setQuery("", false);
					}
				}

				if (mSearchItem != null)
					mSearchItem.collapseActionView();
			}
		});

		toolbar.setTitle(Tab.values()[0].nameResId);
		mViewPager.setCurrentItem(0);

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
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		MenuItem searchItem = menu.findItem(R.id.action_search);
		this.mSearchItem = searchItem;

		SearchManager searchManager = (SearchManager) getActivity().getSystemService(Context.SEARCH_SERVICE);

		SearchView searchView = (SearchView) searchItem.getActionView();
		searchView.setSearchableInfo(searchManager.getSearchableInfo(getActivity().getComponentName()));
		searchView.setSubmitButtonEnabled(false);
		searchView.setOnQueryTextListener(this);
		searchView.setQueryHint(getString(R.string.search));
		this.mSearchView = searchView;

		mToolbarManager.onPrepareMenu();
		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public boolean onQueryTextChange(String newText)
	{
		if (newText != null)
			newSearch(newText);

		return true;
	}

	@Override
	public boolean onQueryTextSubmit(String query)
	{
		if (query != null)
			newSearch(query);

		return true;
	}

	@Override
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		if (mSocialStat == null)
		{
			updateSocialStat();
		}
		else
		{
			showViewPager();
		}
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		updateSocialStat();
	}

	public int getFriendCount()
	{
		return mPagerAdapter.friendCount;
	}

	public void setFriendCount(final int friendCount)
	{
		mPagerAdapter.setFriendCount(friendCount);
		if (mSocialStat != null)
			mSocialStat.setFriendCount(friendCount);
	}

	public int getRequestCount()
	{
		return mPagerAdapter.requestCount;
	}

	public void setRequestCount(final int requestCount)
	{
		mPagerAdapter.setRequestCount(requestCount);
		if (mSocialStat != null)
			mSocialStat.setRequestCount(requestCount);
	}

	public int getSubscribedCount()
	{
		return mPagerAdapter.subscribedCount;
	}

	/**
	 * Подписчиков
	 */
	public void setSubscribedCount(final int subscribedCount)
	{
		mPagerAdapter.setSubscribedCount(subscribedCount);
		if (mSocialStat != null)
			mSocialStat.setSubscribedCount(subscribedCount);
	}

	public int getSubscribersCount()
	{
		return mPagerAdapter.subscribersCount;
	}

	public void setSubscribersCount(final int subscribersCount)
	{
		mPagerAdapter.setSubscribersCount(subscribersCount);
		if (mSocialStat != null)
			mSocialStat.setSubscribersCount(subscribersCount);
	}

	@Nullable
	private BaseSocialInfoFragment getCurrentFragment()
	{
		return mPagerAdapter.getRegisteredFragment(mViewPager.getCurrentItem());
	}

	private void newSearch(String search)
	{
		//TODO сделать нормально
		if (getCurrentFragment() != null)
			getCurrentFragment().setFilter(StringUtils.defaultString(search));
	}

	private void setSocialStat(@NonNull final SocialStatResponseBody socialStat)
	{
		mSocialStat = socialStat;
		showViewPager();
	}

	private void showProgress()
	{
		if (mSearchItem != null)
			mSearchItem.setVisible(false);

		mViewPager.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
	}

	private void showRetry()
	{
		if (mSearchItem != null)
			mSearchItem.setVisible(false);

		mViewPager.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.VISIBLE);
	}

	private void showViewPager()
	{
		if (mSearchItem != null)
			mSearchItem.setVisible(true);

		mViewPager.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.GONE);
	}

	private void updateSocialStat()
	{
		showProgress();

		BaseSpiceRequest<SocialStatResponse> request = RequestFactory.getSocialStat(null);
		getSpiceManager().execute(request, new RequestListener<SocialStatResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				showRetry();
			}

			@Override
			public void onRequestSuccess(SocialStatResponse response)
			{
				SocialStatResponseBody socialStat = response.getBody();
				if (response.getCode() == ResponseStatus.Ok)
				{
					setSocialStat(socialStat);
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

	private enum Tab
	{
		Request(R.string.friend_request),
		Friends(R.string.friends),
		Subscribers(R.string.subscribers),
		Subscribed(R.string.subscribed);

		@StringRes
		private final int nameResId;

		Tab(@StringRes int nameResId)
		{
			this.nameResId = nameResId;
		}
	}

	private static class PagerAdapter extends FragmentStatePagerAdapter
	{
		private Context context;
		// Sparse array to keep track of registered fragments in memory
		private SparseArray<BaseSocialInfoFragment> registeredFragments = new SparseArray<>();
		private int friendCount;
		private int requestCount;
		private int subscribedCount;
		private int subscribersCount;

		public PagerAdapter(@NonNull Context context, @NonNull FragmentManager fm)
		{
			super(fm);
			this.context = context;
		}

		// Unregister when the item is inactive
		@Override
		public void destroyItem(ViewGroup container, int position, Object object)
		{
			registeredFragments.remove(position);
			super.destroyItem(container, position, object);
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
				case Friends:
					return FriendsFragment.getInstance();
				case Subscribers:
					return SubscribersFragment.getInstance();
				case Subscribed:
					return SubscribedFragment.getInstance();
				case Request:
					return FriendRequestFragment.getInstance();
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		@Override
		public CharSequence getPageTitle(int position)
		{
			switch (Tab.values()[position])
			{
				case Friends:
					return getFriendTitle();
				case Request:
					return getRequestTitle();
				case Subscribed:
					return getSubscribedTitle();
				case Subscribers:
					return getSubscribersTitle();
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		// Register the fragment when the item is instantiated
		@Override
		public Object instantiateItem(ViewGroup container, int position)
		{
			BaseSocialInfoFragment fragment = (BaseSocialInfoFragment) super.instantiateItem(container, position);
			registeredFragments.put(position, fragment);
			return fragment;
		}

		public int getFriendCount()
		{
			return friendCount;
		}

		public void setFriendCount(final int friendCount)
		{
			this.friendCount = friendCount;
			notifyDataSetChanged();
		}

		// Returns the fragment for the position (if instantiated)
		public BaseSocialInfoFragment getRegisteredFragment(int position)
		{
			return registeredFragments.get(position);
		}

		public int getRequestCount()
		{
			return requestCount;
		}

		public void setRequestCount(final int requestCount)
		{
			this.requestCount = requestCount;
			notifyDataSetChanged();
		}

		public int getSubscribedCount()
		{
			return subscribedCount;
		}

		/**
		 * Подписчиков
		 */
		public void setSubscribedCount(final int subscribedCount)
		{
			this.subscribedCount = subscribedCount;
			notifyDataSetChanged();
		}

		public int getSubscribersCount()
		{
			return subscribersCount;
		}

		public void setSubscribersCount(final int subscribersCount)
		{
			this.subscribersCount = subscribersCount;
			notifyDataSetChanged();
		}

		@NonNull
		private String getFriendTitle()
		{
			switch (friendCount)
			{
				case 0:
					return context.getString(R.string.friend_count_format_caps_0, friendCount);

				case 1:
					return context.getString(R.string.friend_count_format_caps_1, friendCount);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.friend_count_format_caps_2_4, friendCount);

				default:
					return context.getString(R.string.friend_count_format_caps_5, friendCount);
			}
		}

		@NonNull
		private String getRequestTitle()
		{
			switch (requestCount)
			{
				case 0:
					return context.getString(R.string.friend_request_count_format_caps_0, requestCount);

				case 1:
					return context.getString(R.string.friend_request_count_format_caps_1, requestCount);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.friend_request_count_format_caps_2_4, requestCount);

				default:
					return context.getString(R.string.friend_request_count_format_caps_5, requestCount);
			}
		}

		@NonNull
		private String getSubscribedTitle()
		{
			switch (subscribedCount)
			{
				case 0:
					return context.getString(R.string.subscribed_count_format_caps_0, subscribedCount);

				case 1:
					return context.getString(R.string.subscribed_count_format_caps_1, subscribedCount);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.subscribed_count_format_caps_2_4, subscribedCount);

				default:
					return context.getString(R.string.subscribed_count_format_caps_5, subscribedCount);
			}
		}

		private CharSequence getSubscribersTitle()
		{
			switch (subscribersCount)
			{
				case 0:
					return context.getString(R.string.subscribers_count_format_caps_0, subscribersCount);

				case 1:
					return context.getString(R.string.subscribers_count_format_caps_1, subscribersCount);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.subscribers_count_format_caps_2_4, subscribersCount);

				default:
					return context.getString(R.string.subscribers_count_format_caps_5, subscribersCount);
			}
		}
	}
}
