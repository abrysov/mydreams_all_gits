package com.mydreams.android.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.FragmentManager;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.adapters.CityAdapter;
import com.mydreams.android.components.SelectionLocationType;
import com.mydreams.android.database.CityHelper;
import com.mydreams.android.manager.CityManager;
import com.mydreams.android.models.City;
import com.mydreams.android.net.callers.Cancelable;

import java.util.List;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnItemClick;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 24.03.16.
 */
public class SelectionLocalityFragment extends BaseFragment {

    @Bind(R.id.btn_back)                   ImageButton btnBack;
    @Bind(R.id.locality_list)              ListView localityListView;
    @Bind(R.id.search)                     EditText searchLocality;
    @Bind(R.id.btn_clear_search)           ImageButton btnClear;
    @Bind(R.id.txt_top_head_location)      TextView txtTopHead;
    @Bind(R.id.offer_locality_layout)      RelativeLayout offerLocalityLayout;
    @Bind(R.id.custom_view_region)         View customViewRegion;
    @Bind(R.id.custom_view_district)       View customViewDistrict;
    @Bind(R.id.custom_view_search_country) View customViewSearchCountry;
    @Bind(R.id.edit_region)                EditText regionEdit;
    @Bind(R.id.edit_district)              EditText districtEdit;
    @Bind(R.id.btn_offer_locality)         Button btnOfferLocality;
    @Bind(R.id.btn_offer)                  Button btnOffer;
    @Bind(R.id.offered_locality_layout)    RelativeLayout offeredLocalityLayout;
    @Bind(R.id.locality)                   TextView locality;
    @Bind(R.id.region_name)                TextView regionName;
    @Bind(R.id.district_name)              TextView districtName;
    @Bind(R.id.btn_onward)                 Button btnOnward;
    @Bind(R.id.img_divider_region)         ImageView dividerRegion;
    @Bind(R.id.img_divider_district)       ImageView dividerDistrict;
    @Bind(R.id.progress_bar)               ProgressBar progressBar;

    private SelectionLocationType selectionLocationType;
    private Bundle mBundle;
    private List<City> cityList;
    private CityAdapter cityAdapter;

    private int countryId;
    private int cityId;
    private String cityName;
    private String prefix;

    @Inject
    CityManager cityManager;
    @Inject
    CityHelper cityHelper;

