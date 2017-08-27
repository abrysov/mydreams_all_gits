package com.mydreams.android.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
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
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.activities.DreamersFilter;
import com.mydreams.android.adapters.DreamersListAdapter;
import com.mydreams.android.components.AppPreferences;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.components.StringAppendingComponent;
import com.mydreams.android.database.DreamerHelper;
import com.mydreams.android.manager.DreamersListManager;
import com.mydreams.android.models.Dreamer;
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
 * Created by mikhail on 19.05.16.
 */
public class DreamerListFragment extends BaseFragment {

    @Bind(R.id.btn_clear_dreams_search)
    ImageButton clearDreamersSearch;
    @Bind(R.id.view_dreams_search)
    LinearLayout viewDreamersSearch;
    @Bind(R.id.view_dreams_search_default)
    LinearLayout viewDreamersSearchDefault;
    @Bind(R.id.dreams_search)
    EditText dreamersSearch;
    @Bind(R.id.title_dreams_search)
    TextView titleDreamersSearch;
    @Bind(R.id.close_field_search)
    TextView closeFieldSearch;
    @Bind(R.id.dreamer_recycler_view)
    RecyclerView dreamerRecyclerView;
    @Bind(R.id.swipe_refresh_layout)
    SwipeRefreshLayout swipeRefreshLayout;
    @Bind(R.id.progress_bar)
    ProgressBar progressBar;
    @Bind(R.id.blank_state)
    LinearLayout blankState;
    @Bind(R.id.btn_reload)
    ImageButton btnReload;
    @Bind(R.id.view_dreamers_results)
    LinearLayout viewDreamersResults;
    @Bind(R.id.btn_hide_results)
    ImageButton btnHideResults;
    @Bind(R.id.txt_filter_results)
    TextView txtFilterResults;
    @Bind(R.id.txt_found_dreamers_results)
    TextView txtFoundDreamersResults;

    private DreamersListAdapter dreamersListAdapter;
    private List<Dreamer> dreamerList;
    private Map<String, Object> paramsRequest;
    private boolean isRefreshing;
    private Cancelable searchRequest;
    private boolean loading;
    private boolean filterModified;

