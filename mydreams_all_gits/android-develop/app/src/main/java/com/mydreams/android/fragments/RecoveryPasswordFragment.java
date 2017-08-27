package com.mydreams.android.fragments;

import android.graphics.drawable.GradientDrawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.manager.RecoveryPasswordManager;
import com.mydreams.android.models.Field;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 03.03.16.
 */
public class RecoveryPasswordFragment extends BaseFragment {

    @Bind(R.id.btn_back) ImageButton btnBack;
    @Bind(R.id.user_mail) EditText editMail;
    @Bind(R.id.btn_profile_recovery) Button btnRedirectPassword;
    @Bind(R.id.custom_view_login)    View customViewEmail;

    private Bundle mBundle;
    private GradientDrawable gdEmail;

    @Inject
    RecoveryPasswordManager recoveryPasswordManager;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.redirect_layout, null);

        ButterKnife.bind(this, view);

        App.getComponent().inject(this);
        getBackgroundEmail();
        hideKeyboardPressedEnter(editMail);

        return view;
    }

    private void getBackgroundEmail() {
        gdEmail = (GradientDrawable) customViewEmail.getBackground();
    }

    private boolean isEmailValid() {
        boolean isValid = false;
        String email = editMail.getText().toString().trim();

        if(email.contains("@") && email.contains(".") && email.length() <= 255) {
            isValid = true;
        }

        return isValid;
    }

    @OnTextChanged(R.id.user_mail)
    public void changeLoginText(Editable s) {
        if (s.length() > 0) {
            if (isEmailValid()) {
                gdEmail.setColor(getResources().getColor(R.color.edit_text_valid));
            } else {
                gdEmail.setColor(getResources().getColor(R.color.edit_text_not_valid));
            }

        } else {
            gdEmail.setColor(getResources().getColor(R.color.edit_text_auth));
        }
    }

    private void putEmailUser() {
        mBundle = new Bundle();
        String userEmail = editMail.getText().toString();
        mBundle.putString(Config.BUNDLE_USER_MAIL, userEmail);
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        hideKeyboard();
        getActivity().onBackPressed();
    }

    @OnClick(R.id.btn_profile_recovery)
    public void onClickSendRecoveryPassword() {
        putEmailUser();
        recoveryPassword();
    }

    private void recoveryPassword() {
        recoveryPasswordManager.setOnRecoveryPasswordListener(new RecoveryPasswordManager.OnRecoveryPasswordListener() {
            @Override
            public void complete() {
                needOpenFragment(Config.FTYPE_REDIRECT_STATUS, mBundle);
            }

            @Override
            public void error(String errMsg) {
                showNotificationError(errMsg);
            }
        });
        recoveryPasswordManager.recoveryPassword(getEmailUser());
    }

    public Map<String, String> getEmailUser() {
        final String email = editMail.getText().toString();
        final Map<String, String> userEmail = new HashMap<>();
        userEmail.put(Field.EMAIL, email);

        return userEmail;
    }

    @Override
    public void onDestroy() {
        gdEmail.setColor(getResources().getColor(R.color.edit_text_auth));
        ButterKnife.unbind(this);
        super.onDestroy();
    }
}
