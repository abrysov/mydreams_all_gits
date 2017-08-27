package com.mydreams.android;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.IdRes;
import android.support.design.widget.NavigationView;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.facebook.FacebookSdk;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.components.SessionService;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.fragments.AgreementFragment;
import com.mydreams.android.fragments.AuthorizationFragment;
import com.mydreams.android.fragments.BlockedUserFragment;
import com.mydreams.android.fragments.DreamerListFragment;
import com.mydreams.android.fragments.FulfillDreamFragment;
import com.mydreams.android.fragments.FulfilledDreamFragment;
import com.mydreams.android.fragments.DreamListFragment;
import com.mydreams.android.fragments.SelectionLocalityFragment;
import com.mydreams.android.fragments.SelectionLocationFragment;
import com.mydreams.android.fragments.ProfileFragment;
import com.mydreams.android.fragments.ProfileRecoveryFragment;
import com.mydreams.android.fragments.RecoveryPasswordFragment;
import com.mydreams.android.fragments.RedirectStatusFragment;
import com.mydreams.android.fragments.RegFirstStageFragment;
import com.mydreams.android.fragments.RegSecondStageFragment;
import com.mydreams.android.fragments.RegThirdStageFragment;
import com.mydreams.android.fragments.SendRegDataFragment;
import com.mydreams.android.fragments.SettingsFragment;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserStatus;
import com.mydreams.android.net.callers.Cancelable;
import com.squareup.picasso.Picasso;

import java.util.Timer;
import java.util.TimerTask;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import de.hdodenhof.circleimageview.CircleImageView;

public class MainActivity extends AppCompatActivity implements NavigationView.OnNavigationItemSelectedListener {

    @Bind(R.id.drawer)
    DrawerLayout drawerLayout;
    @Bind(R.id.toolbar)
    Toolbar toolbar;
    @Bind(R.id.navigation_view)
    NavigationView navigationView;

    private Button btnAddCoins;
    private TextView userName;
    private CircleImageView userPhoto;
    private TextView userCoins;
    private InputMethodManager inputMethodManager;
    private Timer timer;
    private Cancelable cancelRequest;

    @Inject
    SessionService sessionService;
    @Inject
    SettingsToolbar settingsToolbar;
    @Inject
    UserHelper userHelper;
    @Inject
    UserManager userManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        App.getComponent().inject(this);
        ButterKnife.bind(this);

        initSocials();
        setCustomToolbar();
        setTitleToolbar();
        initNavigationDrawerAndElement();
        initInputManager();
        initTimer();

