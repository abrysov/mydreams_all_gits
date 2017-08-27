package com.mydreams.android.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.manager.UserManager;

import javax.inject.Inject;

/**
 * Created by user on 26.02.16.
 */
public class ProfileFragment extends BaseFragment {

    @Inject
    SettingsToolbar settingsToolbar;
    @Inject
    UserHelper userHelper;
    @Inject
    UserManager userManager;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.profile_layout, null);

        App.getComponent().inject(this);
        return view;
    }

    @Override
    public void onResume() {
        settingsToolbar.setBackgroundColor(getResources().getColor(R.color.colorPrimary));
        settingsToolbar.setTitle("");
        getParentActivity().getSupportActionBar().show();
        super.onResume();
    }
}
