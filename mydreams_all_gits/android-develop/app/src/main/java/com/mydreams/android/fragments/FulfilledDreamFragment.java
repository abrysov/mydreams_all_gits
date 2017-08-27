package com.mydreams.android.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TabHost;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.activities.AddFulfilledDream;
import com.mydreams.android.adapters.DreamListAdapter;
import com.mydreams.android.components.CustomTabHost;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.components.TabTag;
import com.mydreams.android.database.DreamHelper;
import com.mydreams.android.manager.DreamsListManager;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.callers.Cancelable;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 16.05.16.
 */
public class FulfilledDreamFragment extends BaseFragment implements TabHost.OnTabChangeListener {

    @Bind(R.id.tab_dreams)
    TabHost tabHost;
    @Bind(R.id.btn_clear_dreams_search)
    ImageButton clearDreamsSearch;
    @Bind(R.id.view_dreams_search)
    LinearLayout viewDreamsSearch;
    @Bind(R.id.view_dreams_search_default)
    LinearLayout viewDreamsSearchDefault;
    @Bind(R.id.dreams_search)
    EditText dreamsSearch;
    @Bind(R.id.dream_recycler_view)
    RecyclerView dreamRecyclerView;
    @Bind(R.id.title_dreams_search)
    TextView titleDreamsSearch;
    @Bind(R.id.close_field_search)
    TextView closeFieldSearch;
    @Bind(R.id.notif_no_results_dreams_search)
    TextView notificationNoResultsSearchDreams;
    @Bind(R.id.swipe_refresh_layout)
    SwipeRefreshLayout swipeRefreshLayout;
    @Bind(R.id.progress_bar)
    ProgressBar progressBar;
    @Bind(R.id.blank_state)
    LinearLayout blankState;
    @Bind(R.id.btn_reload)
    ImageButton btnReload;

    private DreamListAdapter dreamListAdapter;
    private List<Dream> dreamList;
    private Map<String, Object> paramsRequest;
    private TabTag tabTag;
    private Cancelable searchRequest;
    private boolean isCurrentlySearch;
    private String prefix;
    private boolean isRefreshing;
    private boolean loading;

