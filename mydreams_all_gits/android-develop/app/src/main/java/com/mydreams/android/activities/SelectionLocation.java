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
import com.mydreams.android.adapters.CountryAdapter;
import com.mydreams.android.database.CountryHelper;
import com.mydreams.android.manager.CountryManager;
import com.mydreams.android.models.Country;
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
public class SelectionLocation extends BaseActivity {

    @Bind(R.id.toolbar)                     Toolbar toolbar;
    @Bind(R.id.btn_clear_dreams_search)     ImageButton clearCountrySearch;
    @Bind(R.id.view_dreams_search)          LinearLayout viewCountrySearch;
    @Bind(R.id.view_dreams_search_default)  LinearLayout viewCountrySearchDefault;
    @Bind(R.id.dreams_search)               EditText countrySearch;
    @Bind(R.id.country_list)                ListView countryListView;
    @Bind(R.id.close_field_search)          TextView closeFieldSearch;
    @Bind(R.id.title_dreams_search)         TextView titleCountrySearch;

    private Cancelable searchRequest;
    private List<Country> countryList;
    private CountryAdapter countryAdapter;
    private InputMethodManager inputMethodManager;
    private String prefix;

    @Inject
    CountryManager countryManager;
    @Inject
    CountryHelper countryHelper;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selection_location_filter_dreamer_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
        hideKeyboardPressedEnter(countrySearch);
        setCountrySearchTitle();

        if (!needLoading()) {
            loadCountryList();
        }
    }

    private void setCountrySearchTitle() {
        titleCountrySearch.setText(getResources().getString(R.string.dreamers_filter_title_country_search));
    }

    private boolean needLoading() {
        if (countryList != null && !countryList.isEmpty()) {
            return true;
        }
        return false;
    }

    @OnTextChanged(R.id.dreams_search)
    public void changeSearchText(Editable s) {
        prefix = s.toString();
        if (s.length() > 0) {
            searchCountry(prefix);
        } else {
            loadCountryList();
        }
    }

    private void fillingCountryAdapter() {
        countryList = countryHelper.getCountryList();
        countryAdapter = new CountryAdapter(this, countryList, R.layout.country_item_filter_dreamer);
        countryListView.setAdapter(countryAdapter);
    }

    private void loadCountryList() {
        countryManager.loadCountryList();
        countryManager.setOnSaveCountryListener(countrySaveListener);
    }

    private void searchCountry(final String prefix) {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
        searchRequest = countryManager.searchCountry(prefix);
        countryManager.setOnSaveCountryListener(countrySaveListener);
    }

    private CountryManager.OnCountrySaveListener countrySaveListener = new CountryManager.OnCountrySaveListener() {
        @Override
        public void complete() {
            fillingCountryAdapter();
            searchRequest = null;
        }

        @Override
        public void error(String errMsg) {
            searchRequest = null;
        }
    };

    private void setTitleToolbar() {
        TextView titleToolbar = (TextView) toolbar.findViewById(R.id.title_toolbar);
        titleToolbar.setText(getResources().getString(R.string.title_select_country_top));
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
        countrySearch.setText("");
    }

    @OnClick(R.id.close_field_search)
    public void closeFieldSearchDreams() {
        countrySearch.requestFocus();
        if (countrySearch.getText().length() != 0) {
            countrySearch.setText("");
        }

        hideKeyboard();
        viewCountrySearch.setVisibility(View.GONE);
        viewCountrySearchDefault.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.view_dreams_search_default)
    public void onClickShowSearchDreams() {
        countrySearch.requestFocus();
        showKeyboard(countrySearch);
        viewCountrySearchDefault.setVisibility(View.GONE);
        viewCountrySearch.setVisibility(View.VISIBLE);
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

    @OnItemClick(R.id.country_list)
    public void onItemClick(int position) {
        Intent intent = new Intent(Config.IF_GET_COUNTRY_ID);
        Country country = (Country) countryListView.getAdapter().getItem(position);
        intent.putExtra(Config.BUNDLE_COUNTRY_ID, (int) country.getId());
        intent.putExtra(Config.BUNDLE_COUNTRY, country.getNameCountry());

        sendBroadcast(intent);
        hideKeyboard();
        onBackPressed();
    }
}
