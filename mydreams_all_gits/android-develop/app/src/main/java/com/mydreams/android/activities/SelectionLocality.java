package com.mydreams.android.activities;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.adapters.CityAdapter;
import com.mydreams.android.database.CityHelper;
import com.mydreams.android.manager.CityManager;
import com.mydreams.android.models.City;
import com.mydreams.android.net.callers.Cancelable;

import java.util.List;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnItemClick;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 6/2/16.
 */
public class SelectionLocality extends BaseActivity {

    @Bind(R.id.toolbar)                     Toolbar toolbar;
    @Bind(R.id.btn_clear_dreams_search)     ImageButton clearCitySearch;
    @Bind(R.id.view_dreams_search)          LinearLayout viewCitySearch;
    @Bind(R.id.view_dreams_search_default)  LinearLayout viewCitySearchDefault;
    @Bind(R.id.dreams_search)               EditText citySearch;
    @Bind(R.id.locality_list)               ListView cityListView;
    @Bind(R.id.close_field_search)          TextView closeFieldSearch;
    @Bind(R.id.title_dreams_search)         TextView titleCitySearch;

    private Cancelable searchRequest;
    private List<City> cityList;
    private CityAdapter cityAdapter;
    private InputMethodManager inputMethodManager;
    private String prefix;
    private int countryId;

    @Inject
    CityManager cityManager;
    @Inject
    CityHelper cityHelper;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selection_locality_filter_dreamer_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
        Intent intent = getIntent();
        countryId = intent.getIntExtra(Config.BUNDLE_COUNTRY_ID, 0);
        hideKeyboardPressedEnter(citySearch);
        setCitySearchTitle();

        if (!needLoading()) {
            loadCityList();
        }
    }

    private void setCitySearchTitle() {
        titleCitySearch.setText(getResources().getString(R.string.dreamers_filter_title_locality_search));
    }

    private boolean needLoading() {
        if (cityList != null && !cityList.isEmpty()) {
            return true;
        }
        return false;
    }

    @OnTextChanged(R.id.dreams_search)
    public void changeSearchText(Editable s) {
        prefix = s.toString();
        if (s.length() > 0) {
            searchCity(prefix);
        } else {
            loadCityList();
        }
    }

    private void fillingCityAdapter() {
        cityList = cityHelper.getCityList();
        cityAdapter = new CityAdapter(this, cityList, R.layout.locality_item_filter_dreamer);
        cityListView.setAdapter(cityAdapter);
    }

    private void loadCityList() {
        cityManager.loadCityList(countryId);
        cityManager.setOnSaveCityListener(saveCityListener);
    }

    private void searchCity(final String prefix) {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
        searchRequest = cityManager.searchCity(countryId, prefix);
        cityManager.setOnSaveCityListener(saveCityListener);
    }

    private CityManager.OnSaveCityListener saveCityListener = new CityManager.OnSaveCityListener() {
        @Override
        public void complete() {
            fillingCityAdapter();
            searchRequest = null;
        }

        @Override
        public void error(String errMsg) {
            searchRequest = null;
        }
    };

    private void setTitleToolbar() {
        TextView titleToolbar = (TextView) toolbar.findViewById(R.id.title_toolbar);
        titleToolbar.setText(getResources().getString(R.string.title_top_head_select_locality));
    }

    @Override
    protected void onResume() {
        setTitleToolbar();
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        super.onResume();
    }

    @OnClick(R.id.btn_clear_dreams_search)
    public void clearFieldSearch() {
        citySearch.setText("");
    }

    @OnClick(R.id.close_field_search)
    public void closeFieldSearchDreams() {
        citySearch.requestFocus();
        if (citySearch.getText().length() != 0) {
            citySearch.setText("");
        }

        hideKeyboard();
        viewCitySearch.setVisibility(View.GONE);
        viewCitySearchDefault.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.view_dreams_search_default)
    public void onClickShowSearchDreams() {
        citySearch.requestFocus();
        showKeyboard(citySearch);
        viewCitySearchDefault.setVisibility(View.GONE);
        viewCitySearch.setVisibility(View.VISIBLE);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    @OnItemClick(R.id.locality_list)
    public void onItemClick(int position) {
        Intent intent = new Intent(Config.IF_GET_CITY_ID);
        City city = (City) cityListView.getAdapter().getItem(position);
        intent.putExtra(Config.BUNDLE_CITY_ID, city.getCityId());
        intent.putExtra(Config.BUNDLE_CITY, city.getCityName());

        sendBroadcast(intent);
        hideKeyboard();
        onBackPressed();
    }

}
