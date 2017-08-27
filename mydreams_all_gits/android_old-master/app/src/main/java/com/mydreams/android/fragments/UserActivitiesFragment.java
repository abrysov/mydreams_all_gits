package com.mydreams.android.fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
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
import com.mydreams.android.adapters.UserActivityAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.UserActivity;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.UserActivityDto;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.UserActivitiesResponse;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;

import org.apache.commons.lang3.StringUtils;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class UserActivitiesFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, EndlessScrollListener.IEndlessListener
{
	private static final int ACTIVITY_PAGE_SIZE = 10;
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout mRefreshLayout;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;
	private ToolbarManager mToolbarManager;
	private UserActivityAdapter mAdapter;
	private UserPreference mUserPreference;
	private boolean mWaitActivity;
	/**
	 * Индекс следующей страницы. Индекс в отличии от самой страници начинается с НУЛЯ
	 */
	private int mNextPageIndex;
	private BaseSpiceRequest<UserActivitiesResponse> mActivityUpdateRequest;
	/**
	 * ещё есть страницы для загрузки
	 */
	private boolean mHasMorePages = true;

	public static Fragment getInstance()
	{
		final Bundle args = new Bundle();
		setThemeIdInArgs(args, R.style.RedTheme);

		Fragment result = new UserActivitiesFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		if (mWaitActivity || !mHasMorePages)
			return;

		mAdapter.setShowFooter(true);
		updateActivity(false);
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.user_activity_menu, menu);
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
		View result = inflater.inflate(R.layout.fragment_user_acctivity, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_user_activity_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		setShowRetry(false);

		mRefreshLayout.setOnRefreshListener(this);
		mRefreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new UserActivityAdapter(this::handleClickUser, this::handleClickDreamActivity, this::handleClickPhotoActivity);
		mAdapter.setFooterView(R.layout.row_load_more);
		mAdapter.setShowFooter(true);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

		refreshAll();
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
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		setShowRetry(false);
		refreshAll();
	}

	private void handleActivities(@NonNull List<UserActivity> activities, boolean fullRefresh)
	{
		if (fullRefresh)
		{
			mAdapter.clear();
		}

		mAdapter.addAll(activities);
	}

	private void handleClickDreamActivity(final UserActivity userActivity)
	{
		Fragment fragment = DreamInfoFragment.getInstance(userActivity.getDream(), false, null, false, getThemeIdFromArgs());
		MainActivity mainActivity = (MainActivity) getActivity();
		mainActivity.putFragmentWithBackStack(fragment);
	}

	private void handleClickPhotoActivity(final UserActivity userActivity)
	{
		Fragment fragment = FlybookFragment.getInstance(userActivity.getUser());

		MainActivity activity = (MainActivity) getActivity();
		activity.putFragmentWithBackStack(fragment);
	}

	private void handleClickUser(final UserActivity userActivity)
	{
		Fragment fragment = FlybookFragment.getInstance(userActivity.getUser());

		MainActivity activity = (MainActivity) getActivity();
		activity.putFragmentWithBackStack(fragment);
	}

	private void handleUpdateError(UserActivitiesResponse userActivitiesResponse)
	{
		if (userActivitiesResponse != null)
		{
			String message = userActivitiesResponse.getMessage();
			if (StringUtils.isNotBlank(message))
				showToast(message);
		}
	}

	private void refreshAll()
	{
		stopAllRequest();

		mNextPageIndex = 0;
		mHasMorePages = true;

		updateActivity(true);
	}

	private void setShowRetry(boolean show)
	{
		mRefreshLayout.setVisibility(show ? View.GONE : View.VISIBLE);
		mLayoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void setWaitActivity(boolean mWaitDreams)
	{
		this.mWaitActivity = mWaitDreams;
		updateLoadIndicators();
	}

	private void stopAllRequest()
	{
		stopUpdateRequest();
	}

	private void stopUpdateRequest()
	{
		if (mActivityUpdateRequest != null && !mActivityUpdateRequest.isCancelled())
		{
			mActivityUpdateRequest.cancel();
		}

		mActivityUpdateRequest = null;
	}

	private void updateActivity(boolean fullRefresh)
	{
		setWaitActivity(true);

		stopUpdateRequest();

		mActivityUpdateRequest = RequestFactory.getUserActivities(mNextPageIndex + 1, ACTIVITY_PAGE_SIZE);
		getSpiceManager().execute(mActivityUpdateRequest, new RequestListener<UserActivitiesResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleUpdateError(null);

				setWaitActivity(false);
			}

			@Override
			public void onRequestSuccess(UserActivitiesResponse response)
			{
				List<UserActivityDto> activities = response.getUserActivities();

				if (response.getCode() == ResponseStatus.Ok)
				{
					if (activities.size() > 0)
					{
						mNextPageIndex++;
					}
					else
					{
						mHasMorePages = false;
					}

					handleActivities(Stream.of(activities).map(UserActivity::new).collect(Collectors.toList()), fullRefresh);
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						handleUpdateError(response);
					}
				}

				setWaitActivity(false);
			}
		});
	}

	private void updateLoadIndicators()
	{
		if (!mWaitActivity)
		{//скрываем все индикаторы загрузки если ни чего в данный момент не загружается
			mRefreshLayout.setEnabled(true);

			if (mRefreshLayout.isRefreshing())
				mRefreshLayout.setRefreshing(false);

			if (mAdapter.isShowFooter())
				mAdapter.setShowFooter(false);
		}
	}

}