    @Inject
    SettingsToolbar settingsToolbar;
    @Inject
    DreamerHelper dreamerHelper;
    @Inject
    DreamersListManager dreamersListManager;
    @Inject
    AppPreferences appPreferences;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.dreamer_list_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        setDreamersSearchTitle();
        initRecyclerView();
        setHasOptionsMenu(true);
        hideKeyboardPressedEnter(dreamersSearch);
        clearDreamersList();
        initMapParams();
        loadDreamersList();
        initSwipeRefreshLayout();
        typeFragment = Config.FTYPE_DREAMERS;
        return view;
    }

    private void initSwipeRefreshLayout() {
        swipeRefreshLayout.setColorSchemeColors(getResources().getColor(R.color.colorPrimary));
        swipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                paramsRequest.remove(Field.PAGE);
                isRefreshing = true;
                loadDreamersList();
            }
        });
    }

    private void loadDreamersList() {
        if (!swipeRefreshLayout.isRefreshing()) {
            progressBar.setVisibility(View.VISIBLE);
        }
        clearDreamerList();
        searchRequest = dreamersListManager.loadDreamersList(paramsRequest);
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
    }

    private void initRecyclerView() {
        dreamerRecyclerView.setHasFixedSize(true);
        dreamerRecyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        dreamerRecyclerView.setOnTouchListener(touchListener);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getActivity());
        dreamerRecyclerView.setLayoutManager(linearLayoutManager);
        dreamersListManager.setDreamerSaveListener(new DreamersListManager.OnDreamerSaveListener() {
            @Override
            public void complete() {
                if (dreamersListAdapter == null) {
                    fillingDreamersListAdapter();
                } else {
                    refreshDreamersListAdapter();
                }
                swipeRefreshLayout.setRefreshing(false);
                progressBar.setVisibility(View.GONE);

                if (blankState.getVisibility() == View.VISIBLE) {
                    hideNotificationBlankState();
                }
                swipeRefreshLayout.setEnabled(true);
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

    private void showNotificationBlankState() {
        swipeRefreshLayout.setEnabled(false);
        dreamerRecyclerView.setVisibility(View.GONE);
        blankState.setVisibility(View.VISIBLE);
    }

    private void hideNotificationBlankState() {
        dreamerRecyclerView.setVisibility(View.VISIBLE);
        blankState.setVisibility(View.GONE);
    }

    @OnClick(R.id.btn_reload)
    public void onClickReloadState() {
        hideNotificationBlankState();
        loadDreamersList();
    }
    
    private void refreshDreamersListAdapter() {
        dreamersListAdapter.notifyItemInserted(dreamerList.size());
        dreamersListAdapter.refresh(getDreamerList());
    }

    @OnTextChanged(R.id.dreams_search)
    public void changeSearchText(Editable s) {
        String prefix = s.toString();
        if (s.length() > 0) {
            dreamersSearch(prefix);
        } else {
            cancelRequest();
            paramsRequest.remove(Field.SEARCH);
            dreamersListAdapter = null;
            loadDreamersList();
        }
    }

    private void dreamersSearch(String prefix) {
        clearDreamersList();
        cancelRequest();
        paramsRequest.put(Field.SEARCH, prefix);
        searchRequest = dreamersListManager.loadDreamersList(paramsRequest);
    }

    private void cancelRequest() {
        if (searchRequest != null) {
            searchRequest.cancel();
        }
    }

    private void clearDreamersList() {
        dreamersListAdapter = null;
        dreamerHelper.clearDreamersList();
    }

    private View.OnTouchListener touchListener = new View.OnTouchListener() {
        @Override
        public boolean onTouch(View v, MotionEvent event) {
            hideDreamersSearchAtScrolling();
            hideKeyboard();
            return false;
        }
    };

    private void hideDreamersSearchAtScrolling() {
        if (dreamersSearch.getText().length() == 0) {
            viewDreamersSearch.setVisibility(View.GONE);
            viewDreamersSearchDefault.setVisibility(View.VISIBLE);
        }
    }

    private void setDreamersSearchTitle() {
        titleDreamersSearch.setText(getResources().getString(R.string.dreamers_title_search));

    }

    private void fillingDreamersListAdapter() {
        dreamerList = getDreamerList();
        dreamersListAdapter = new DreamersListAdapter(dreamerList, dreamerRecyclerView);
        dreamerRecyclerView.setAdapter(dreamersListAdapter);
        dreamersListAdapter.setEndlessScrollListener(endlessScrollListener);
        dreamersListAdapter.notifyDataSetChanged();
    }

    private DreamersListAdapter.EndlessScrollListener endlessScrollListener = new DreamersListAdapter.EndlessScrollListener() {
        @Override
        public boolean onLoadMore(int pageNumber) {
            if (!loading) {
                pageNumber++;
                paramsRequest.put(Field.PAGE, pageNumber);
                dreamersListManager.loadDreamersList(paramsRequest);
                loading = true;
            }
            return false;
        }
    };

    private void clearParamsRequest() {
        paramsRequest.clear();
    }

    private List<Dreamer> getDreamerList() {
        dreamerList = new ArrayList<>();
        dreamerList.addAll(dreamerHelper.getDreamersList());
        return dreamerList;
    }

    private void clearDreamerList() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                dreamerHelper.clearDreamersList();
            }
        });
        thread.start();
    }

    @OnClick(R.id.btn_clear_dreams_search)
    public void clearFieldSearch() {
        if (dreamersSearch.getText().length() != 0) {
            dreamersSearch.setText("");
        }
    }

    @OnClick(R.id.close_field_search)
    public void closeFieldSearchDreamers() {
        dreamersSearch.requestFocus();
        if (dreamersSearch.getText().length() != 0) {
            dreamersSearch.setText("");
        }
        hideKeyboard();
        viewDreamersSearch.setVisibility(View.GONE);
        viewDreamersSearchDefault.setVisibility(View.VISIBLE);
    }

    @OnClick(R.id.view_dreams_search_default)
    public void onClickShowSearchDreams() {
        dreamersSearch.requestFocus();
        showKeyboard(dreamersSearch);
        viewDreamersSearchDefault.setVisibility(View.GONE);
        viewDreamersSearch.setVisibility(View.VISIBLE);

    }

    @OnClick(R.id.btn_hide_results)
    public void onClickHideResults() {
        viewDreamersResults.setVisibility(View.GONE);
        dreamersListAdapter = null;
        clearParamsRequest();
        loadDreamersList();
        appPreferences.resetDreamersFilter();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.dreamers_menu, menu);
        super.onCreateOptionsMenu(menu, inflater);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case R.id.dreamers_filter:
                Intent intent = new Intent(getActivity(), DreamersFilter.class);
                startActivity(intent);
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }

    private BroadcastReceiver fillingDreamersResultsBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            filterModified = intent.getBooleanExtra(Config.INTENT_FILTER_MODIFIED, false);
            setFoundDreamersResults(intent);
            fillingDreamersResults(intent);
            if (filterModified) {
                viewDreamersResults.setVisibility(View.VISIBLE);
            } else {
                viewDreamersResults.setVisibility(View.GONE);
            }
            fillingDreamersListAdapter();
        }
    };

    private void fillingDreamersResults(Intent intent) {
        String gender = intent.getStringExtra(Field.GENDER);
        String ageFrom = intent.getStringExtra(Field.AGE_FROM);
        String ageTo = intent.getStringExtra(Field.AGE_TO);
        String country = intent.getStringExtra(Field.COUNTRY);
        String city = intent.getStringExtra(Field.CITY);
        String newDreamers = intent.getStringExtra(Config.INTENT_CATEGORIES_FILTER_NEW);
        String popularDreamers = intent.getStringExtra(Config.INTENT_CATEGORIES_FILTER_POPULAR);
        String onlineDreamers = intent.getStringExtra(Config.INTENT_CATEGORIES_FILTER_ONLINE);
        String vipDreamers = intent.getStringExtra(Config.INTENT_CATEGORIES_FILTER_VIP);

        String textResults = "";
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, gender);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, ageFrom);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, ageTo);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, country);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, city);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, newDreamers);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, popularDreamers);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, onlineDreamers);
        textResults = StringAppendingComponent.stringByAppendingComponent(textResults, vipDreamers);

        paramsRequest = (Map<String, Object>) intent.getSerializableExtra(Config.INTENT_MAP_PARAMS_FILTER);

        txtFilterResults.setText(textResults.replace(", " + ageTo," " + ageTo));
    }

    private void setFoundDreamersResults(Intent intent) {
        int countResults = intent.getIntExtra(Field.TOTAL_COUNT, 0);
        txtFoundDreamersResults.setText(getResources().getString(R.string.dreamers_filter_text_results,String.valueOf(countResults)));
    }

    @Override
    public void onResume() {
        getActivity().registerReceiver(fillingDreamersResultsBroadcast, new IntentFilter(Config.IF_FILLING_DREAMERS_RESULTS));
        settingsToolbar.setTitle(getResources().getString(R.string.dreamers_title_toolbar));
        settingsToolbar.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        super.onResume();
    }

    @Override
    public void onDestroy() {
        try {
            getActivity().unregisterReceiver(fillingDreamersResultsBroadcast);
        } catch (Exception e) {
            e.printStackTrace();
        }
        super.onDestroy();
    }
}
