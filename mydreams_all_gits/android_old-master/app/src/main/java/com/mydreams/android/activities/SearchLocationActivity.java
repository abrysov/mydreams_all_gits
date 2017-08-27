package com.mydreams.android.activities;

import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.badoo.mobile.util.WeakHandler;
import com.mydreams.android.R;
import com.mydreams.android.adapters.LocationAdapter;
import com.mydreams.android.app.BaseActivity;
import com.mydreams.android.models.Location;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.LocationsResponse;
import com.octo.android.robospice.persistence.DurationInMillis;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.octo.android.robospice.retry.DefaultRetryPolicy;
import com.octo.android.robospice.retry.RetryPolicy;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.ProgressView;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

public class SearchLocationActivity extends BaseActivity implements SearchView.OnQueryTextListener
{
	public static final String SELECTED_LOCATION_EXTRA_NAME = "SELECTED_LOCATION_EXTRA_NAME";
	private static final int DEFAULT_SEARCH_DELAY_MS = 500;
	private static final RetryPolicy mDefaultRetryPolicy = new DefaultRetryPolicy(2, DefaultRetryPolicy.DEFAULT_DELAY_BEFORE_RETRY, DefaultRetryPolicy.DEFAULT_BACKOFF_MULT);
	private static final long DEFAULT_SEARCH_CACHE_EXPIRY_DURATION_MS = DurationInMillis.ONE_HOUR;
	private static final String COUNTRY_ID_EXTRA_NAME = "COUNTRY_ID_EXTRA_NAME";

	@Bind(R.id.list)
	RecyclerView mList;

	@Bind(R.id.toolbar)
	Toolbar mToolbar;

	@Bind(R.id.progressView)
	ProgressView progressView;

	private LocationAdapter mAdapter;

	private WeakHandler mHandler;
	private ToolbarManager mToolbarManager;

	@Nullable
	private SearchView mSearchView;

	/**
	 * Последний сделаный запрос
	 */
	@Nullable
	private BaseSpiceRequest<LocationsResponse> mLastRequest;

	/**
	 * для какой строки поиска ожидается результат
	 */
	@Nullable
	private String mWaitResultFor;

	/**
	 * для какого запроса в данный момент показаны результаты
	 */
	@Nullable
	private String mShowResultFor;

	@NonNull
	public static Location extractResult(@NonNull Intent data)
	{
		return data.getParcelableExtra(SELECTED_LOCATION_EXTRA_NAME);
	}

	public static Intent getLaunchIntent(Context context, Integer countryId)
	{
		Intent result = new Intent(context, SearchLocationActivity.class);

		if (countryId != null)
			result.putExtra(COUNTRY_ID_EXTRA_NAME, countryId.intValue());

		return result;
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_search_location);
		ButterKnife.bind(this);

		mHandler = new WeakHandler();

		setSupportActionBar(mToolbar);
		mToolbarManager = new ToolbarManager(getDelegate(), mToolbar, R.id.menu_group_main, R.style.ToolbarRippleStyle, R.anim.abc_fade_in, R.anim.abc_fade_out);

		ActionBar actionBar = getSupportActionBar();
		if (actionBar != null)
		{
			actionBar.setHomeButtonEnabled(true);
			actionBar.setDisplayHomeAsUpEnabled(true);
			actionBar.setDisplayShowTitleEnabled(false);
		}

		mList.setHasFixedSize(true);

		LinearLayoutManager mLayoutManager = new LinearLayoutManager(this);
		mList.setLayoutManager(mLayoutManager);

		mAdapter = new LocationAdapter(this);
		mAdapter.setOnItemListener((location, position) ->
		{
			Intent result = new Intent();
			result.putExtra(SELECTED_LOCATION_EXTRA_NAME, location);
			setResult(RESULT_OK, result);
			finish();
		});

		mList.setAdapter(mAdapter);

