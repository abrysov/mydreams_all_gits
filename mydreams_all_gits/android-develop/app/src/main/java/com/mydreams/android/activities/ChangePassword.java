package com.mydreams.android.activities;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.Field;

import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnTextChanged;

/**
 * Created by mikhail on 30.06.16.
 */
public class ChangePassword extends BaseActivity {

    @Bind(R.id.toolbar)
    Toolbar toolbar;
    @Bind(R.id.view_enter_old_password)
    LinearLayout viewEnterOldPassword;
    @Bind(R.id.view_enter_new_password)
    LinearLayout viewEnterNewPassword;
    @Bind(R.id.view_enter_confirm_password)
    LinearLayout viewEnterConfirmPassword;
    @Bind(R.id.edit_old_password)
    EditText editOldPassword;
    @Bind(R.id.edit_new_password)
    EditText editNewPassword;
    @Bind(R.id.edit_confirm_password)
    EditText editConfirmPassword;
    @Bind(R.id.divider_below_edit_old_password)
    ImageView dividerBelowEditOldPassword;
    @Bind(R.id.divider_below_edit_new_password)
    ImageView dividerBelowEditNewPassword;
    @Bind(R.id.divider_below_edit_confirm_password)
    ImageView dividerBelowEditConfirmPassword;
    @Bind(R.id.btn_send_change_password)
    Button btnSendChangePassword;

    @Inject
    UserManager userManager;
    @Inject
    NotificationSnackBar topSnackBar;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.change_password_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
    }

    private void changePassword(Map<String, Object> credentials) {
        userManager.setChangeCredentialsListener(new UserManager.OnChangeCredentialsListener() {
            @Override
            public void complete() {
                finish();
            }

            @Override
            public void error(String errMsg) {
                showNotification(errMsg);
            }
        });
        userManager.changePassword(credentials);
    }

    @OnClick(R.id.view_enter_old_password)
    public void onClickViewEnterOldPassword() {
        editOldPassword.requestFocus();
        showKeyboard(editOldPassword);
    }

    @OnClick(R.id.view_enter_new_password)
    public void onClickViewEnterNewPassword() {
        editNewPassword.requestFocus();
        showKeyboard(editNewPassword);
    }

    @OnClick(R.id.view_enter_confirm_password)
    public void onClickViewEnterConfirmPassword() {
        editConfirmPassword.requestFocus();
        showKeyboard(editConfirmPassword);
    }

    @OnClick(R.id.btn_send_change_password)
    public void onClickSendChangePassword() {
        Map<String, Object> credentials = new HashMap<>();
        String oldPassword = editOldPassword.getText().toString();
        String newPassword = editNewPassword.getText().toString();
        String confirmPassword = editConfirmPassword.getText().toString();
        if (isOldPasswordValid() && isNewPasswordValid() && checkIfPasswordsEqual()) {
            credentials.put(Field.CURRENT_PASSWORD, oldPassword.trim());
            credentials.put(Field.PASSWORD, newPassword.trim());
            credentials.put(Field.PASSWORD_CONFIRMATION, confirmPassword.trim());
            changePassword(credentials);
        } else {
            showError();
        }
    }

    private void showError() {
        String error = null;

        if (!checkIfPasswordsEqual()) {
            error = getResources().getString(R.string.setting_notification_not_confirm_password);
            setDividerColor(dividerBelowEditConfirmPassword, false, false);
        }

        if (!isNewPasswordValid()) {
            error = getResources().getString(R.string.setting_notification_incorrect_new_password);
            setDividerColor(dividerBelowEditNewPassword, false, false);
        }

        if (!isOldPasswordValid()) {
            error = getResources().getString(R.string.setting_notification_incorrect_password);
            setDividerColor(dividerBelowEditOldPassword, false, isOldPasswordValid());
        }

        if (error != null) {
            showNotification(error);
        }
    }

    @OnTextChanged(R.id.edit_new_password)
    public void changeEditNewPassword(Editable s) {
        if (s.length() > 5) {
            dividerBelowEditNewPassword.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        } else {
            dividerBelowEditNewPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnTextChanged(R.id.edit_confirm_password)
    public void changeEditConfirmPassword(Editable s) {
        if (checkIfPasswordsEqual()) {
            dividerBelowEditConfirmPassword.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        } else {
            dividerBelowEditConfirmPassword.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    private void setDividerColor(ImageView imageView, boolean inFocus, boolean isValid) {
        if (inFocus) {
            imageView.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        } else if (isValid) {
            imageView.setBackgroundColor(getResources().getColor(R.color.bg_divider_dream_grey));
        } else {
            imageView.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnFocusChange(R.id.edit_old_password)
    public void onFocusChangeEditOldPassword(View v, boolean hasFocus) {
        setDividerColor(dividerBelowEditOldPassword, hasFocus, true);
    }

    @OnFocusChange(R.id.edit_new_password)
    public void onFocusChangeEditNewPassword(View v, boolean hasFocus) {
        setDividerColor(dividerBelowEditNewPassword, hasFocus, isNewPasswordValid());
    }

    private boolean isOldPasswordValid() {
        String oldPassword = editOldPassword.getText().toString().trim();
        if (oldPassword.length() != 0) {
            return true;
        }
        return false;
    }

    private boolean isNewPasswordValid() {
        String newPassword = editNewPassword.getText().toString().trim();
        if (newPassword.length() > 5) {
            return true;
        }
        return false;
    }

    private boolean checkIfPasswordsEqual() {
        String password = editNewPassword.getText().toString().trim();
        String confirmPassword = editConfirmPassword.getText().toString().trim();

        if (password.equals(confirmPassword) && password.length() != 0) {
            return true;
        }
        return false;
    }

    @OnFocusChange(R.id.edit_confirm_password)
    public void onFocusChangeEditConfirmPassword(View v, boolean hasFocus) {
        setDividerColor(dividerBelowEditConfirmPassword, hasFocus, checkIfPasswordsEqual());
    }

    @Override
    protected void onResume() {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        setColorArrowToggle(toolbar, getResources().getColor(R.color.text_color_grey));
        super.onResume();
    }

    private void showNotification(String text) {
        topSnackBar.setSnackBar(findViewById(R.id.linearLayout), text, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }
}
