package com.mydreams.android.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.activities.ChangeEmail;
import com.mydreams.android.activities.ChangePassword;
import com.mydreams.android.activities.EditProfile;
import com.mydreams.android.components.SessionService;
import com.mydreams.android.components.SettingsToolbar;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 03.06.16.
 */
public class SettingsFragment extends BaseFragment {

    @Bind(R.id.btn_logout)
    TextView btnLogout;
    @Bind(R.id.change_password)
    TextView goToScreenChangePassword;
    @Bind(R.id.change_email)
    TextView goToScreenChangeEmail;
    @Bind(R.id.edit_profile)
    TextView goToScreenEditProfile;

    @Inject
    SessionService sessionService;
    @Inject
    SettingsToolbar settingsToolbar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.settings_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick(R.id.btn_logout)
    public void onClickLogout() {
        Intent intent = new Intent(Config.IF_LOGOUT_BROADCAST);
        getActivity().sendBroadcast(intent);
    }

    @OnClick(R.id.change_password)
    public void onClickGoToChangePassword() {
        Intent intent = new Intent(getActivity(), ChangePassword.class);
        startActivity(intent);
    }

    @OnClick(R.id.change_email)
    public void onClickGoToChangeEmail() {
        Intent intent = new Intent(getActivity(), ChangeEmail.class);
        startActivity(intent);
    }

    @OnClick(R.id.edit_profile)
    public void onClickGoToEditPassword() {
        Intent intent = new Intent(getActivity(), EditProfile.class);
        startActivity(intent);
    }

    @Override
    public void onResume() {
        settingsToolbar.setTitle(getResources().getString(R.string.setting_title_toolbar));
        settingsToolbar.setTextColor(getResources().getColor(R.color.text_color_grey));
        settingsToolbar.setColorToggle(getActivity().getResources().getColor(R.color.text_color_grey));
        settingsToolbar.setBackgroundColor(getResources().getColor(R.color.white));
        super.onResume();
    }

    @Override
    public void onDestroy() {
        settingsToolbar.setColorToggle(getActivity().getResources().getColor(R.color.white));
        settingsToolbar.setTextColor(getResources().getColor(R.color.white));
        super.onDestroy();
    }
}