        if (!sessionService.isAuthorized()) {
            openFragment(Config.FTYPE_AUTHORIZATION, null);
            lockedDrawerLayout();
        } else {
            openFragment(Config.FTYPE_PROFILE, null);
            loadUserInfo();
        }
    }

    private void initTimer() {
        timer = new Timer();
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

    private void initSocials() {
        FacebookSdk.sdkInitialize(this);
    }

    private void setCustomToolbar() {
        settingsToolbar.setToolbar(toolbar);
    }

    private void setTitleToolbar() {
        toolbar.setTitle("");
        setSupportActionBar(toolbar);
    }

    private void lockedDrawerLayout() {
        drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED, Gravity.LEFT);
    }

    private void unlockedDrawerLayout() {
        drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
    }

    public boolean openFragment(int fragmentType, Bundle bundle) {
        if (Config.FTYPE_UNKNOWN == fragmentType) {
            return false;
        }

        Fragment fragment = null;
        boolean needToBackStack = true;
        hideKeyboard();

        switch (fragmentType) {
            case Config.FTYPE_PROFILE:
                fragment = new ProfileFragment();
                unlockedDrawerLayout();
                needToBackStack = false;
                break;
            case Config.FTYPE_REG_FIRST_STAGE:
                fragment = new RegFirstStageFragment();
                break;
            case Config.FTYPE_REG_SECOND_STAGE:
                fragment = new RegSecondStageFragment();
                break;
            case Config.FTYPE_REG_THIRD_STAGE:
                fragment = new RegThirdStageFragment();
                break;
            case Config.FTYPE_AUTHORIZATION:
                fragment = new AuthorizationFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_REDIRECT_PASSWORD:
                fragment = new RecoveryPasswordFragment();
                break;
            case Config.FTYPE_REDIRECT_STATUS:
                fragment = new RedirectStatusFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_PROFILE_RECOVERY:
                fragment = new ProfileRecoveryFragment();
                break;
            case Config.FTYPE_SELECTION_COUNTRY:
                fragment = new SelectionLocationFragment();
                break;
            case Config.FTYPE_SELECTION_LOCALITY:
                fragment = new SelectionLocalityFragment();
                break;
            case Config.FTYPE_BLOCKED_USER:
                fragment = new BlockedUserFragment();
                break;
            case Config.FTYPE_AGREEMENT:
                fragment = new AgreementFragment();
                break;
            case Config.FTYPE_DREAMS:
                fragment = new DreamListFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_FULFILLED_DREAM:
                fragment = new FulfilledDreamFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_DREAMERS:
                fragment = new DreamerListFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_FULFILL_DREAM:
                fragment = new FulfillDreamFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_SETTINGS:
                fragment = new SettingsFragment();
                needToBackStack = false;
                break;
            case Config.FTYPE_SEND_REG_DATA:
                fragment = new SendRegDataFragment();
                break;
        }

        fragment.setArguments(bundle);

        final FragmentTransaction fragmentTransaction = getSupportFragmentManager()
                .beginTransaction()
                .replace(R.id.container, fragment, String.valueOf(fragmentType));
        if (needToBackStack)
            fragmentTransaction.addToBackStack(null);
        else
            clearBackStack();

        fragmentTransaction.commit();
        return true;
    }

    private void clearBackStack() {
        final FragmentManager fm = getSupportFragmentManager();
        final int count = fm.getBackStackEntryCount();

        for (int i = 0; i < count; i++) {
            fm.popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
        }
    }

    private void initNavigationDrawerAndElement() {
        navigationView.setNavigationItemSelectedListener(this);

        View headerLayout = navigationView.getHeaderView(0);

        userName = ButterKnife.findById(headerLayout, R.id.user_name);
        userPhoto = ButterKnife.findById(headerLayout, R.id.user_photo);
        btnAddCoins = ButterKnife.findById(headerLayout, R.id.btn_add_coins);
        userCoins = ButterKnife.findById(headerLayout, R.id.user_coins);

         ActionBarDrawerToggle actionBarDrawerToggle = new ActionBarDrawerToggle(this, drawerLayout, toolbar, R.string.open_drawer, R.string.close_drawer){

            @Override
            public void onDrawerClosed(View drawerView) {
                super.onDrawerClosed(drawerView);
            }

            @Override
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                hideKeyboard();
                loadUserInfo();
            }
        };

        drawerLayout.setDrawerListener(actionBarDrawerToggle);
        actionBarDrawerToggle.syncState();
    }

    private void setMenuCounter(@IdRes int itemId, int count) {
        RelativeLayout view = (RelativeLayout) navigationView.getMenu().findItem(itemId).getActionView();
        TextView navNotification = (TextView) view.findViewById(R.id.nav_notification);
        View customViewCounter = view.findViewById(R.id.custom_view_counter);
        if (count != 0) {
            customViewCounter.setVisibility(View.VISIBLE);
            navNotification.setText(String.valueOf(count));
        } else {
            customViewCounter.setVisibility(View.INVISIBLE);
        }
    }

    @Override
    public void onBackPressed() {
        if (drawerLayout.isDrawerOpen(GravityCompat.START)) {
            drawerLayout.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Fragment fragment = getSupportFragmentManager().findFragmentById(R.id.container);
        fragment.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        int id = item.getItemId();
        switch (id) {
            case R.id.my_dreambook:

                break;
            case R.id.message:

                break;
            case R.id.events:

                break;
            case R.id.news:

                break;
            case R.id.fulfill_dream:
                openFragment(Config.FTYPE_FULFILL_DREAM, null);
                break;
            case R.id.fulfilled_dream:
                openFragment(Config.FTYPE_FULFILLED_DREAM, null);
                break;
            case R.id.dreams:
                openFragment(Config.FTYPE_DREAMS, null);
                break;
            case R.id.dreamers:
                openFragment(Config.FTYPE_DREAMERS, null);
                break;
            case R.id.top100:

                break;
            case R.id.dreams_club:

                break;
            case R.id.setting:
                openFragment(Config.FTYPE_SETTINGS, null);
                break;
        }

        drawerLayout.closeDrawer(GravityCompat.START);
        return true;
    }

    @Override
    protected void onDestroy() {
        ButterKnife.unbind(this);
        unregisterReceiver(logoutBroadcast);
        unregisterReceiver(fillingProfileMenuBroadcast);
        stopTimer();
        cancelRequestRefreshToUserStatus();
        super.onDestroy();
    }

    @Override
    protected void onResume() {
        registerReceiver(logoutBroadcast, new IntentFilter(Config.IF_LOGOUT_BROADCAST));
        registerReceiver(fillingProfileMenuBroadcast, new IntentFilter(Config.IF_FILLING_PROFILE_MENU));
        super.onResume();
    }

    public void onClickAddCoins(View view) {

    }

    private BroadcastReceiver logoutBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            cancelRequestRefreshToUserStatus();
            sessionService.logout();
            stopTimer();
            openAuthorizationFragment();
        }
    };

    private void stopTimer() {
        if (timer != null) {
            timer.cancel();
        }
    }

    private BroadcastReceiver fillingProfileMenuBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            loadUserInfo();
        }
    };

    private void fillingProfileMenu() {
        User user = userHelper.getUser();
        UserStatus userStatus = userHelper.getUserStatus();
        userName.setText(user.getFullName());
        userCoins.setText(String.valueOf(userStatus.getCoinsCount()));
        Picasso.with(this).load(user.getAvatar().getMediumUrl()).into(userPhoto);
        setMenuCounter(R.id.message, userStatus.getMessagesCount());
        setMenuCounter(R.id.dreamers, userStatus.getFriendRequestsCount());
        setMenuCounter(R.id.events, userStatus.getNotificationsCount());
    }

    private void openAuthorizationFragment() {
        Fragment fragment = getSupportFragmentManager().findFragmentByTag(String.valueOf(Config.FTYPE_AUTHORIZATION));
        if (fragment == null || !fragment.isVisible()) {
            openFragment(Config.FTYPE_AUTHORIZATION, null);
        }
    }

    public void setCurrentFragmentType(int value) {
        Config.FTYPE_UNKNOWN = value;
    }

    public void loadUserInfo() {
        userManager.setUserSaveListener(new UserManager.OnUserSaveListener() {
            @Override
            public void complete() {
                refreshUserStatusByTimer();
            }

            @Override
            public void error(String errMsg) {

            }
        });
        userManager.loadUserInfo();
    }

    private void loadProfileStatus() {
        userManager.loadProfileStatus();
        userManager.setUserSaveStatusListener(saveStatusListener);
    }

    private UserManager.OnUserSaveStatusListener saveStatusListener = new UserManager.OnUserSaveStatusListener() {
        @Override
        public void complete() {
            fillingProfileMenu();
        }

        @Override
        public void error(String errMsg) {

        }
    };

    private void refreshUserStatusByTimer() {
        timer = new Timer();
        timer.schedule(new TimerTask() {
            @Override
            public void run() {
                loadProfileStatus();
            }
        }, 0L, 60L * 1000);
    }

    private void cancelRequestRefreshToUserStatus() {
        if (cancelRequest != null) {
            cancelRequest.cancel();
        }
    }
}
