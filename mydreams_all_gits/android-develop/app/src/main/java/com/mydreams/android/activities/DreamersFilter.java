package com.mydreams.android.activities;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.AppPreferences;
import com.mydreams.android.components.CustomTabHost;
import com.mydreams.android.components.DeclinationText;
import com.mydreams.android.database.DreamerHelper;
import com.mydreams.android.database.PaginationHelper;
import com.mydreams.android.manager.DreamersListManager;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Pagination;
import com.mydreams.android.net.callers.Cancelable;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamersFilter extends AppCompatActivity implements TabHost.OnTabChangeListener {

    @Bind(R.id.tab_dreams)            TabHost tabHost;
    @Bind(R.id.toolbar)               Toolbar toolbar;
    @Bind(R.id.view_selected_country) RelativeLayout viewSelectedCountry;
    @Bind(R.id.view_selected_city)    RelativeLayout viewSelectedCity;
    @Bind(R.id.age_from)              EditText fieldAgeFrom;
    @Bind(R.id.age_to)                EditText fieldAgeTo;
    @Bind(R.id.view_selected_all)     RelativeLayout viewSelectedAll;
    @Bind(R.id.view_selected_new)     RelativeLayout viewSelectedNew;
    @Bind(R.id.view_selected_popular) RelativeLayout viewSelectedPopular;
    @Bind(R.id.view_selected_vip)     RelativeLayout viewSelectedVip;
    @Bind(R.id.view_selected_online)  RelativeLayout viewSelectedOnline;
    @Bind(R.id.reset_filter)          TextView resetFilter;
    @Bind(R.id.btn_show_all_results)  Button showAllResults;
    @Bind(R.id.check_box_all)         ImageView checkboxAll;
    @Bind(R.id.check_box_new)         ImageView checkboxNew;
    @Bind(R.id.check_box_popular)     ImageView checkboxPopular;
    @Bind(R.id.check_box_vip)         ImageView checkboxVip;
    @Bind(R.id.check_box_online)      ImageView checkboxOnline;
    @Bind(R.id.name_country)          TextView nameCountry;
    @Bind(R.id.name_city)             TextView nameCity;

    private InputMethodManager inputMethodManager;
    private int countryId;
    private int cityId;
    private Map<String, Object> paramsRequest;
    private Cancelable searchRequest;
    private String textDreamerGender;
    private String dreamerGender;
    private long countResults;
    private CustomTabHost customTab;
    private String tagTab;
    private String textNewDreamers;
    private String textPopularDreamers;
    private String textOnlineDreamers;
    private String textVipDreamers;

    @Inject
    DreamersListManager dreamerManager;
    @Inject
    PaginationHelper paginationHelper;
    @Inject
    DreamerHelper dreamerHelper;
    @Inject
    SharedPreferences preferences;
    @Inject
    AppPreferences appPreferences;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dreamers_filter_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
        initTabs();
        initInputManager();
        checkboxAll.setVisibility(View.VISIBLE);
        tagTab = Config.TAG_TAB_ALL_DREAMERS;
        initMapParams();
        loadDreamersList();
        insertTheSavedStateFilter();
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
    }

    private void loadDreamersList() {
        cancelRequest();
        dreamerHelper.clearDreamersList();
        searchRequest = dreamerManager.loadDreamersList(paramsRequest);
        dreamerManager.setDreamerSaveListener(new DreamersListManager.OnDreamerSaveListener() {
            @Override
            public void complete() {
                Pagination pagination = paginationHelper.getPaginationData();
                countResults = pagination.getTotalCount();
                setCountResults(countResults);
            }

            @Override
            public void error(String errMsg) {

            }
        });
    }

    @OnTextChanged(R.id.age_from)
    public void changeFieldOfAgeDreamer(Editable s) {
        int ofAgeDreamer = 0;
        try {
            ofAgeDreamer = Integer.parseInt(s.toString());
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        if (s.length() > 0) {
            paramsRequest.put(Field.AGE_FROM, ofAgeDreamer);
        } else {
            paramsRequest.remove(Field.AGE_FROM);
        }

        loadDreamersList();
    }

    @OnTextChanged(R.id.age_to)
    public void changeFieldBeforeAgeDreamer(Editable s) {
        int beforeAgeDreamer = 0;
        try {
            beforeAgeDreamer = Integer.parseInt(s.toString());
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        if (s.length() > 0) {
            paramsRequest.put(Field.AGE_TO, beforeAgeDreamer);
        } else {
            paramsRequest.remove(Field.AGE_TO);
        }

        loadDreamersList();
    }

    private void setCountResults(long countResults) {
        DeclinationText declinationText = new DeclinationText(this);
        if (countResults > 0) {
            String text = getResources().getString(R.string.dreamers_filter_text_button_show_results, String.valueOf(countResults));
            showAllResults.setText(text + declinationText.getFormatText((int) countResults));
            showAllResults.setAlpha(1);
            showAllResults.setEnabled(true);
        } else {
            showAllResults.setEnabled(false);
            showAllResults.setAlpha(0.5f);
            showAllResults.setText(getResources().getString(R.string.dreamers_filter_text_button_no_results));
        }
    }

    private void initTabs() {
        customTab = new CustomTabHost();
        customTab.setTabHost(tabHost);
        customTab.setNewTab(Config.TAG_TAB_FEMALE_DREAMERS, getResources().getString(R.string.dreamers_filter_title_female), R.id.tabContent);
        customTab.setNewTab(Config.TAG_TAB_ALL_DREAMERS, getResources().getString(R.string.dreamers_filter_title_all), R.id.tabContent);
        customTab.setNewTab(Config.TAG_TAB_MALE_DREAMERS, getResources().getString(R.string.dreamers_filter_title_male), R.id.tabContent);
        customTab.setTabTextColor(getResources().getColorStateList(R.color.tab_indicator_selector_blue));
        customTab.setTabTextSize(14);
        customTab.setHeightTab();
        customTab.setBackgroundLeftTab(R.drawable.tab_left_selector);
        customTab.setBackgroundRight(R.drawable.tab_right_selector);
        customTab.setBackgroundCenterTab(R.drawable.tab_center_selector);
        customTab.setCurrentTab(1);
        customTab.setOnTabChangedListener(this);
    }

    private void setTitleToolbar() {
        TextView titleToolbar = (TextView) toolbar.findViewById(R.id.title_toolbar);
        titleToolbar.setText(getResources().getString(R.string.dreamers_filter_title_toolbar));
    }

    @Override
    protected void onResume() {
        registerReceiver(getCountryIdBroadcast, new IntentFilter(Config.IF_GET_COUNTRY_ID));
        registerReceiver(getCityIdBroadcast, new IntentFilter(Config.IF_GET_CITY_ID));
        setTitleToolbar();
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        super.onResume();
    }

    private void initInputManager() {
        inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    private void hideKeyboard() {
        View view = this.getCurrentFocus();
        if (view != null) {
            inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    @OnClick(R.id.view_selected_all)
    public void onClickCheckedAll() {
        if (checkboxAll.getVisibility() == View.INVISIBLE) {
            removeAllCategories();
            checkedAll();
            loadDreamersList();
        }
    }

    private void checkedAll() {
        checkboxAll.setVisibility(View.VISIBLE);
        checkboxNew.setVisibility(View.INVISIBLE);
        checkboxPopular.setVisibility(View.INVISIBLE);
        checkboxVip.setVisibility(View.INVISIBLE);
        checkboxOnline.setVisibility(View.INVISIBLE);
    }

    private void removeAllCategories() {
        paramsRequest.remove(Field.NEW);
        paramsRequest.remove(Field.TOP_DREAMERS);
        paramsRequest.remove(Field.VIP);
        paramsRequest.remove(Field.ONLINE);
    }

    private void resetAllFilters() {
        paramsRequest.clear();
        cityId = 0;
        countryId = 0;
        nameCity.setText("");
        nameCountry.setText("");
        fieldAgeFrom.setText("");
        fieldAgeTo.setText("");
        customTab.setCurrentTab(1);
        checkedAll();
        clearSavedDataFilter();
    }

    private void clearSavedDataFilter() {
        appPreferences.resetDreamersFilter();
    }

    @OnClick(R.id.reset_filter)
    public void onClickResetFilter() {
        resetAllFilters();
    }

    @OnClick(R.id.view_selected_new)
    public void onClickCheckedNew() {
        textNewDreamers = getResources().getString(R.string.dreamers_filter_title_new);
        changeCheckBox(checkboxNew, Field.NEW);
    }

    @OnClick(R.id.view_selected_popular)
    public void onClickCheckedPopular() {
        textPopularDreamers = getResources().getString(R.string.dreamers_filter_title_popular);
        changeCheckBox(checkboxPopular, Field.TOP_DREAMERS);
    }

    @OnClick(R.id.view_selected_vip)
    public void onClickCheckedVip() {
        textVipDreamers = getResources().getString(R.string.dreamers_filter_title_vip);
        changeCheckBox(checkboxVip, Field.VIP);
    }

    @OnClick(R.id.view_selected_online)
    public void onClickCheckedOnline() {
        textOnlineDreamers = getResources().getString(R.string.dreamers_filter_title_online);
        changeCheckBox(checkboxOnline, Field.ONLINE);
    }

    private void changeCheckBox(View checkBox, String category) {
        checkboxAll.setVisibility(View.INVISIBLE);
        cancelRequest();
        if (checkBox.getVisibility() == View.VISIBLE) {
            checkBox.setVisibility(View.INVISIBLE);
            paramsRequest.remove(category);
            cancelRequest();
        } else {
            checkBox.setVisibility(View.VISIBLE);
            paramsRequest.put(category, true);
        }

        if (checkboxNew.getVisibility() == View.INVISIBLE
                && checkboxOnline.getVisibility() == View.INVISIBLE
                && checkboxPopular.getVisibility() == View.INVISIBLE
                && checkboxVip.getVisibility() == View.INVISIBLE) {
            checkboxAll.setVisibility(View.VISIBLE);
        }
        loadDreamersList();
    }

    private boolean filterModified() {
        if (nameCity.getText().length() == 0
                && nameCountry.getText().length() == 0
                && fieldAgeFrom.getText().length() == 0
                && fieldAgeTo.getText().length() == 0
                && tagTab.equals(Config.TAG_TAB_ALL_DREAMERS)
                && checkboxNew.getVisibility() != View.VISIBLE
                && checkboxPopular.getVisibility() != View.VISIBLE
                && checkboxVip.getVisibility() != View.VISIBLE
                && checkboxOnline.getVisibility() != View.VISIBLE) {
            return false;
        }
        return true;
    }

    @OnClick(R.id.view_selected_country)
    public void onClickOpenSelectionLocation() {
        Intent intent = new Intent(this, SelectionLocation.class);
        startActivity(intent);
    }

    @OnClick(R.id.view_selected_city)
    public void onClickOpenSelectionLocality() {
        if (nameCountry.getText().length() != 0) {
            Intent intent = new Intent(this, SelectionLocality.class);
            intent.putExtra(Config.BUNDLE_COUNTRY_ID, countryId);
            startActivity(intent);
        }
    }

    @OnClick(R.id.btn_show_all_results)
    public void onClickShowAllResults() {
        String country = nameCountry.getText().toString();
        String city = nameCity.getText().toString();
        Intent intent = new Intent(Config.IF_FILLING_DREAMERS_RESULTS);
        intent.putExtra(Field.GENDER, getTextDreamerGender());
        intent.putExtra(Field.AGE_FROM, getAgeFrom());
        intent.putExtra(Field.AGE_TO, getAgeTo());
        intent.putExtra(Field.COUNTRY, country);
        intent.putExtra(Field.CITY, city);
        intent.putExtra(Field.TOTAL_COUNT, (int) countResults);
        intent.putExtra(Config.INTENT_FILTER_MODIFIED, filterModified());
        intent.putExtra(Config.INTENT_MAP_PARAMS_FILTER, (Serializable) paramsRequest);
        intent.putExtra(Config.INTENT_CATEGORIES_FILTER_NEW, textNewDreamers);
        intent.putExtra(Config.INTENT_CATEGORIES_FILTER_POPULAR, textPopularDreamers);
        intent.putExtra(Config.INTENT_CATEGORIES_FILTER_ONLINE, textOnlineDreamers);
        intent.putExtra(Config.INTENT_CATEGORIES_FILTER_VIP, textVipDreamers);
        sendBroadcast(intent);
        finish();
    }

    private String getAgeFrom() {
        if (fieldAgeFrom.getText().length() != 0) {
            String txtAgeFrom = getResources().getString(R.string.dreamers_filter_text_hint_age_from);
            return txtAgeFrom + " " + fieldAgeFrom.getText().toString();
        }
        return null;
    }

    private String getAgeTo() {
        if (fieldAgeTo.getText().length() != 0) {
            String txtAgeTo = getResources().getString(R.string.dreamers_filter_text_hint_age_to);
            return txtAgeTo + " " + fieldAgeTo.getText().toString();
        }
        return null;
    }

    private String getTextDreamerGender() {
        if (textDreamerGender != null && textDreamerGender.length() != 0) {
            return textDreamerGender;
        }
        return null;
    }

    private String getFieldParamDreamerGender() {
        if (dreamerGender != null && dreamerGender.length() != 0) {
            return dreamerGender;
        }
        return "";
    }

    private void cancelRequest() {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                hideKeyboard();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private BroadcastReceiver getCountryIdBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            countryId = intent.getIntExtra(Config.BUNDLE_COUNTRY_ID, 0);
            String countryName = intent.getStringExtra(Config.BUNDLE_COUNTRY);
            nameCountry.setText(countryName);
            paramsRequest.put(Field.COUNTRY_ID, countryId);
            loadDreamersList();
        }
    };

    private BroadcastReceiver getCityIdBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            cityId = intent.getIntExtra(Config.BUNDLE_CITY_ID, 0);
            String cityName = intent.getStringExtra(Config.BUNDLE_CITY);
            nameCity.setText(cityName);
            paramsRequest.put(Field.CITY_ID, cityId);
            loadDreamersList();
        }
    };

    @Override
    public void onTabChanged(String tabId) {
        switch (tabId) {
            case Config.TAG_TAB_FEMALE_DREAMERS:
                dreamerGender = Field.FEMALE;
                textDreamerGender = getResources().getString(R.string.dreamers_filter_title_female);
                paramsRequest.put(Field.GENDER, Field.FEMALE);
                break;
            case Config.TAG_TAB_MALE_DREAMERS:
                dreamerGender = Field.MALE;
                textDreamerGender = getResources().getString(R.string.dreamers_filter_title_male);
                paramsRequest.put(Field.GENDER, Field.MALE);
                break;
            case Config.TAG_TAB_ALL_DREAMERS:
                dreamerGender = "";
                paramsRequest.remove(Field.GENDER);
                break;
        }
        loadDreamersList();
    }

    private void saveStateFilter() {
        preferences.edit().putString(Config.BUNDLE_COUNTRY, nameCountry.getText().toString()).apply();
        preferences.edit().putInt(Config.BUNDLE_COUNTRY_ID, countryId).apply();
        preferences.edit().putString(Config.BUNDLE_CITY, nameCity.getText().toString()).apply();
        preferences.edit().putInt(Config.BUNDLE_CITY_ID, cityId).apply();
        preferences.edit().putString(Config.BUNDLE_AGE_FROM, fieldAgeFrom.getText().toString()).apply();
        preferences.edit().putString(Config.BUNDLE_AGE_TO, fieldAgeTo.getText().toString()).apply();
        preferences.edit().putString(Config.BUNDLE_USER_GENDER, getFieldParamDreamerGender()).apply();
        preferences.edit().putInt(Config.BUNDLE_TAB_TAG_DREAMERS_FILTER, customTab.getCurrentTab()).apply();

        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_ALL, checkboxAll.getVisibility()).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_NEW, checkboxNew.getVisibility()).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_POPULARS, checkboxPopular.getVisibility()).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_VIP, checkboxVip.getVisibility()).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_ONLINE, checkboxOnline.getVisibility()).apply();

        preferences.edit().putString(Field.NEW, textNewDreamers).apply();
        preferences.edit().putString(Field.TOP_DREAMERS, textPopularDreamers).apply();
        preferences.edit().putString(Field.VIP, textVipDreamers).apply();
        preferences.edit().putString(Field.ONLINE, textOnlineDreamers).apply();
    }

    private void setVisibleCheckBox(int visibleCheckBox, String category, View checkBox) {
        if (visibleCheckBox == View.VISIBLE) {
            changeCheckBox(checkBox, category);
        }
    }

    private Map<String, Object> getParamsRequest(String key, Object value) {
        if (value instanceof String) {
            String valueString = (String) value;
            if (valueString.length() != 0) {
                paramsRequest.put(key, valueString);
            } else {
                paramsRequest.remove(key);
            }
        } else if (value instanceof Integer) {
            int valueInt = (int) value;
            if (valueInt != 0) {
                paramsRequest.put(key, valueInt);
            } else {
                paramsRequest.remove(key);
            }
        } else if (value instanceof Boolean) {
            boolean valueBoolean = (boolean) value;
            if (valueBoolean) {
                paramsRequest.put(key, valueBoolean);
            } else {
                paramsRequest.remove(key);
            }
        }
        return paramsRequest;
    }

    private void insertTheSavedStateFilter() {
        nameCountry.setText(preferences.getString(Config.BUNDLE_COUNTRY, ""));
        countryId = preferences.getInt(Config.BUNDLE_COUNTRY_ID, 0);
        cityId = preferences.getInt(Config.BUNDLE_CITY_ID, 0);
        nameCity.setText(preferences.getString(Config.BUNDLE_CITY, ""));
        fieldAgeFrom.setText(preferences.getString(Config.BUNDLE_AGE_FROM, ""));
        fieldAgeTo.setText(preferences.getString(Config.BUNDLE_AGE_TO, ""));
        customTab.setCurrentTab(preferences.getInt(Config.BUNDLE_TAB_TAG_DREAMERS_FILTER, 1));
        paramsRequest = getParamsRequest(Field.COUNTRY_ID, countryId);
        paramsRequest = getParamsRequest(Field.CITY_ID, cityId);
        paramsRequest = getParamsRequest(Field.GENDER, dreamerGender);
        setVisibleCheckBox(preferences.getInt(Config.BUNDLE_CHECKBOX_VIP, 1), Field.VIP, checkboxVip);
        setVisibleCheckBox(preferences.getInt(Config.BUNDLE_CHECKBOX_POPULARS, 1), Field.TOP_DREAMERS, checkboxPopular);
        setVisibleCheckBox(preferences.getInt(Config.BUNDLE_CHECKBOX_ONLINE, 1), Field.ONLINE, checkboxOnline);
        setVisibleCheckBox(preferences.getInt(Config.BUNDLE_CHECKBOX_NEW, 1), Field.NEW, checkboxNew);
        try {
            paramsRequest = getParamsRequest(Field.AGE_FROM, Integer.parseInt(fieldAgeFrom.getText().toString()));
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        try {
            paramsRequest = getParamsRequest(Field.AGE_TO, Integer.parseInt(fieldAgeTo.getText().toString()));
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        textNewDreamers = preferences.getString(Field.NEW, "");
        textPopularDreamers = preferences.getString(Field.TOP_DREAMERS, "");
        textVipDreamers = preferences.getString(Field.VIP, "");
        textOnlineDreamers = preferences.getString(Field.ONLINE, "");

        loadDreamersList();
    }

    @Override
    protected void onDestroy() {
        saveStateFilter();
        unregisterReceiver(getCountryIdBroadcast);
        unregisterReceiver(getCityIdBroadcast);
        super.onDestroy();
    }
}
