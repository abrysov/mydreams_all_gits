package com.mydreams.android.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.text.Editable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.Toast;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.AppPreferences;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.manager.Authorization;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.Field;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnTextChanged;

public class RegFirstStageFragment extends BaseFragment {

    @Bind(R.id.user_mail)                  EditText mailEditText;
    @Bind(R.id.user_password)              EditText passwordEditText;
    @Bind(R.id.check_user_password)        EditText checkPasswordEditText;
    @Bind(R.id.btn_onward)                 Button btnOnward;
    @Bind(R.id.btn_back)                   ImageButton btnBack;
    @Bind(R.id.custom_view_email)          View customViewMail;
    @Bind(R.id.custom_view_password)       View customViewPassword;
    @Bind(R.id.custom_view_check_password) View customViewCheckPassword;
    @Bind(R.id.img_divider_mail)           ImageView dividerMail;
    @Bind(R.id.img_divider_password)       ImageView dividerPassword;
    @Bind(R.id.img_divider_confirm_password) ImageView dividerConfirmPassword;
    @Bind(R.id.vkontakte)                  ImageButton btnVk;
    @Bind(R.id.facebook)                   ImageButton btnFaceBook;
    @Bind(R.id.twitter)                     ImageButton btnTwitter;
    @Bind(R.id.instagram)                  ImageButton btnInstagram;

    private Bundle mBundle;
    private View view;
    private boolean isEmailNotValid;
    private boolean isPasswordNotValid;

    @Inject
    SharedPreferences preferences;
    @Inject
    Authorization authorization;
    @Inject
    UserHelper userHelper;
    @Inject
    UserManager userManager;
    @Inject
    AppPreferences appPreferences;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.reg_first_stage_layout, null);

        App.getComponent().inject(this);

        return view;
    }

    private void putUserMailPassword() {
        mBundle = new Bundle();
        mBundle.putString(Config.BUNDLE_USER_MAIL, mailEditText.getText().toString().trim());
        mBundle.putString(Config.BUNDLE_USER_PASSWORD, passwordEditText.getText().toString().trim());
    }

    private boolean checkIfUserHasEnteredEmail() {
        if (!mailEditText.getText().toString().equals("") && isEmailValid()) {
            return true;
        }
        return false;
    }

    private boolean checkIfUserHasEnteredPassword() {
        String password = passwordEditText.getText().toString();
        if (!password.equals("") && isPasswordValid()) {
            return true;
        }
        return false;
    }

    private boolean checkIfPasswordsEqual() {
        String confirmPassword = checkPasswordEditText.getText().toString();
        String password = passwordEditText.getText().toString().trim();

        if (password.equals(confirmPassword)) {
            return true;
        }
        return false;
    }

    @OnTextChanged(R.id.user_mail)
    public void changeEditEmail(Editable s) {
        if (isEmailValid()) {
            dividerMail.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            dividerMail.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnFocusChange(R.id.user_mail)
    public void focusChangeEmailEditText(View v, boolean hasFocus) {
        if (mailEditText.hasFocus()) {
            dividerMail.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            if (isEmailValid()) {
                dividerMail.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
            } else {
                dividerMail.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
            }
        }
    }

    @OnTextChanged(R.id.user_password)
    public void changeEditPassword(Editable s) {
        if(isPasswordValid()) {
            dividerPassword.setBackgroundColor(getResources().getColor(R.color.white));
            if (checkIfPasswordsEqual()) {
                dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
            }
        } else {
            dividerPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnFocusChange(R.id.user_password)
    public void focusChangePasswordEditText(View v, boolean hasFocus) {
        if (passwordEditText.hasFocus()) {
            dividerPassword.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            if (isPasswordValid()) {
                dividerPassword.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
            } else {
                dividerPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
            }
        }
    }

    @OnTextChanged(R.id.check_user_password)
    public void changeEditCheckPassword() {
        if (checkIfPasswordsEqual()) {
            dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnFocusChange(R.id.check_user_password)
    public void focusChangeConfirmPasswordEditText(View v, boolean hasFocus) {
        if (checkPasswordEditText.hasFocus()) {
            dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            if (checkIfPasswordsEqual()) {
                dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
            } else {
                dividerConfirmPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
            }
        }
    }

    private boolean isEmailValid() {
        boolean isValid = false;
        String email = mailEditText.getText().toString().trim();

        if(email.contains("@") && email.contains(".") && email.length() <= 255) {
            isValid = true;
            isEmailNotValid = false;
        }

        return isValid;
    }

    private boolean isPasswordValid() {
        boolean isValid = false;
        String password = passwordEditText.getText().toString().trim();

        if (password.length() > 5) {
            isValid = true;
            isPasswordNotValid = false;
        }
        return isValid;
    }

    @OnClick(R.id.btn_onward)
    public void onClickNextStageRegistration() {
        putUserMailPassword();
        if (checkIfUserHasEnteredEmail() && checkIfUserHasEnteredPassword() && checkIfPasswordsEqual()) {
            needOpenFragment(Config.FTYPE_REG_SECOND_STAGE, mBundle);
        } else {
            dividerPassword.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
            dividerConfirmPassword.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        hideKeyboard();
        getActivity().onBackPressed();
    }

    @OnClick(R.id.custom_view_email)
    public void onClickRequestFocusEditMail() {
        mailEditText.requestFocus();
        showKeyboard(mailEditText);
    }

    @OnClick(R.id.custom_view_password)
    public void onClickRequestFocusEditPassword() {
        passwordEditText.requestFocus();
        showKeyboard(passwordEditText);
    }

    @OnClick(R.id.custom_view_check_password)
    public void onClickRequestFocusConfirmEditPassword() {
        checkPasswordEditText.requestFocus();
        showKeyboard(checkPasswordEditText);
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

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        authorization.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onResume() {
        ButterKnife.bind(this, view);
        if (isEmailNotValid) {
            dividerMail.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
        }

        if (isPasswordNotValid) {
            dividerPassword.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
        }

        getParentActivity().getSupportActionBar().hide();
        getActivity().registerReceiver(backlightFieldsAtRegErrors, new IntentFilter(Config.IF_BACKLIGHT_FIELDS_REG_FIRST_STAGE));
        super.onResume();
    }

    private BroadcastReceiver backlightFieldsAtRegErrors = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getStringExtra(Field.EMAIL).equals(Field.EMAIL)) {
                isEmailNotValid = true;
            } else if (intent.getStringExtra(Field.PASSWORD).equals(Field.PASSWORD)) {
                isPasswordNotValid = true;
            }
        }
    };

    @Override
    public void onDestroy() {
        appPreferences.clearSavedRegData();
        ButterKnife.unbind(this);
        getActivity().unregisterReceiver(backlightFieldsAtRegErrors);
        super.onDestroy();
    }

    private void showNotificationIsNotNetwork() {
        Toast.makeText(getActivity(), getResources().getString(R.string.notification_internet_is_not_connection), Toast.LENGTH_SHORT).show();
    }
}
