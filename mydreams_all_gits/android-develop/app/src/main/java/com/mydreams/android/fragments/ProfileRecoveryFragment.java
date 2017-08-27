package com.mydreams.android.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageButton;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.manager.ProfileRecoveryManager;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 11.03.16.
 */
public class ProfileRecoveryFragment extends BaseFragment {

    @Bind(R.id.btn_back)             ImageButton btnBack;
    @Bind(R.id.btn_profile_recovery) Button btnProfileRecovery;

    @Inject
    ProfileRecoveryManager profileRecoveryManager;

    private Bundle mBundle;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.profile_recovery_layout, null);

        ButterKnife.bind(this, view);
        App.getComponent().inject(this);

        return view;
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        getActivity().onBackPressed();
    }

    @OnClick(R.id.btn_profile_recovery)
    public void onClickProfileRecovery() {
        recoveryProfile();
    }

    private void recoveryProfile() {
        profileRecoveryManager.recoveryProfile();
        profileRecoveryManager.setOnRecoveryProfileListener(new ProfileRecoveryManager.OnRecoveryProfileListener() {
            @Override
            public void complete() {
                mBundle = new Bundle();
                needOpenFragment(Config.FTYPE_REDIRECT_STATUS, mBundle);
            }

            @Override
            public void error(String errMsg) {
                showNotificationError(errMsg);
            }
        });
    }

    @Override
    public void onDestroy() {
        ButterKnife.unbind(this);
        super.onDestroy();
    }
}
