package com.mydreams.android.fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.SearchUserAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.FilterUser;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.UserInfoDto;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.SearchUserResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;

import org.apache.commons.lang3.StringUtils;

import java.util.List;
import java.util.UUID;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SearchUserFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, EndlessScrollListener.IEndlessListener
{
	private static final int USER_PAGE_SIZE = 10;
	private static final String FILTER_REQUEST_UUID_EXTRA_NAME = "FILTER_REQUEST_UUID_EXTRA_NAME";
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout mRefreshLayout;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;
	private FilterUser mFilter;
	private ToolbarManager mToolbarManager;
	private SearchUserAdapter mAdapter;
	private UserPreference mUserPreference;
	private boolean mWaitUsers;
	/**
	 * Индекс следующей страницы. Индекс в отличии от самой страници начинается с НУЛЯ
	 */
	private int mNextPageIndex;
	private BaseSpiceRequest<SearchUserResponse> mUsersUpdateRequest;
	/**
	 * ещё есть страницы для загрузки
	 */
	private boolean mHasMorePages = true;
	private UUID mFilterRequestUUID;

	public static Fragment getInstance()
	{
		return new SearchUserFragment();
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		if (mWaitUsers || !mHasMorePages)
			return;

		mAdapter.setShowFooter(true);
		updateUsers(false);
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.search_user_menu, menu);
		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.light_green_dark);

		if (savedInstanceState != null)
		{
			if (savedInstanceState.containsKey(FILTER_REQUEST_UUID_EXTRA_NAME))
				mFilterRequestUUID = (UUID) savedInstanceState.getSerializable(FILTER_REQUEST_UUID_EXTRA_NAME);
		}

		mUserPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		ContextThemeWrapper themeWrapper = new ContextThemeWrapper(inflater.getContext(), R.style.LightGreenTheme);
		inflater = LayoutInflater.from(themeWrapper);
		View result = inflater.inflate(R.layout.fragment_search_user, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_search_user_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		setShowRetry(false);

		mRefreshLayout.setOnRefreshListener(this);
		mRefreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new SearchUserAdapter(this::handleUserClick);
		mAdapter.setFooterView(R.layout.row_load_more);
		mAdapter.setShowFooter(true);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

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

			case R.id.filter:
				goToFilter();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		mToolbarManager.onPrepareMenu();
		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public void onRefresh()
	{
		mRefreshLayout.setRefreshing(true);
		mRefreshLayout.setEnabled(false);

		refreshAll();
	}

	@Override
	public void onResume()
	{
		super.onResume();

		mToolbarManager.notifyNavigationStateChanged();
		mToolbarManager.notifyNavigationStateInvalidated();

		if(mFilterRequestUUID != null)
		{
			Bundle data = getMainActivity().getFragmentResult(mFilterRequestUUID);
			mFilterRequestUUID = null;

			if(data != null)
			mFilter = FilterUserFragment.extractResult(data);
		}
		refreshAll();
	}

	@Override
	public void onSaveInstanceState(final Bundle outState)
	{
		super.onSaveInstanceState(outState);

		if (mFilterRequestUUID != null)
			outState.putSerializable(FILTER_REQUEST_UUID_EXTRA_NAME, mFilterRequestUUID);
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		setShowRetry(false);
		refreshAll();
	}

	@NonNull
	private FilterUser getFilter()
	{
		if (mFilter == null)
			mFilter = new FilterUser();

		return mFilter;
	}

	private void goToFilter()
	{
		mFilterRequestUUID = UUID.randomUUID();
		Fragment fragment = FilterUserFragment.getInstance(mFilterRequestUUID, mFilter);
		getMainActivity().putFragmentWithBackStack(fragment);
	}

	private void handleUserClick(final UserInfo userInfo)
	{
		Fragment fragment = FlybookFragment.getInstance(userInfo);

		MainActivity activity = (MainActivity) getActivity();
		activity.putFragmentWithBackStack(fragment);
	}

	private void handleUsers(@NonNull List<UserInfo> users, boolean fullRefresh)
	{
		if (fullRefresh)
		{
			mAdapter.clear();
		}

		mAdapter.addAll(users);
	}

	private void handleUsersUpdateError(SearchUserResponse response)
	{
		if (response != null)
		{
			String message = response.getMessage();
			if (StringUtils.isNotBlank(message))
				showToast(message);
		}
	}

	private void refreshAll()
	{
		stopAllRequest();

		mNextPageIndex = 0;
		mHasMorePages = true;

		updateUsers(true);
	}

	private void setShowRetry(boolean show)
	{
		mRefreshLayout.setVisibility(show ? View.GONE : View.VISIBLE);
		mLayoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void setWaitUsers(boolean mWaitDreams)
	{
		this.mWaitUsers = mWaitDreams;
		updateLoadIndicators();
	}

	private void stopAllRequest()
	{
		stopUsersUpdateRequest();
	}

	private void stopUsersUpdateRequest()
	{
		if (mUsersUpdateRequest != null && !mUsersUpdateRequest.isCancelled())
		{
			mUsersUpdateRequest.cancel();
		}

		mUsersUpdateRequest = null;
	}

	private void updateLoadIndicators()
	{
		if (!mWaitUsers)
		{//скрываем все индикаторы загрузки если ни чего в данный момент не загружается
			mRefreshLayout.setEnabled(true);

			if (mRefreshLayout.isRefreshing())
				mRefreshLayout.setRefreshing(false);

			if (mAdapter.isShowFooter())
				mAdapter.setShowFooter(false);
		}
	}

	private void updateUsers(boolean fullRefresh)
	{
		setWaitUsers(true);

		stopUsersUpdateRequest();

		mUsersUpdateRequest = RequestFactory.searchUsers(mNextPageIndex + 1, USER_PAGE_SIZE, getFilter());
		getSpiceManager().execute(mUsersUpdateRequest, new RequestListener<SearchUserResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleUsersUpdateError(null);

				setWaitUsers(false);
			}

			@Override
			public void onRequestSuccess(SearchUserResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					List<UserInfoDto> items = response.getUsers();
					if (items.size() > 0)
					{
						mNextPageIndex++;
					}
					else
					{
						mHasMorePages = false;
					}

					handleUsers(Stream.of(items).map(UserInfo::new).collect(Collectors.toList()), fullRefresh);
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						handleUsersUpdateError(response);
					}
				}

				setWaitUsers(false);
			}
		});
	}
}
