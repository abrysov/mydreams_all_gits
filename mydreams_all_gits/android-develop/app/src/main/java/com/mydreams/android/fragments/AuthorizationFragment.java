package com.mydreams.android.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.manager.Authorization;
import com.mydreams.android.models.Field;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class AuthorizationFragment extends BaseFragment {

    @Bind(R.id.user_login)         EditText loginEditText;
    @Bind(R.id.user_password)      EditText passwordEditText;
    @Bind(R.id.txt_new_password)   TextView txtNewPassword;
    @Bind(R.id.btn_log_in)         Button btnLogIn;
    @Bind(R.id.btn_registration)   Button btnRegistration;
    @Bind(R.id.btn_clear_login)    ImageButton btnClearLogin;
    @Bind(R.id.btn_clear_password) ImageButton btnClearPassword;
    @Bind(R.id.vkontakte)          ImageButton btnVk;
    @Bind(R.id.facebook)           ImageButton btnFaceBook;
    @Bind(R.id.twitter)             ImageButton btnTwitter;
    @Bind(R.id.instagram)          ImageButton btnInstagram;

    @Bind(R.id.custom_view_login)    View customViewLogin;
    @Bind(R.id.custom_view_password) View customViewPassword;

    private GradientDrawable gdLogin;
    private GradientDrawable gdPassword;

    @Inject
    Authorization authorization;
    @Inject
    UserHelper userHelper;
    @Inject
    SharedPreferences preferences;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.auth_window, null);

        ButterKnife.bind(this, view);
        App.getComponent().inject(this);
        getBackgroundLoginAndPassword();

        return view;
    }

    private void getBackgroundLoginAndPassword() {
        gdLogin = (GradientDrawable) customViewLogin.getBackground();
        gdPassword = (GradientDrawable) customViewPassword.getBackground();
    }

    private boolean isEmailValid() {
        boolean isValid = false;
        String email = loginEditText.getText().toString().trim();

        if(email.contains("@") && email.contains(".") && email.length() <= 255) {
            isValid = true;
        }

        return isValid;
    }

    private boolean isPasswordValid() {
        boolean isValid = false;

        String password = passwordEditText.getText().toString().trim();

        if (password.length() > 5) {
            isValid = true;
        }

        return isValid;
    }

    private void showAuthError() {
        notificationAuthError();
        gdLogin.setColor(getResources().getColor(R.color.edit_text_not_valid));
        gdPassword.setColor(getResources().getColor(R.color.edit_text_not_valid));
    }

    @OnClick(R.id.btn_log_in)
    public void onClickLogIn() {
        if (isEmailValid() && isPasswordValid()) {
            authorization();
        } else {
            showAuthError();
        }
    }

    @OnClick(R.id.btn_registration)
    public void onClickRegistration() {
        needOpenFragment(Config.FTYPE_REG_FIRST_STAGE, null);
    }

    @OnClick(R.id.txt_new_password)
    public void onClickNewPassword() {
        needOpenFragment(Config.FTYPE_REDIRECT_PASSWORD, null);
    }

    @OnClick(R.id.btn_clear_login)
    public void onClickClearLogin() {
        loginEditText.setText("");
        btnClearLogin.setVisibility(View.GONE);
    }

    @OnClick(R.id.btn_clear_password)
    public void onClickClearPassword() {
        passwordEditText.setText("");
        btnClearPassword.setVisibility(View.GONE);
    }

    @OnClick(R.id.vkontakte)
    public void onClickAuthVkontakte() {
        if (isOnline()) {
            authorization.getVKToken(getActivity());
        } else {
            showNotificationIsNotNetwork();
        }
    }

    @OnClick(R.id.facebook)
    public void onClickAuthFacebook() {
        if (isOnline()) {
            authorization.getFacebookToken(getActivity());
        } else {
            showNotificationIsNotNetwork();
        }
    }

    @OnClick(R.id.twitter)
    public void onClickAuthTwitter() {
        if (isOnline()) {
            authorization.getTwitterToken(getActivity());
        } else {
            showNotificationIsNotNetwork();
        }
    }

    @OnClick(R.id.instagram)
    public void onClickAuthInstagram() {
        if (isOnline()) {
            authorization.getInstagramToken(getActivity());
        } else {
            showNotificationIsNotNetwork();
        }
    }

    @OnTextChanged(R.id.user_login)
    public void changeLoginText(Editable s) {
        if (s.length() > 0) {
            btnClearLogin.setVisibility(View.VISIBLE);

            if (isEmailValid()) {
                gdLogin.setColor(getResources().getColor(R.color.edit_text_valid));
            } else {
                gdLogin.setColor(getResources().getColor(R.color.edit_text_not_valid));
            }

        } else {
            btnClearLogin.setVisibility(View.GONE);
            gdLogin.setColor(getResources().getColor(R.color.edit_text_auth));
        }
    }

    @OnTextChanged(R.id.user_password)
    public void changePasswordText(Editable s) {
        if (s.length() > 0) {
            btnClearPassword.setVisibility(View.VISIBLE);

            if (isPasswordValid()) {
                gdPassword.setColor(getResources().getColor(R.color.edit_text_valid));
            } else {
                gdPassword.setColor(getResources().getColor(R.color.edit_text_not_valid));
            }

        } else {
            btnClearPassword.setVisibility(View.GONE);
            gdPassword.setColor(getResources().getColor(R.color.edit_text_auth));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        authorization.onActivityResult(requestCode, resultCode, data);
    }

    private void authorization() {
        authorization.authorization(getCredentials());
    }

    @Override
    public void onResume() {
        getParentActivity().getSupportActionBar().hide();
        getActivity().registerReceiver(openFragmentByUserStateBroadcast, new IntentFilter(Config.IF_OPEN_FRAGMENT_BY_USER_STATE));
        super.onResume();
    }

    private void notificationAuthError() {
        Toast.makeText(getActivity(), R.string.notification_err_auth, Toast.LENGTH_SHORT).show();
    }

    private Map<String, String> getCredentials() {
        String name = loginEditText.getText().toString();
        String password = passwordEditText.getText().toString();

        final Map<String, String> credentials = new HashMap<>();
        credentials.put(Field.GRANT_TYPE, "password");
        credentials.put(Field.USER_NAME, name);
        credentials.put(Field.PASSWORD, password);

        return credentials;
    }

    private BroadcastReceiver openFragmentByUserStateBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            openFragmentByUserState();
        }
    };
    
    private void openFragmentByUserState() {
        if (userHelper.userIsBlocked()) {
            needOpenFragment(Config.FTYPE_BLOCKED_USER, null);
        } else if (userHelper.userIsDeleted()) {
            needOpenFragment(Config.FTYPE_PROFILE_RECOVERY, null);
        } else {
            needOpenFragment(Config.FTYPE_PROFILE, null);
        }
    }

    private void setDefaultStateAuthFields() {
        gdLogin.setColor(getResources().getColor(R.color.edit_text_auth));
        gdPassword.setColor(getResources().getColor(R.color.edit_text_auth));
    }

    @Override
    public void onDestroy() {
        setDefaultStateAuthFields();
        ButterKnife.unbind(this);
        getActivity().unregisterReceiver(openFragmentByUserStateBroadcast);
        super.onDestroy();
    }

    private void showNotificationIsNotNetwork() {
        Toast.makeText(getActivity(), getResources().getString(R.string.notification_internet_is_not_connection), Toast.LENGTH_SHORT).show();
    }
}