    @Inject
    DreamsListManager dreamsListManager;
    @Inject
    DreamHelper dreamHelper;
    @Inject
    SettingsToolbar settingsToolbar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fulfilled_dreams_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        initTabs();
        setTitleDreamSearch();
        initRecyclerView();
        setHasOptionsMenu(true);
        hideKeyboardPressedEnter(dreamsSearch);
        clearDreamsList();
        initMapParams();
        loadAllFulfilledDreams();
        initSwipeRefreshLayout();
        typeFragment = Config.FTYPE_FULFILLED_DREAM;
        return view;
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
    }

    private void initSwipeRefreshLayout() {
        swipeRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimary));
        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                isRefreshing = true;
                if (isCurrentlySearch) {
                    searchDreams(prefix);
                } else {
                    loadDreamsByTabTag();
                }
            }
        });
    }

    private void setTitleDreamSearch() {
        titleDreamsSearch.setText(getResources().getString(R.string.fulfilled_dreams_text_search));
    }

    private void initRecyclerView() {
        dreamRecyclerView.setHasFixedSize(true);
        dreamRecyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        dreamRecyclerView.setOnTouchListener(touchListener);
        dreamsListManager.setSaveDreamListener(new DreamsListManager.OnSaveDreamListener() {
            @Override
            public void complete() {
                if (dreamListAdapter == null) {
                    fillingDreamAdapter();
                } else {
                    refreshDreamsAdapter();
                }
                searchRequest = null;
                swipeRefreshLayout.setRefreshing(false);

                progressBar.setVisibility(View.GONE);

                if (blankState.getVisibility() == View.VISIBLE) {
                    hideNotificationBlankState();
                    swipeRefreshLayout.setEnabled(true);
                } else {
                    swipeRefreshLayout.setEnabled(true);
                }
                loading = false;
            }

            @Override
            public void error(String errMsg) {
                progressBar.setVisibility(View.GONE);
                swipeRefreshLayout.setRefreshing(false);
                if (isRefreshing) {
                    showNotificationError(errMsg);
                } else {
                    showNotificationBlankState();
                }
            }
        });
    }

    private void fillingDreamAdapter() {
        dreamList = getDreamList();
        dreamListAdapter = new DreamListAdapter(dreamList, dreamRecyclerView);
        dreamRecyclerView.setAdapter(dreamListAdapter);
        dreamListAdapter.setEndlessScrollListener(endlessScrollListener);

        if (isCurrentlySearch && dreamListAdapter.getItemCount() == 0) {
            showNotificationNoResults();
        } else {
            hideNotificationNoResults();
        }
    }

    private void refreshDreamsAdapter() {
        dreamListAdapter.notifyItemInserted(dreamList.size());
        dreamListAdapter.refresh(getDreamList());
    }

    private List<Dream> getDreamList() {
        dreamList = new ArrayList<>();
        dreamList.addAll(dreamHelper.getDreamList());
        return dreamList;
    }

    private DreamListAdapter.EndlessScrollListener endlessScrollListener = new DreamListAdapter.EndlessScrollListener() {
        @Override
        public boolean onLoadMore(int pageNumber) {
            if (!loading) {
                pageNumber++;
                paramsRequest.put(Field.PAGE, pageNumber);
                dreamsListManager.loadDreamsList(paramsRequest);
                loading = true;
            }
            return false;
        }
    };

    @Override
    public void onResume() {
        settingsToolbar.setTitle(getResources().getString(R.string.fulfilled_dreams_title_toolbar));
        settingsToolbar.setBackgroundColor(getResources().getColor(R.color.fulfilled_dreams_color_tollbar));
        super.onResume();
    }

    private void showNotificationNoResults() {
        notificationNoResultsSearchDreams.setVisibility(View.VISIBLE);
    }

    private void hideNotificationNoResults() {
        notificationNoResultsSearchDreams.setVisibility(View.GONE);
    }

    private void showNotificationBlankState() {
        swipeRefreshLayout.setEnabled(false);
        dreamRecyclerView.setVisibility(View.GONE);
        blankState.setVisibility(View.VISIBLE);
    }

    private void hideNotificationBlankState() {
        dreamRecyclerView.setVisibility(View.VISIBLE);
        blankState.setVisibility(View.GONE);
    }

    @OnClick(R.id.btn_reload)
    public void onClickReloadState() {
        hideNotificationBlankState();
        loadDreamsByTabTag();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.fulfilled_dreams_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.create_dream:
                Intent intent = new Intent(getActivity(), AddFulfilledDream.class);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private void initTabs() {
        CustomTabHost customTab = new CustomTabHost();
        customTab.setTabHost(tabHost);
        customTab.setNewTab(Config.TAG_TAB_ALL_DREAMS, getResources().getString(R.string.fulfilled_dreams_tab_text_all), R.id.tabContent);
        customTab.setNewTab(Config.TAG_TAB_FEMALE_DREAMS, getResources().getString(R.string.fulfilled_dreams_tab_text_female), R.id.tabContent);
        customTab.setNewTab(Config.TAG_TAB_MALE_DREAMS, getResources().getString(R.string.fulfilled_dreams_tab_text_male), R.id.tabContent);
        customTab.setTabTextColor(getResources().getColorStateList(R.color.tab_indicator_selector));
        customTab.setTabTextSize(14);
        customTab.setBackgroundTab(R.drawable.tab_bottom_line_fulfilled_dreams);
        customTab.setCurrentTab(0);
        customTab.setOnTabChangedListener(this);
    }

    private View.OnTouchListener touchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            hideDreamsSearchAtScrolling();
            hideKeyboard();
            return false;
        }
    };

    private void hideDreamsSearchAtScrolling() {
        if (dreamsSearch.getText().length() == 0) {
            isCurrentlySearch = false;
            viewDreamsSearch.setVisibility(View.GONE);
            viewDreamsSearchDefault.setVisibility(View.VISIBLE);
        }
    }

    private void clearDreamsList() {
        dreamListAdapter = null;
        dreamHelper.clearDreamList();
    }

    private void clearParamsRequest() {
        paramsRequest.clear();
    }

    private void searchDreams(String prefix) {
        isCurrentlySearch = true;
        clearDreamsList();
        cancelSearchRequest();
        paramsRequest.put(Field.SEARCH, prefix);
        searchRequest = dreamsListManager.loadDreamsList(paramsRequest);
    }

    private void cancelSearchRequest() {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
    }

    @OnTextChanged(R.id.dreams_search)
    public void changeSearchText(Editable s) {
        prefix = s.toString();
        if (s.length() > 0) {
            searchDreams(prefix);
        } else {
            hideNotificationNoResults();
            loadDreamsByTabTag();
        }
    }

    private void setSearchParams() {
        if (isCurrentlySearch) {
            paramsRequest.put(Field.SEARCH, prefix);
        } else {
            paramsRequest.remove(Field.SEARCH);
        }
    }

    private void loadDreamsByTabTag() {
        if (!swipeRefreshLayout.isRefreshing()) {
            progressBar.setVisibility(View.VISIBLE);
        }
        clearDreamsList();
        clearParamsRequest();
        cancelSearchRequest();
        switch (tabTag) {
            case ALL_DREAMS:
                loadAllFulfilledDreams();
                break;
            case FEMALE_DREAMS:
                loadFemaleFulfilledDreams();
                break;
            case MALE_DREAMS:
                loadMaleFulfilledDreams();
                break;
        }
    }

    @OnClick(R.id.btn_clear_dreams_search)
    public void clearFieldSearch() {
        if (dreamsSearch.getText().length() != 0) {
            clearParamsRequest();
            dreamsSearch.setText("");
        }
    }

    @OnClick(R.id.close_field_search)
    public void closeFieldSearchDreams() {
        isCurrentlySearch = false;
        if (dreamsSearch.getText().length() != 0) {
            dreamsSearch.setText("");
        }
        hideKeyboard();
        viewDreamsSearch.setVisibility(View.GONE);
        viewDreamsSearchDefault.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.view_dreams_search_default)
    public void onClickShowSearchDreams() {
        dreamsSearch.requestFocus();
        showKeyboard(dreamsSearch);
        viewDreamsSearchDefault.setVisibility(View.GONE);
        viewDreamsSearch.setVisibility(View.VISIBLE);
    }

    private void loadAllFulfilledDreams() {
        if (!swipeRefreshLayout.isRefreshing()) {
            progressBar.setVisibility(View.VISIBLE);
        }
        tabTag = TabTag.ALL_DREAMS;
        paramsRequest.put(Field.FULFILLED, true);
        setSearchParams();
        dreamsListManager.loadDreamsList(paramsRequest);
    }

    private void loadFemaleFulfilledDreams() {
        paramsRequest.put(Field.GENDER, Field.FEMALE);
        setSearchParams();
        dreamsListManager.loadDreamsList(paramsRequest);
    }

    private void loadMaleFulfilledDreams() {
        paramsRequest.put(Field.GENDER, Field.MALE);
        setSearchParams();
        dreamsListManager.loadDreamsList(paramsRequest);
    }

    @Override
    public void onTabChanged(String tabId) {
        isRefreshing = false;
        if (blankState.getVisibility() == View.VISIBLE) {
            hideNotificationBlankState();
        }
        progressBar.setVisibility(View.VISIBLE);
        clearDreamsList();
        clearParamsRequest();
        dreamRecyclerView.setVisibility(View.GONE);
        switch (tabId) {
            case Config.TAG_TAB_ALL_DREAMS:
                tabTag = TabTag.ALL_DREAMS;
                loadAllFulfilledDreams();
                break;
            case Config.TAG_TAB_FEMALE_DREAMS:
                tabTag = TabTag.FEMALE_DREAMS;
                loadFemaleFulfilledDreams();
                break;
            case Config.TAG_TAB_MALE_DREAMS:
                tabTag = TabTag.MALE_DREAMS;
                loadMaleFulfilledDreams();
                break;
        }
    }
}
