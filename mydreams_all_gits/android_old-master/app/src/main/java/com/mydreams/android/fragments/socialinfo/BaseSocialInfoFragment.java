package com.mydreams.android.fragments.socialinfo;

import android.os.Bundle;
import android.os.Parcelable;
import android.support.annotation.Nullable;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.badoo.mobile.util.WeakHandler;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.UserInfoDto;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Parcels;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

public abstract class BaseSocialInfoFragment extends BaseFragment
{
	protected static final int PAGE_SIZE = 20;
	private static final int DEFAULT_SEARCH_DELAY_MS = 500;
	private static final String STATE_EXTRA_NAME = "STATE_EXTRA_NAME";
	private WeakHandler handler;
	/**
	 * Последний исполняющийся  запрос
	 */
	@Nullable
	private BaseSpiceRequest<SocialInfoResponse> lastRequest;

	/**
	 * для какого запроса в данный момент показаны результаты
	 */
	@Nullable
	private String currentFilter;
	private int nextPageIndex;
	private AtomicInteger currentRequestId = new AtomicInteger();
	@Nullable
	private RequestCriteria waitingCriteria;
	private boolean availableNextPage = true;

	protected abstract void addItems(List<UserInfo> items);

	protected abstract BaseSpiceRequest<SocialInfoResponse> createRequest(String filter, int page);

	protected abstract void handleRequestFailure();

	protected abstract void hideLoadMoreProgress();

	protected abstract void removeAllItems();

	protected abstract boolean shouldRetryRequest();

	protected abstract void showLoadMoreProgress();

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		handler = new WeakHandler();
	}

	@Override
	public void onPause()
	{
		super.onPause();

		closeCurrentRequest();
	}

	@Override
	public void onResume()
	{
		super.onResume();

		refresh();
	}

	@Override
	public void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);

		State state = new State();
		state.currentFilter = currentFilter;
		if (waitingCriteria != null)
			state.currentFilter = waitingCriteria.filter;

		outState.putParcelable(STATE_EXTRA_NAME, Parcels.wrap(state));
	}

	@Nullable
	public String getCurrentFilter()
	{
		return currentFilter;
	}

	public void loadNextPage()
	{
		if (!availableNextPage)
			return;

		showLoadMoreProgress();

		RequestCriteria newCriteria = RequestCriteria.forLoadMore(currentFilter);
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		executeRequest(newCriteria);
		nextPageIndex++;
	}

	public void refresh()
	{
		refresh(currentFilter);
	}

	public void setFilter(String filter)
	{
		if (isCurrentFilter(filter))
			return;

		handler.postDelayed(() ->
		{
			showLoadMoreProgress();

			removeAllItems();
			refresh(filter);
		}, DEFAULT_SEARCH_DELAY_MS);
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
		int requestId = currentRequestId.incrementAndGet();
		waitingCriteria = criteria;

		closeCurrentRequest();

		BaseSpiceRequest<SocialInfoResponse> request = createRequest(criteria.filter, nextPageIndex + 1);
		lastRequest = request;
		getSpiceManager().execute(request, new RequestListener<SocialInfoResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleRequestFailure(spiceException, requestId, criteria);
			}

			@Override
			public void onRequestSuccess(SocialInfoResponse socialInfoResponse)
			{
				try
				{
					if (socialInfoResponse.getCode() == ResponseStatus.Ok)
					{
						handleRequestResult(socialInfoResponse, requestId, criteria);
					}
					else
					{
						handleRequestFailure(socialInfoResponse, requestId, criteria);
					}
				}
				catch (Exception ex)
				{
					handleRequestFailure(ex, requestId, criteria);
				}
			}
		});
	}

	private void handleRequestFailure(final SocialInfoResponse socialInfoResponse, int requestId, RequestCriteria criteria)
	{
		if (isCurrentRequest(requestId))
		{
			if (socialInfoResponse.getCode() == ResponseStatus.Unauthorized)
			{
				getMainActivity().goToSignIn();
			}

			handleRequestFailure((Exception) null, requestId, criteria);
		}

	}

	private void handleRequestFailure(@Nullable Exception exception, int requestId, RequestCriteria criteria)
	{
		if (exception != null)
			exception.printStackTrace();

		if (isCurrentRequest(requestId))
		{
			waitingCriteria = null;

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

	protected boolean handleRequestResult(SocialInfoResponse response, int requestId, RequestCriteria criteria)
	{
		if (isCurrentRequest(requestId))
		{
			waitingCriteria = null;
			currentFilter = criteria.filter;

			hideLoadMoreProgress();

			if (criteria.fullRefresh)
				removeAllItems();

			List<UserInfoDto> users = response.getUsers();
			availableNextPage = users.size() == PAGE_SIZE;

			addItems(Stream.of(users).map(UserInfo::new).collect(Collectors.toList()));

			return true;
		}
		else
		{
			return false;
		}
	}

	private boolean isCurrentFilter(String filter)
	{
		return StringUtils.defaultString(currentFilter).equals(StringUtils.defaultString(filter));
	}

	protected boolean isCurrentRequest(int requestId)
	{
		return currentRequestId.get() == requestId;
	}

	private void refresh(String filter)
	{
		RequestCriteria newCriteria = RequestCriteria.forRefresh(filter);
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		showLoadMoreProgress();

		availableNextPage = true;
		nextPageIndex = 0;
		executeRequest(newCriteria);
		nextPageIndex++;
	}

	protected void restoreSaveInstanceState(@Nullable Bundle savedInstanceState)
	{
		if (savedInstanceState != null)
		{
			Parcelable stateParcelable = savedInstanceState.getParcelable(STATE_EXTRA_NAME);
			if (stateParcelable != null)
			{
				State state = Parcels.unwrap(stateParcelable);
				currentFilter = state.currentFilter;
			}
		}
	}

	@Parcel
	public static class State
	{
		public String currentFilter;

		public State()
		{
		}
	}

	protected static class RequestCriteria
	{
		public boolean fullRefresh;
		public boolean loadMore;
		public String filter;

		private RequestCriteria()
		{
		}

		public static boolean equals(RequestCriteria a, RequestCriteria b)
		{
			return a == null ? b == null : a.equals(b);
		}

		public static RequestCriteria forLoadMore(String filter)
		{
			RequestCriteria result = new RequestCriteria();

			result.filter = filter;
			result.loadMore = true;

			return result;
		}

		public static RequestCriteria forRefresh(String filter)
		{
			RequestCriteria result = new RequestCriteria();

			result.filter = filter;
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
			return other != null && (filter == null ? other.filter == null : filter.equals(other.filter)) && loadMore == other.loadMore && fullRefresh == other.fullRefresh;
		}
	}
}
