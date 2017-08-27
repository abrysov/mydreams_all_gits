package com.mydreams.android.fragments;

import android.os.Bundle;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.ProgressBar;
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
 * Created by mikhail on 16.03.16.
 */

public class SelectionLocationFragment extends BaseFragment {

    @Bind(R.id.btn_back)                ImageButton btnBack;
    @Bind(R.id.search)                  EditText searchCountry;
    @Bind(R.id.btn_clear_search)        ImageButton btnClear;
    @Bind(R.id.country_list)            ListView countryListView;
    @Bind(R.id.txt_top_head_location)   TextView txtTopHead;
    @Bind(R.id.progress_bar)            ProgressBar progressBar;

    private List<Country> countryList;
    private CountryAdapter countryAdapter;
    private String prefix;

    @Inject
    CountryManager countryManager;
    @Inject
    CountryHelper countryHelper;

    private Cancelable searchRequest;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout. selection_country_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        hideKeyboardPressedEnter(searchCountry);

        setTextTopHead();

        if (!needLoading()) {
            loadCountryList();
        }

        return view;
    }

    private boolean needLoading() {
        if (countryList != null && !countryList.isEmpty()) {
            return true;
        }
        return false;
    }

    private void setTextTopHead() {
        txtTopHead.setText(getResources().getString(R.string.title_select_country_top));
    }

    @OnTextChanged(R.id.search)
    public void changeSearchText(Editable s) {
        prefix = s.toString();
        if (s.length() > 0) {
            searchCountry(prefix);
        } else {
            loadCountryList();
        }
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        getActivity().onBackPressed();
    }

    @OnClick(R.id.btn_clear_search)
    public void onClickClearSearch() {
        searchCountry.setText("");
    }

    private void fillingCountryAdapter() {
        countryList = countryHelper.getCountryList();
        countryAdapter = new CountryAdapter(getActivity(), countryList, R.layout.country_item);
        countryListView.setAdapter(countryAdapter);
    }

    private void loadCountryList() {
        progressBar.setVisibility(View.VISIBLE);
        countryManager.setOnSaveCountryListener(countrySaveListener);
        searchRequest = countryManager.loadCountryList();
    }

    private void searchCountry(final String prefix) {
        cancelRequest();
        countryManager.setOnSaveCountryListener(countrySaveListener);
        searchRequest = countryManager.searchCountry(prefix);
    }

    private CountryManager.OnCountrySaveListener countrySaveListener = new CountryManager.OnCountrySaveListener() {
        @Override
        public void complete() {
            fillingCountryAdapter();
            searchRequest = null;
            progressBar.setVisibility(View.INVISIBLE);
        }

        @Override
        public void error(String errMsg) {
            searchRequest = null;
            progressBar.setVisibility(View.INVISIBLE);
            showNotificationError(errMsg);
        }
    };

    @OnItemClick(R.id.country_list)
    public void onItemClick(int position) {
        Bundle bundle = new Bundle();
        Country country = (Country) countryListView.getAdapter().getItem(position);
        bundle.putInt(Config.BUNDLE_COUNTRY_ID, (int) country.getId());
        bundle.putString(Config.BUNDLE_COUNTRY, country.getNameCountry());

        hideKeyboard();
        needOpenFragment(Config.FTYPE_SELECTION_LOCALITY, bundle);
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
