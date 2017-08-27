package com.mydreams.android.fragments;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.Fragment;
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
import com.mydreams.android.adapters.CountryAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.Country;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.CountriesResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;

import org.parceler.Parcels;

import java.util.List;
import java.util.UUID;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class CountriesFragment extends BaseFragment
{
	public static final String SELECTED_COUNTRY_EXTRA_NAME = "SELECTED_COUNTRY_EXTRA_NAME";
	public static final String REQUEST_UUID_EXTRA_NAME = "REQUEST_UUID_EXTRA_NAME";

	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.progressBar)
	com.rey.material.widget.ProgressView progressBar;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;

	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	private CountryAdapter mAdapter;

	public static Country extractResult(Bundle data)
	{
		return Parcels.unwrap(data.getParcelable(SELECTED_COUNTRY_EXTRA_NAME));
	}

	public static Fragment getInstance(UUID requestUUID)
	{
		final Bundle args = new Bundle();
		args.putSerializable(REQUEST_UUID_EXTRA_NAME, requestUUID);

		Fragment result = new CountriesFragment();
		result.setArguments(args);
		return result;
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

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		View result = inflater.inflate(R.layout.fragment_countries, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_countries_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		mAdapter = new CountryAdapter(getContext(), this::handleClickItem);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));

		refresh();
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
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		mToolbarManager.notifyNavigationStateChanged();
		mToolbarManager.notifyNavigationStateInvalidated();
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		showProgress();
		refresh();
	}

	private UUID getRequestUUID()
	{
		return (UUID) getArguments().getSerializable(REQUEST_UUID_EXTRA_NAME);
	}

	private void handleClickItem(Country item)
	{
		Bundle result = new Bundle();
		result.putParcelable(SELECTED_COUNTRY_EXTRA_NAME, Parcels.wrap(item));

		MainActivity mainActivity = getMainActivity();
		mainActivity.setFragmentResult(getRequestUUID(), result);
		mainActivity.popFragment();
	}

	private void handleError()
	{
		showRetry();
	}

	private void handleItems(@NonNull List<Country> countries)
	{
		showList();
		mAdapter.addAll(countries);
	}

	private void refresh()
	{
		showProgress();

		BaseSpiceRequest<CountriesResponse> request = RequestFactory.getCountries();
		getSpiceManager().execute(request, new RequestListener<CountriesResponse>()
		{
			@Override
			public void onRequestFailure(final SpiceException spiceException)
			{
				handleError();
			}

			@Override
			public void onRequestSuccess(final CountriesResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					handleItems(Stream.of(response.getCountries()).map(Country::new).collect(Collectors.toList()));
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						handleError();
					}
				}
			}
		});
	}

	private void showList()
	{
		mList.setVisibility(View.VISIBLE);
		mLayoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);
	}

	private void showProgress()
	{
		mList.setVisibility(View.GONE);
		mLayoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
	}

	private void showRetry()
	{
		mList.setVisibility(View.GONE);
		mLayoutRetry.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
	}
}
