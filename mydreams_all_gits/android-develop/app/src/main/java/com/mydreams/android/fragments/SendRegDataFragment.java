package com.mydreams.android.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.manager.AuthorizationManager;
import com.mydreams.android.manager.RegistrationManager;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.Field;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import at.grabner.circleprogress.CircleProgressView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by mikhail on 12.07.16.
 */
public class SendRegDataFragment extends BaseFragment {

    @Bind(R.id.circle_progress_bar)
    CircleProgressView circularProgressBar;

    private Bundle mBundle;

    @Inject
    UserManager userManager;
    @Inject
    RegistrationManager registrationManager;
    @Inject
    AuthorizationManager authorizationManager;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.send_reg_data_layout, null);

        setRetainInstance(true);

        if (savedInstanceState == null)
            mBundle = (Bundle) getArguments().clone();
        else
            mBundle = (Bundle) savedInstanceState.clone();

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);

        registration();

        return view;
    }

    private Map<String, Object> getCredentialsReg() {
        int countryId = mBundle.getInt(Config.BUNDLE_COUNTRY_ID);
        int cityId = mBundle.getInt(Config.BUNDLE_CITY_ID);
        Map<String, Object> credentials = new HashMap<>();
        credentials.put(Field.EMAIL, mBundle.getString(Config.BUNDLE_USER_MAIL));
        credentials.put(Field.PASSWORD, mBundle.getString(Config.BUNDLE_USER_PASSWORD));
        credentials.put(Field.GENDER, mBundle.getString(Config.BUNDLE_USER_GENDER));
        credentials.put(Field.FIRST_NAME, mBundle.getString(Config.BUNDLE_USER_NAME));
        credentials.put(Field.LAST_NAME, mBundle.getString(Config.BUNDLE_USER_LAST_NAME));
        credentials.put(Field.BIRTHDAY, getUserBirthday(mBundle.getString(Config.BUNDLE_USER_BIRTH_DAY)));
        credentials.put(Field.COUNTRY_ID, countryId);
        credentials.put(Field.CITY_ID, cityId);
        credentials.put(Field.PHONE, mBundle.getString(Config.BUNDLE_USER_PHONE));
        return credentials;
    }

    private String getUserBirthday(String birthday) {
        if (birthday != null) {
            return birthday;
        }
        return "";
    }

    private Map<String, Object> getAvatarParams() {
        Map<String, Object> avatarParams = (Map<String, Object>) mBundle.getSerializable(Config.INTENT_MAP_PARAMS_AVATAR);
        return avatarParams;
    }

    private Map<String, String> getCredentialsAuth() {
        Map<String, String> credentials = new HashMap<>();
        credentials.put(Field.GRANT_TYPE, "password");
        credentials.put(Field.USER_NAME, mBundle.getString(Config.BUNDLE_USER_MAIL));
        credentials.put(Field.PASSWORD, mBundle.getString(Config.BUNDLE_USER_PASSWORD));
        return credentials;
    }

    private void registration() {
        circularProgressBar.setValueAnimated(0);
        registrationManager.setSendRegDataListener(new RegistrationManager.OnSendRegDataListener() {
            @Override
            public void complete() {
                circularProgressBar.setValueAnimated(25);
                authorization();
            }

            @Override
            public void error(String errMsg) {
                sendBroadcastErrReg(errMsg);
                getFragmentManager().popBackStack();
            }
        });
        registrationManager.sendRegData(getCredentialsReg());
    }

    private void sendBroadcastErrReg(String errMsg) {
        Intent intent = new Intent(Config.IF_SHOW_NOTIFICATION_REG_ERR);
        intent.putExtra(Field.ERRORS, errMsg);
        getActivity().sendBroadcast(intent);
    }

    private void createAvatar() {
        circularProgressBar.setValueAnimated(60);
        userManager.setCreateAvatarListener(new UserManager.OnCreateAvatarListener() {
            @Override
            public void complete() {
                circularProgressBar.setValueAnimated(75);
                loadUserInfo();
            }

            @Override
            public void error(String errMsg) {
                sendBroadcastErrReg(errMsg);
                getActivity().onBackPressed();
            }
        });
        userManager.createAvatar(getAvatarParams());
    }

    private void authorization() {
        final Map<String, Object> avatar = getAvatarParams();
        authorizationManager.needLoadProfile(false);
        authorizationManager.setAuthListener(new AuthorizationManager.OnAuthListener() {
            @Override
            public void complete() {
                circularProgressBar.setValueAnimated(50);
                if (avatar.size() != 0) {
                    createAvatar();
                } else {
                    loadUserInfo();
                }
            }

            @Override
            public void error(String errMsg) {
                sendBroadcastErrReg(errMsg);
                getActivity().onBackPressed();
            }
        });
        authorizationManager.authorization(getCredentialsAuth());
    }

    private void loadUserInfo() {
        circularProgressBar.setValueAnimated(90);
        userManager.setUserSaveListener(new UserManager.OnUserSaveListener() {
            @Override
            public void complete() {
                circularProgressBar.setValueAnimated(100);
                new Handler().post(new Runnable() {
                    @Override
                    public void run() {
                        Intent intent = new Intent(Config.IF_OPEN_FRAGMENT_BY_USER_STATE);
                        getActivity().sendBroadcast(intent);
                    }
                });
            }

            @Override
            public void error(String errMsg) {
                sendBroadcastErrReg(errMsg);
                getActivity().onBackPressed();
            }
        });
        userManager.loadUserInfo();
    }
}
