package com.mydreams.android.fragments.flybook;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.FlybookDreamAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.DreamInfoFragment;
import com.mydreams.android.fragments.DreamsProposedFragment;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public abstract class BaseFlybookDreamFragment  extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, EndlessScrollListener.IEndlessListener
{
	private static final int DREAM_PAGE_SIZE = 10;
	protected static final String USER_INFO_ARGS_NAME = "USER_INFO_ARGS_NAME";
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout mRefreshLayout;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;
	private FlybookDreamAdapter mAdapter;
	private UserPreference mUserPreference;
	private boolean mWaitDreams;
	/**
	 * Индекс следующей страницы. Индекс в отличии от самой страници начинается с НУЛЯ
	 */
	private int mNextPageIndex;
	private BaseSpiceRequest<RequestFactory.FlybookDreamsResponse> mDreamUpdateRequest;
	/**
	 * ещё есть страницы для загрузки
	 */
	private boolean mHasMorePages = true;
	private Integer dreamProposed;

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		if (mWaitDreams || !mHasMorePages)
			return;

		mAdapter.setShowFooter(true);
		updateDreams(false);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_flybook_dream, container, false);

		ButterKnife.bind(this, result);

		setShowRetry(false);

		mRefreshLayout.setOnRefreshListener(this);
		mRefreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new FlybookDreamAdapter(dream -> handleItemClick(dream, false), dream -> handleItemClick(dream, true));
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

		refreshAll();
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		setShowRetry(false);
		refreshAll();
	}

	private int getUserId()
	{
		return getUserInfo().getId();
	}

	private UserInfo getUserInfo()
	{
		if (getArguments().containsKey(USER_INFO_ARGS_NAME))
			return Parcels.unwrap(getArguments().getParcelable(USER_INFO_ARGS_NAME));

		return new UserInfo(mUserPreference.getUser());
	}

	private void handleDream(@NonNull List<DreamInfo> dreams, boolean fullRefresh)
	{
		if (fullRefresh)
		{
			mAdapter.clear();
		}

		mAdapter.addAll(dreams);
	}

	private void handleDreamProposed(final Integer value)
	{
		if (this.dreamProposed == null)
		{
			if (mAdapter.getAdapterItemCount() > 0)
			{
				if (mAdapter.getItem(0) instanceof Integer)
					mAdapter.remove(0);
			}

			if (value != null && value > 0)
			{
				dreamProposed = value;
				mAdapter.insert(0, value);
			}
		}
	}

	private void handleDreamUpdateError(RequestFactory.FlybookDreamsResponse response)
	{
		if (response != null)
		{
			String message = response.getMessage();
			if (StringUtils.isNotBlank(message))
				showToast(message);
		}

		setShowRetry(true);
	}

	private void handleItemClick(Object item, boolean showComment)
	{
		if (item instanceof DreamInfo)
		{
			DreamInfo dream = (DreamInfo) item;
			User user = mUserPreference.getUser();
			boolean isMyDream = user != null && user.getId() == getUserId();

			Fragment fragment = DreamInfoFragment.getInstance(dream, showComment, isMyDream, true, getThemeIdFromArgs());
			MainActivity mainActivity = (MainActivity) getActivity();
			mainActivity.putFragmentWithBackStack(fragment);
		}
		else if (item instanceof Integer)
		{
			getMainActivity().putFragmentWithBackStack(DreamsProposedFragment.getInstance(getThemeIdFromArgs()));
		}
	}

	private void refreshAll()
	{
		stopDreamUpdateRequest();

		mNextPageIndex = 0;
		mHasMorePages = true;
		dreamProposed = null;

		mAdapter.setShowFooter(true);
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

		mDreamUpdateRequest = createRequest(getUserId(), mNextPageIndex + 1, DREAM_PAGE_SIZE);
		getSpiceManager().execute(mDreamUpdateRequest, new RequestListener<RequestFactory.FlybookDreamsResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleDreamUpdateError(null);

				setWaitDreams(false);
			}

			@Override
			public void onRequestSuccess(RequestFactory.FlybookDreamsResponse response)
			{
				if (response.getStatus() == ResponseStatus.Ok)
				{
					List<DreamInfoDto> dreams = response.getDreams();
					if (dreams == null)
						dreams = new ArrayList<>();

					if (dreams.size() > 0)
					{
						mNextPageIndex++;
					}
					else
					{
						mHasMorePages = false;
					}

					handleDream(Stream.of(dreams).map(DreamInfo::new).collect(Collectors.toList()), fullRefresh);
					handleDreamProposed(response.getDreamProposed());

					handleDreamTotal(response.getDreamTotal());
				}
				else
				{
					if (response.getStatus() == ResponseStatus.Unauthorized)
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

	protected abstract void handleDreamTotal(final int dreamTotal);

	protected abstract BaseSpiceRequest<RequestFactory.FlybookDreamsResponse> createRequest(final int userId, final int page, final int dreamPageSize);

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
