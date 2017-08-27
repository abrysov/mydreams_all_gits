package com.mydreams.android.fragments.dreaminfo;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.dreaminfo.DreamLaunchAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.fragments.DreamInfoFragment;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.models.Launch;
import com.mydreams.android.service.models.LaunchDto;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.GetDreamLaunchesResponse;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.parceler.Parcels;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamLaunchFragment extends BaseFragment implements EndlessScrollListener.IEndlessListener, SwipeRefreshLayout.OnRefreshListener
{
	protected static final int PAGE_SIZE = 20;
	private static final String DREAM_INFO_EXTRA_NAME = "DREAM_INFO_EXTRA_NAME";
	protected DreamLaunchAdapter mAdapter;
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout refreshLayout;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.layoutList)
	View layoutList;
	@Bind(R.id.lblEmptyListMessage)
	TextView lblEmptyListMessage;
	private DreamInfo dreamInfo;
	/**
	 * Последний исполняющийся  запрос
	 */
	@Nullable
	private BaseSpiceRequest<GetDreamLaunchesResponse> lastRequest;
	private int nextPageIndex;
	private AtomicInteger currentRequestId = new AtomicInteger();
	@Nullable
	private RequestCriteria waitingCriteria;
	private boolean availableNextPage = true;

	public static Fragment getInstance(@NonNull DreamInfo item, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(DREAM_INFO_EXTRA_NAME, Parcels.wrap(item));

		if (theme == null)
			theme = R.style.AppTheme;
		setThemeIdInArgs(args, theme);

		Fragment result = new DreamLaunchFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		loadNextPage();
	}

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_dream_launches, container, false);

		ButterKnife.bind(this, result);

		showRetry(false);
		showEmptyListMessage(false);
		lblEmptyListMessage.setText(getEmptyListMessage());

		refreshLayout.setOnRefreshListener(this);
		refreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new DreamLaunchAdapter(this::handleItemClick);
		mAdapter.setFooterView(R.layout.row_load_more);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

		return result;
	}

	@Override
	public void onPause()
	{
		super.onPause();

		closeCurrentRequest();
	}

	@Override
	public void onRefresh()
	{
		refreshLayout.setRefreshing(true);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		hideLoadMoreProgress();

		refresh();
	}

	@Override
	public void onResume()
	{
		super.onResume();

		refresh();
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		showRetry(false);
		refresh();
	}

	private void addItems(List<LaunchDto> items)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		mAdapter.addAll(Stream.of(items).map(Launch::new).map(DreamLaunchAdapter.LaunchModel::new).collect(Collectors.toList()));
		showEmptyListMessage(mAdapter.getAdapterItemCount() == 0);
	}

	/**
	 * останавливает текущий запрос
	 */
	private void closeCurrentRequest()
	{
		if (lastRequest != null)
		{
			lastRequest.cancel();
			lastRequest = null;
		}

		waitingCriteria = null;
	}

	private void executeRequest(RequestCriteria criteria)
	{
		closeCurrentRequest();

		int requestId = currentRequestId.incrementAndGet();
		waitingCriteria = criteria;

		BaseSpiceRequest<GetDreamLaunchesResponse> request = RequestFactory.getDreamLaunches(getDreamInfo().getId(), nextPageIndex + 1, PAGE_SIZE);
		lastRequest = request;
		getSpiceManager().execute(request, new RequestListener<GetDreamLaunchesResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleRequestFailure(spiceException, requestId, criteria);
			}

			@Override
			public void onRequestSuccess(GetDreamLaunchesResponse response)
			{
				handleRequestResult(response, requestId, criteria);
			}
		});
	}

	private DreamInfo getDreamInfo()
	{
		if (dreamInfo == null)
		{
			dreamInfo = Parcels.unwrap(getArguments().getParcelable(DREAM_INFO_EXTRA_NAME));
		}

		return dreamInfo;
	}

	@StringRes
	private int getEmptyListMessage()
	{
		return R.string.launches_empty_list;
	}

	private void handleItemClick(int position)
	{
		DreamLaunchAdapter.LaunchModel model = (DreamLaunchAdapter.LaunchModel) mAdapter.getItem(position);
		Fragment fragment = FlybookFragment.getInstance(model.getLaunch().getUser());

		MainActivity activity = (MainActivity) getActivity();
		activity.putFragmentWithBackStack(fragment);
	}

	private void handleRequestFailure(SpiceException spiceException, int requestId, RequestCriteria criteria)
	{
		spiceException.printStackTrace();

		if (isCurrentRequest(requestId))
		{
			if (!criteria.fullRefresh && shouldRetryRequest())
			{
				executeRequest(criteria);
			}
			else
			{
				hideLoadMoreProgress();

				handleRequestFailure();
			}
		}
	}

	private void handleRequestFailure()
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		showRetry(true);
	}

	private void handleRequestResult(GetDreamLaunchesResponse response, int requestId, RequestCriteria criteria)
	{
		if (isCurrentRequest(requestId))
		{
			waitingCriteria = null;

			hideLoadMoreProgress();

			if (criteria.fullRefresh)
				removeAllItems();

			List<LaunchDto> launches = response.getLaunches();
			availableNextPage = launches.size() == PAGE_SIZE;

			addItems(launches);

			DreamInfoFragment parent = (DreamInfoFragment) getParentFragment();
			if (parent != null)
			{
				parent.setLaunches(response.getBody().getLaunchCollectionBody().getTotal());
			}
		}
	}

	private void hideLoadMoreProgress()
	{
		mAdapter.setShowFooter(false);
	}

	private boolean isCurrentRequest(int requestId)
	{
		return currentRequestId.get() == requestId;
	}

	private void loadNextPage()
	{
		if (waitingCriteria != null && waitingCriteria.fullRefresh)
			return;

		if (!availableNextPage)
			return;

		showLoadMoreProgress();

		RequestCriteria newCriteria = RequestCriteria.forLoadMore();
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		executeRequest(newCriteria);
		nextPageIndex++;
	}

	private void refresh()
	{
		RequestCriteria newCriteria = RequestCriteria.forRefresh();
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		showLoadMoreProgress();

		availableNextPage = true;
		nextPageIndex = 0;
		executeRequest(newCriteria);
		nextPageIndex++;
	}

	private void removeAllItems()
	{
		mAdapter.clear();
	}

	private boolean shouldRetryRequest()
	{
		return mAdapter.getAdapterItemCount() != 0;
	}

	private void showEmptyListMessage(boolean show)
	{
		lblEmptyListMessage.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void showLoadMoreProgress()
	{
		if (!refreshLayout.isRefreshing())
			mAdapter.setShowFooter(true);
	}

	private void showRetry(boolean show)
	{
		layoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
		layoutList.setVisibility(show ? View.GONE : View.VISIBLE);
	}

	private static class RequestCriteria
	{
		public boolean fullRefresh;
		public boolean loadMore;

		private RequestCriteria()
		{
		}

		public static boolean equals(RequestCriteria a, RequestCriteria b)
		{
			return a == null ? b == null : a.equals(b);
		}

		public static RequestCriteria forLoadMore()
		{
			RequestCriteria result = new RequestCriteria();

			result.loadMore = true;

			return result;
		}

		public static RequestCriteria forRefresh()
		{
			RequestCriteria result = new RequestCriteria();

			result.fullRefresh = true;

			return result;
		}

		@Override
		public boolean equals(Object other)
		{
			if (other == null)
				return false;

			if (other instanceof RequestCriteria)
				return equals((RequestCriteria) other);

			return super.equals(other);
		}

		private boolean equals(RequestCriteria other)
		{
			return other != null && loadMore == other.loadMore && fullRefresh == other.fullRefresh;
		}
	}

}
