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
import com.mydreams.android.adapters.DreamTopAdapter;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.DreamTopResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;

import org.apache.commons.lang3.StringUtils;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamTopFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, EndlessScrollListener.IEndlessListener
{
	private static final int DREAM_PAGE_SIZE = 10;
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout mRefreshLayout;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;
	private ToolbarManager mToolbarManager;
	private DreamTopAdapter mAdapter;
	private UserPreference mUserPreference;
	private boolean mWaitDreams;
	/**
	 * Индекс следующей страницы. Индекс в отличии от самой страници начинается с НУЛЯ
	 */
	private int mNextPageIndex;
	private BaseSpiceRequest<DreamTopResponse> mDreamUpdateRequest;
	/**
	 * ещё есть страницы для загрузки
	 */
	private boolean mHasMorePages = true;

	public static Fragment getInstance()
	{
		final Bundle args = new Bundle();
		setThemeIdInArgs(args, R.style.YellowTheme);

		Fragment result = new DreamTopFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		if (mWaitDreams || !mHasMorePages)
			return;

		mAdapter.setShowFooter(true);
		updateDreams(false);
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.dream_top_menu, menu);
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
		View result = inflater.inflate(R.layout.fragment_dream_top, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_dream_top_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		setShowRetry(false);

		mRefreshLayout.setOnRefreshListener(this);
		mRefreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new DreamTopAdapter(dream -> handleDreamClick(dream, false), dream -> handleDreamClick(dream, true));
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

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.yellow_dark);

		mToolbarManager.notifyNavigationStateChanged();
		mToolbarManager.notifyNavigationStateInvalidated();
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		setShowRetry(false);
		refreshAll();
	}

	private void handleDream(@NonNull List<DreamInfo> dreams, boolean fullRefresh)
	{
		if (fullRefresh)
		{
			mAdapter.clear();
		}

		mAdapter.addAll(dreams);
	}

	private void handleDreamClick(DreamInfo item, boolean showComment)
	{
		Fragment fragment = DreamInfoFragment.getInstance(item, showComment, false, true, getThemeIdFromArgs());
		MainActivity mainActivity = (MainActivity) getActivity();
		mainActivity.putFragmentWithBackStack(fragment);
	}

	private void handleDreamUpdateError(DreamTopResponse dreamTopResponse)
	{
		if (dreamTopResponse != null)
		{
			String message = dreamTopResponse.getMessage();
			if (StringUtils.isNotBlank(message))
				showToast(message);
		}
	}

	private void refreshAll()
	{
		stopAllRequest();

		mNextPageIndex = 0;
		mHasMorePages = true;

		updateDreams(true);
	}

	private void setShowRetry(boolean show)
	{
		mRefreshLayout.setVisibility(show ? View.GONE : View.VISIBLE);
		mLayoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void setWaitDreams(boolean mWaitDreams)
	{
		this.mWaitDreams = mWaitDreams;
		updateLoadIndicators();
	}

	private void stopAllRequest()
	{
		stopDreamUpdateRequest();
	}

	private void stopDreamUpdateRequest()
	{
		if (mDreamUpdateRequest != null && !mDreamUpdateRequest.isCancelled())
		{
			mDreamUpdateRequest.cancel();
		}

		mDreamUpdateRequest = null;
	}

	private void updateDreams(boolean fullRefresh)
	{
		setWaitDreams(true);

		stopDreamUpdateRequest();


		mDreamUpdateRequest = RequestFactory.dreamTop(mNextPageIndex + 1, DREAM_PAGE_SIZE);
		getSpiceManager().execute(mDreamUpdateRequest, new RequestListener<DreamTopResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleDreamUpdateError(null);

				setWaitDreams(false);
			}

			@Override
			public void onRequestSuccess(DreamTopResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					List<DreamInfoDto> dreams = response.getDreams();

					if (dreams.size() > 0)
					{
						mNextPageIndex++;
					}
					else
					{
						mHasMorePages = false;
					}

					handleDream(Stream.of(dreams).map(DreamInfo::new).collect(Collectors.toList()), fullRefresh);
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						handleDreamUpdateError(response);
					}
				}

				setWaitDreams(false);
			}
		});
	}

	private void updateLoadIndicators()
	{
		if (!mWaitDreams)
		{//скрываем все индикаторы загрузки если ни чего в данный момент не загружается
			mRefreshLayout.setEnabled(true);

			if (mRefreshLayout.isRefreshing())
				mRefreshLayout.setRefreshing(false);

			if (mAdapter.isShowFooter())
				mAdapter.setShowFooter(false);
		}
	}
}