    private Cancelable searchRequest;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.selection_locality_layout, null);

        setRetainInstance(true);
        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        hideKeyboardPressedEnter(searchLocality);

        if (savedInstanceState == null)
            mBundle = (Bundle) getArguments().clone();
        else
            mBundle = (Bundle) savedInstanceState.clone();

        setTextTopHead();
        setSelectionType();

        countryId = mBundle.getInt(Config.BUNDLE_COUNTRY_ID);

        loadCityList(countryId);

        return view;
    }

    private void setTextTopHead() {
        txtTopHead.setText(getResources().getString(R.string.title_top_head_select_locality));
    }

    private void setSelectionType() {
        selectionLocationType = SelectionLocationType.SELECTION_LOCALITY;
    }

    @OnFocusChange({R.id.edit_region, R.id.edit_district})
    public void setFocusChangeListener(View view, boolean hasFocus) {
        if (regionEdit.hasFocus()) {
            dividerRegion.setBackgroundResource(R.mipmap.img_divider_selected);
        } else {
            dividerRegion.setBackgroundResource(R.mipmap.img_divider);
        }

        if (districtEdit.hasFocus()) {
            dividerDistrict.setBackgroundResource(R.mipmap.img_divider_selected);
        } else {
            dividerDistrict.setBackgroundResource(R.mipmap.img_divider);
        }
    }

    public void onBackPressed() {
        switch (selectionLocationType) {
            case OFFER_LOCALITY:
                selectionLocationType = SelectionLocationType.SELECTION_LOCALITY;
                hideOrShowSelectionLocality(View.VISIBLE);
                hideOrShowOfferLocation(View.GONE);
                break;
            case SELECTION_LOCALITY:
                getFragmentManager().popBackStack();
                break;
            case OFFERED_LOCALITY:
                onBackToRegThirdFragment();
                break;
        }
    }

    private void keyOnBackListener() {
        getView().setFocusableInTouchMode(true);
        getView().requestFocus();
        getView().setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                if (event.getAction() == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_BACK) {
                    onBackPressed();
                    return true;
                }

                return false;
            }
        });
    }

    @Override
    public void onResume() {
        super.onResume();
        keyOnBackListener();
    }

    @OnClick(R.id.btn_back)
    public void onClickBack() {
        hideKeyboard();
        onBackPressed();
    }

    @OnClick(R.id.btn_clear_search)
    public void onClickClearSearch() {
        searchLocality.setText("");
    }

    @OnClick(R.id.btn_offer_locality)
    public void onClickSetTypeOfferLocality() {
        selectionLocationType = SelectionLocationType.OFFER_LOCALITY;
        hideOrShowOfferLocation(View.VISIBLE);
        hideOrShowSelectionLocality(View.GONE);
    }

    @OnClick(R.id.custom_view_region)
    public void onClickRequestFocusEditRegion() {
        regionEdit.requestFocus();
        showKeyboard(regionEdit);
    }

    @OnClick(R.id.custom_view_district)
    public void onClickRequestFocusEditDistrict() {
        districtEdit.requestFocus();
        showKeyboard(districtEdit);
    }

    @OnClick(R.id.btn_onward)
    public void onClickButtonOnward() {
        onBackToRegThirdFragment();
    }

    @OnClick(R.id.btn_offer)
    public void onClickOfferLocality() {
        if (!searchLocality.getText().toString().isEmpty()) {
            selectionLocationType = SelectionLocationType.OFFERED_LOCALITY;
            sendToAddCity();
        }
    }

    @OnTextChanged(R.id.search)
    public void changeSearchText(CharSequence s, int start, int before, int count) {
        if (selectionLocationType != SelectionLocationType.OFFER_LOCALITY) {
            prefix = s.toString();
            if (s.length() > 0) {
                searchCity(countryId, prefix);
            } else {
                loadCityList(countryId);
            }
        }
    }

    private void setTopHeaderText() {
        switch (selectionLocationType) {
            case OFFER_LOCALITY:
                txtTopHead.setText(getResources().getString(R.string.title_top_head_offer_locality));
                break;
            case SELECTION_LOCALITY:
                txtTopHead.setText(getResources().getString(R.string.title_top_head_select_locality));
                break;
            case OFFERED_LOCALITY:
                txtTopHead.setText(getResources().getString(R.string.title_top_head_offer_locality));
                break;
        }
    }

    private void sendIntentForBroadcast(int cityId, String cityName) {
        Intent intent = new Intent(Config.IF_USER_COUNTRY_CHANGED);
        intent.putExtra(Config.INTENT_USER_COUNTRY, mBundle.getString(Config.BUNDLE_COUNTRY));
        intent.putExtra(Config.INTENT_USER_COUNTRY_ID, countryId);
        intent.putExtra(Config.INTENT_USER_CITY, cityName);
        intent.putExtra(Config.INTENT_USER_CITY_ID, cityId);
        getActivity().sendBroadcast(intent);
    }

    private void onBackToRegThirdFragment() {
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.popBackStack(fragmentManager.getBackStackEntryAt(fragmentManager.getBackStackEntryCount() - 2).getId(), FragmentManager.POP_BACK_STACK_INCLUSIVE);
        sendIntentForBroadcast(cityId, cityName);
    }

    private void hideOrShowSelectionLocality(int visible) {
        localityListView.setVisibility(visible);
        btnOfferLocality.setVisibility(visible);
        setTopHeaderText();
    }

    private void hideOrShowOfferLocation(int visible) {
        offerLocalityLayout.setVisibility(visible);
        setTopHeaderText();
    }

    private void hideOrShowOfferedLocation(int visible) {
        offeredLocalityLayout.setVisibility(visible);
        hideOrShowOfferLocation(View.GONE);
        locality.setText(searchLocality.getText().toString());
        regionName.setText(regionEdit.getText().toString());
        districtName.setText(districtEdit.getText().toString());
        customViewSearchCountry.setVisibility(View.GONE);
        setTopHeaderText();
    }

    private void hideOrShowHeaderTop(int visible) {
        btnBack.setVisibility(visible);
        btnClear.setVisibility(visible);
        searchLocality.setVisibility(visible);
    }

    private void loadCityList(final int countryId) {
        progressBar.setVisibility(View.VISIBLE);
        searchRequest = cityManager.loadCityList(countryId);
        cityManager.setOnSaveCityListener(saveCityListener);
    }

    private void searchCity(final int countryId, final String prefix) {
        cancelRequest();
        searchRequest = cityManager.searchCity(countryId, prefix);
        cityManager.setOnSaveCityListener(saveCityListener);
    }

    private void sendToAddCity() {
        final String cityName = searchLocality.getText().toString().trim();
        final String regionName = regionEdit.getText().toString().trim();
        final String districtName = districtEdit.getText().toString().trim();

        cityManager.sendToAddCity(countryId, cityName, regionName, districtName);
        cityManager.setOnAddCityListener(new CityManager.OnAddCityListener() {
            @Override
            public void complete() {
                setCityNameAndId();
            }

            @Override
            public void error(String errMsg) {

            }
        });
    }

    private void setCityNameAndId() {
        City city = cityHelper.getAddedCity();
        cityId = city.getCityId();
        cityName = city.getCityName();

        hideOrShowOfferedLocation(View.VISIBLE);
        hideOrShowHeaderTop(View.GONE);
    }

    private CityManager.OnSaveCityListener saveCityListener = new CityManager.OnSaveCityListener() {
        @Override
        public void complete() {
            fillingCityAdapter();
            searchRequest = null;
            progressBar.setVisibility(View.INVISIBLE);
        }

        @Override
        public void error(String errMsg) {
            searchRequest = null;
            showNotificationError(errMsg);
        }
    };

    private void fillingCityAdapter() {
        cityList = cityHelper.getCityList();
        cityAdapter = new CityAdapter(getActivity(), cityList, R.layout.locality_item);
        localityListView.setAdapter(cityAdapter);
    }

    @OnItemClick(R.id.locality_list)
    public void onItemClick(int position) {
        City city = (City) localityListView.getAdapter().getItem(position);
        cityId = city.getCityId();
        cityName = city.getCityName();
        onBackToRegThirdFragment();
    }

    private void cancelRequest() {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
    }

    @Override
    public void onDestroy() {
        ButterKnife.unbind(this);
        cancelRequest();
        super.onDestroy();
    }
}
