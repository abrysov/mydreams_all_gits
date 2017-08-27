package com.mydreams.android.fragments;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.Toolbar;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.activities.SearchLocationActivity;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.models.Country;
import com.mydreams.android.models.FilterUser;
import com.mydreams.android.models.Location;
import com.mydreams.android.service.models.AgeRange;
import com.mydreams.android.service.models.SexType;
import com.mydreams.android.utils.ActivityUtils;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.Switch;

import org.parceler.Parcels;

import java.util.UUID;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class FilterUserFragment extends BaseFragment
{
	public static final String REQUEST_UUID_EXTRA_NAME = "REQUEST_UUID_EXTRA_NAME";
	private static final String FILTER_EXTRA_NAME = "FILTER_EXTRA_NAME";
	private static final String NEW_FILTER_EXTRA_NAME = "NEW_FILTER_EXTRA_NAME";
	private static final int GET_CITY_REQUEST_ID = 1;
	private static final String COUNTRY_REQUEST_ID_EXTRA_NAME = "COUNTRY_REQUEST_ID_EXTRA_NAME";

	@Bind(R.id.spinnerSex)
	com.rey.material.widget.Spinner spinnerSex;
	@Bind(R.id.spinnerAge)
	com.rey.material.widget.Spinner spinnerAge;
	@Bind(R.id.countryWrapper)
	com.rey.material.widget.EditText countryWrapper;
	@Bind(R.id.cityWrapper)
	com.rey.material.widget.EditText cityWrapper;
	@Bind(R.id.swPopular)
	com.rey.material.widget.Switch swPopular;
	@Bind(R.id.swNew)
	com.rey.material.widget.Switch swNew;
	@Bind(R.id.swOnline)
	com.rey.material.widget.Switch swOnline;
	@Bind(R.id.swVip)
	com.rey.material.widget.Switch swVip;
	@Bind(R.id.swAll)
	com.rey.material.widget.Switch swAll;

	@Bind(R.id.lblPopular)
	android.widget.TextView lblPopular;
	@Bind(R.id.lblNew)
	android.widget.TextView lblNew;
	@Bind(R.id.lblOnline)
	android.widget.TextView lblOnline;
	@Bind(R.id.lblVip)
	android.widget.TextView lblVip;
	@Bind(R.id.lblAll)
	android.widget.TextView lblAll;
	@Bind(R.id.btnCityCancel)
	View btnCityCancel;
	@Bind(R.id.btnCountryCancel)
	View btnCountryCancel;
	private FilterUser mFilter;
	private ToolbarManager mToolbarManager;
	private boolean changeSwAllSilent;
	private Location cityLocation;
	private Country country;
	private UUID mCountryRequestUUID;

	public static FilterUser extractResult(Bundle data)
	{
		return Parcels.unwrap(data.getParcelable(NEW_FILTER_EXTRA_NAME));
	}

	public static Fragment getInstance(@NonNull UUID requestUUID, @Nullable FilterUser filter)
	{
		Bundle args = new Bundle();
		args.putParcelable(FILTER_EXTRA_NAME, Parcels.wrap(filter));
		args.putSerializable(REQUEST_UUID_EXTRA_NAME, requestUUID);

		Fragment result = new FilterUserFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onActivityResult(final int requestCode, final int resultCode, final Intent data)
	{
		if (requestCode == GET_CITY_REQUEST_ID && resultCode == Activity.RESULT_OK && data != null)
		{
			setCity(SearchLocationActivity.extractResult(data));
		}
		else
		{
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.filter_user_menu, menu);
		super.onCreateOptionsMenu(menu, inflater);
	}

	@SuppressWarnings("deprecation")
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		setHasOptionsMenu(true);
		setMenuVisibility(true);

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.light_green_dark);

		ContextThemeWrapper themeWrapper = new ContextThemeWrapper(inflater.getContext(), R.style.LightGreenTheme);
		inflater = LayoutInflater.from(themeWrapper);
		View result = inflater.inflate(R.layout.fragment_filter_user, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_filter_user_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		if (savedInstanceState != null && savedInstanceState.containsKey(FILTER_EXTRA_NAME))
		{
			mFilter = savedInstanceState.getParcelable(FILTER_EXTRA_NAME);
		}

		if (mFilter == null)
		{
			mFilter = Parcels.unwrap(getArguments().getParcelable(FILTER_EXTRA_NAME));
		}

		final SexItem[] sexs = new SexItem[]{
				new SexItem(null, getString(R.string.sex)),
				new SexItem(SexType.Male, getString(R.string.sex_male)),
				new SexItem(SexType.Female, getString(R.string.sex_female))
		};
		ArrayAdapter<SexItem> sexAdapter = new ArrayAdapter<>(getActivity(), R.layout.row_spn, sexs);
		sexAdapter.setDropDownViewResource(R.layout.row_spn_dropdown);
		spinnerSex.setAdapter(sexAdapter);

		if (mFilter.getSexType() != null)
		{
			for (int i = 0; i < sexs.length; i++)
			{
				if (sexs[i].getSexType() == mFilter.getSexType())
				{
					spinnerSex.setSelection(i);
					break;
				}
			}
		}

		final AgeItem[] ages = new AgeItem[]{
				new AgeItem(null, getString(R.string.age)),
				new AgeItem(AgeRange._1, AgeRange._1.getRange()),
				new AgeItem(AgeRange._2, AgeRange._2.getRange()),
				new AgeItem(AgeRange._3, AgeRange._3.getRange()),
				new AgeItem(AgeRange._4, AgeRange._4.getRange()),
				new AgeItem(AgeRange._5, AgeRange._5.getRange()),
		};
		ArrayAdapter<AgeItem> ageAdapter = new ArrayAdapter<>(getActivity(), R.layout.row_spn, ages);
		ageAdapter.setDropDownViewResource(R.layout.row_spn_dropdown);
		spinnerAge.setAdapter(ageAdapter);

		if (mFilter.getAgeRange() != null)
		{
			for (int i = 0; i < ages.length; i++)
			{
				if (ages[i].getAgeRange() == mFilter.getAgeRange())
				{
					spinnerAge.setSelection(i);
					break;
				}
			}
		}

		swPopular.setTag(lblPopular);
		swNew.setTag(lblNew);
		swOnline.setTag(lblOnline);
		swVip.setTag(lblVip);
		swAll.setTag(lblAll);

		swPopular.setOnCheckedChangeListener(this::checkedChangeListener);
		swNew.setOnCheckedChangeListener(this::checkedChangeListener);
		swOnline.setOnCheckedChangeListener(this::checkedChangeListener);
		swVip.setOnCheckedChangeListener(this::checkedChangeListener);

		lblPopular.setTextColor(getResources().getColor(R.color.textColorHint));
		lblNew.setTextColor(getResources().getColor(R.color.textColorHint));
		lblOnline.setTextColor(getResources().getColor(R.color.textColorHint));
		lblVip.setTextColor(getResources().getColor(R.color.textColorHint));
		lblAll.setTextColor(getResources().getColor(R.color.textColorHint));

		swPopular.setChecked(mFilter.getPopular() != null && mFilter.getPopular());
		swNew.setChecked(mFilter.getNewUsers() != null && mFilter.getNewUsers());
		swOnline.setChecked(mFilter.getOnline() != null && mFilter.getOnline());
		swVip.setChecked(mFilter.getVip() != null && mFilter.getVip());

		swAll.setChecked(swPopular.isChecked() && swNew.isChecked() && swOnline.isChecked() && swVip.isChecked());
		swAll.setOnCheckedChangeListener((view, checked) -> {
			if (!changeSwAllSilent)
			{
				swPopular.setChecked(checked);
				swNew.setChecked(checked);
				swOnline.setChecked(checked);
				swVip.setChecked(checked);
			}
		});

		if (savedInstanceState != null && savedInstanceState.containsKey(COUNTRY_REQUEST_ID_EXTRA_NAME))
		{
			mCountryRequestUUID = (UUID) savedInstanceState.getSerializable(COUNTRY_REQUEST_ID_EXTRA_NAME);
		}

		setCountry(mFilter.getCountry());
		setCity(mFilter.getCity());

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

		mToolbarManager.notifyNavigationStateChanged();
		mToolbarManager.notifyNavigationStateInvalidated();

		if (mCountryRequestUUID != null)
		{
			Bundle data = getMainActivity().getFragmentResult(mCountryRequestUUID);
			mCountryRequestUUID = null;

			if (data != null)
			{
				setCountry(CountriesFragment.extractResult(data));
			}
		}
	}

	@Override
	public void onSaveInstanceState(final Bundle outState)
	{
		super.onSaveInstanceState(outState);

		outState.putParcelable(FILTER_EXTRA_NAME, Parcels.wrap(mFilter));
		outState.putSerializable(COUNTRY_REQUEST_ID_EXTRA_NAME, mCountryRequestUUID);
	}

	@OnClick(R.id.btnApply)
	void clickApply()
	{
		final Bundle data = new Bundle();
		data.putParcelable(NEW_FILTER_EXTRA_NAME, Parcels.wrap(makeFilter()));

		getMainActivity().setFragmentResult(getRequestUUID(), data);
		getMainActivity().popFragment();
	}

	@OnClick(R.id.btnCancel)
	void clickCancel()
	{
		getMainActivity().popFragment();
	}

	@OnClick(R.id.cityView)
	void clickCity()
	{
		Integer countryId = getCountryId();
		Intent intent = SearchLocationActivity.getLaunchIntent(getActivity(), countryId);
		startActivityForResult(intent, GET_CITY_REQUEST_ID);
	}

	@OnClick(R.id.btnCityCancel)
	void clickCityCancel()
	{
		setCity(null);
	}

	@OnClick(R.id.countryView)
	void clickCountry()
	{
		mCountryRequestUUID = UUID.randomUUID();

		Fragment fragment = CountriesFragment.getInstance(mCountryRequestUUID);
		getMainActivity().putFragmentWithBackStack(fragment);
	}

	@OnClick(R.id.btnCountryCancel)
	void clickCountryCancel()
	{
		setCountry(null);
	}

	private void checkedChangeListener(final Switch view, final boolean checked)
	{
		changeSwAllSilent = true;

		android.widget.TextView label = (android.widget.TextView) view.getTag();
		if (checked)
		{
			label.setTextColor(0xFF000000);
			if (swPopular.isChecked() && swNew.isChecked() && swOnline.isChecked() && swVip.isChecked())
			{
				swAll.setChecked(true);
				lblAll.setTextColor(0xFF000000);
			}
		}
		else
		{
			label.setTextColor(getResources().getColor(R.color.textColorHint));
			lblAll.setTextColor(getResources().getColor(R.color.textColorHint));
			swAll.setChecked(false);
		}

		changeSwAllSilent = false;
	}

	private Integer getCityId()
	{
		return cityLocation != null ? cityLocation.getId() : null;
	}

	private Integer getCountryId()
	{
		return country != null ? country.getId() : null;
	}

	private UUID getRequestUUID()
	{
		return (UUID) getArguments().getSerializable(REQUEST_UUID_EXTRA_NAME);
	}

	@Nullable
	private AgeRange getSelectedAge()
	{
		return ((AgeItem) spinnerAge.getSelectedItem()).getAgeRange();
	}

	private SexType getSelectedSex()
	{
		return ((SexItem) spinnerSex.getSelectedItem()).getSexType();
	}

	private FilterUser makeFilter()
	{
		FilterUser result = new FilterUser();

		result.setSexType(getSelectedSex());
		result.setAgeRange(getSelectedAge());
		result.setCity(cityLocation);
		result.setCountry(country);
		result.setNewUsers(swNew.isChecked() ? true : null);
		result.setOnline(swOnline.isChecked() ? true : null);
		result.setPopular(swPopular.isChecked() ? true : null);
		result.setVip(swVip.isChecked() ? true : null);

		return result;
	}

	private void setCity(final Location location)
	{
		cityLocation = location;
		if (location != null)
		{
			cityWrapper.setText(location.getName());
			btnCityCancel.setVisibility(View.VISIBLE);
		}
		else
		{
			cityWrapper.setText("");
			btnCityCancel.setVisibility(View.GONE);
		}
	}

	private void setCountry(@Nullable final Country country)
	{
		if (this.country != null && country != null)
		{
			if (this.country.getId() != country.getId())
			{
				setCity(null);
			}
		}

		this.country = country;
		if (country != null)
		{
			countryWrapper.setText(country.getName());
			btnCountryCancel.setVisibility(View.VISIBLE);
		}
		else
		{
			countryWrapper.setText("");
			btnCountryCancel.setVisibility(View.GONE);
		}
	}

	public static class SexItem
	{
		@Nullable
		private SexType mSexType;
		private String mName;

		public SexItem(@Nullable final SexType sexType, String name)
		{
			mSexType = sexType;
			mName = name;
		}

		@Override
		public String toString()
		{
			return mName;
		}

		@Nullable
		public SexType getSexType()
		{
			return mSexType;
		}
	}

	public static class AgeItem
	{
		@Nullable
		private AgeRange mAgeRange;
		private String mName;

		public AgeItem(@Nullable final AgeRange ageRange, String name)
		{
			mAgeRange = ageRange;
			mName = name;
		}

		@Override
		public String toString()
		{
			return mName;
		}

		@Nullable
		public AgeRange getAgeRange()
		{
			return mAgeRange;
		}
	}
}