		mList.requestFocusFromTouch();
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		getMenuInflater().inflate(R.menu.search_location_menu, menu);
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case android.R.id.home:
				onBackPressed();
				return true;
			default:
				return super.onOptionsItemSelected(item);
		}
	}

	@Override
	protected void onPause()
	{
		super.onPause();

		closeCurrentRequest();

		hideSoftKeyboard();
	}

	@Override
	public boolean onPrepareOptionsMenu(Menu menu)
	{
		MenuItem searchItem = menu.findItem(R.id.action_search);

		SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);

		SearchView searchView = (SearchView) searchItem.getActionView();
		searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
		searchView.setSubmitButtonEnabled(false);
		searchView.setOnQueryTextListener(this);
		searchView.setQueryHint(getString(R.string.search));
		this.mSearchView = searchView;

		mToolbarManager.onPrepareMenu();
		return super.onPrepareOptionsMenu(menu);
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
		return true;
	}

	@Override
	protected void onResume()
	{
		super.onResume();

		if (mSearchView != null)
		{
			String query = mSearchView.getQuery().toString();
			if (!query.equals(mShowResultFor))
			{
				newSearch(query);
			}
		}
		else
		{
			newSearch("");
		}
	}

	/**
	 * останавливает текущий запрос
	 */
	private void closeCurrentRequest()
	{
		if (mLastRequest != null)
		{
			Log.d(TAG, "Close search request for:" + mWaitResultFor);

			mLastRequest.cancel();
			mLastRequest = null;
			mWaitResultFor = null;
		}
	}

	private void executePendingSearch(@NonNull String search)
	{
		if (!isCurrentSearch(search))
		{
			Log.d(TAG, "executePendingSearch Search request for:\"" + search + "\" does not need");
			return;
		}

		Log.d(TAG, "executePendingSearch Execute request for:\"" + search + "\"");

		progressView.start();

		mLastRequest = RequestFactory.findLocations(search, null, getCountryId());
		mLastRequest.setRetryPolicy(mDefaultRetryPolicy);
		getSpiceManager().execute(mLastRequest, search, DEFAULT_SEARCH_CACHE_EXPIRY_DURATION_MS, new RequestListener<LocationsResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				mLastRequest = null;

				failureSearch(search, spiceException);
			}

			@Override
			public void onRequestSuccess(LocationsResponse locationsResponse)
			{
				mLastRequest = null;

				handleResponse(search, locationsResponse);
			}
		});
	}

	private void failureSearch(@NonNull String search, SpiceException spiceException)
	{
		if (isCurrentSearch(search))
		{
			Log.d(TAG, "failureSearch Search request for:\"" + search + "\" failure", spiceException);

			newSearch(search);
		}
		else
		{
			Log.d(TAG, "failureSearch Search request for:\"" + search + "\" failure and does not need", spiceException);
		}
	}

	private Integer getCountryId()
	{
		int value = getIntent().getIntExtra(COUNTRY_ID_EXTRA_NAME, Integer.MIN_VALUE);
		return value != Integer.MIN_VALUE ? value : null;
	}

	private void handleResponse(@NonNull String search, LocationsResponse locationsResponse)
	{
		if (isCurrentSearch(search))
		{
			if (locationsResponse.getCode() == ResponseStatus.Ok)
			{
				List<Location> result = Stream.of(locationsResponse.getLocations())
						.map(Location::fromDto)
						.collect(Collectors.toList());

				handleSearchResult(search, result);
			}
			else
			{
				String message = locationsResponse.getMessage();
				if (message != null)
					showToast(message);

				mWaitResultFor = null;
				Log.d(TAG, "Bad search response for:\"" + search + "\". Code=" + locationsResponse.getCode() + " Message=" + (message != null ? message : "null"));
			}
		}
		else
		{
			Log.d(TAG, "handleResponse Search result for:\"" + search + "\" does not need");
		}
	}

	private void handleSearchResult(@NonNull String search, @NonNull List<Location> locations)
	{
		if (isCurrentSearch(search))
		{
			progressView.stop();

			mWaitResultFor = null;
			mShowResultFor = search;

			mAdapter.clear();
			mAdapter.addAll(locations);

			Log.d(TAG, "handleSearchResult Handle search result for:\"" + search + "\"");
		}
		else
		{
			Log.d(TAG, "handleSearchResult Search result for:\"" + search + "\" does not need");
		}
	}

	private boolean isCurrentSearch(@NonNull String search)
	{
		return mWaitResultFor != null && mWaitResultFor.equals(search);
	}

	private void newSearch(@NonNull String search)
	{
		closeCurrentRequest();

		mWaitResultFor = search;

		if (!mAdapter.isEmpty())
			mAdapter.clear();

		long start = System.currentTimeMillis();
		getSpiceManager().getFromCache(LocationsResponse.class, search, DEFAULT_SEARCH_CACHE_EXPIRY_DURATION_MS, new RequestListener<LocationsResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				long delay = DEFAULT_SEARCH_DELAY_MS - System.currentTimeMillis() + start;
				if (delay > 50)
					mHandler.postDelayed(() -> executePendingSearch(search), delay);
				else
					executePendingSearch(search);
			}

			@Override
			public void onRequestSuccess(LocationsResponse locationsResponse)
			{
				long time = System.currentTimeMillis() - start;

				Log.d(TAG, "newSearch check cache time:" + time + " ms");

				if (locationsResponse != null)
				{
					handleResponse(search, locationsResponse);
					Log.d(TAG, "newSearch get from cache");
				}
				else
				{
					long delay = DEFAULT_SEARCH_DELAY_MS - time;
					if (delay > 50)
						mHandler.postDelayed(() -> executePendingSearch(search), delay);
					else
						executePendingSearch(search);
				}
			}
		});
	}
}
