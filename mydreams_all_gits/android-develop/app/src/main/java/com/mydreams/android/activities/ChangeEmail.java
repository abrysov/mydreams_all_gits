package com.mydreams.android.activities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.util.TypedValue;
import android.view.Gravity;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.User;

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
public class ChangeEmail extends BaseActivity {

    @Bind(R.id.toolbar)
    Toolbar toolbar;
    @Bind(R.id.btn_send_changed_email)
    Button btnSendChangedEmail;
    @Bind(R.id.divider_below_edit_email)
    ImageView dividerBelowEditEmail;
    @Bind(R.id.edit_email)
    EditText editEmail;
    @Bind(R.id.user_email)
    TextView userEmail;
    @Bind(R.id.view_enter_email)
    LinearLayout viewEnterEmail;

    @Inject
    UserManager userManager;
    @Inject
    SharedPreferences preferences;
    @Inject
    NotificationSnackBar topSnackBar;
    @Inject
    UserHelper userHelper;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.change_email_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);

        setUserEmail();
    }

    private void setUserEmail() {
        userEmail.setText(getUserEmail());
    }

    private void changeEmail(Map<String, String> credentials) {
        userManager.changeEmail(credentials);
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
    }

    private String getUserEmail() {
        User user = userHelper.getUser();
        return user.getEmail();
    }

    private boolean isEmailValid() {
        boolean isValid = false;
        String email = editEmail.getText().toString().trim();

        if(email.contains("@") && email.contains(".") && email.length() <= 255) {
            isValid = true;
        }

        return isValid;
    }

    @OnFocusChange(R.id.edit_email)
    public void onFocusChangeEditEmail() {
        if (editEmail.hasFocus()) {
            dividerBelowEditEmail.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        }
    }

    @OnClick(R.id.view_enter_email)
    public void onClickFocusEnterEmail() {
        editEmail.requestFocus();
        showKeyboard(editEmail);
    }

    @OnTextChanged(R.id.edit_email)
    public void changeEditEmail(Editable s) {
        if (isEmailValid()) {
            dividerBelowEditEmail.setBackgroundColor(getResources().getColor(R.color.dreamer_toolbar_color_bg));
        } else {
            dividerBelowEditEmail.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @OnClick(R.id.btn_send_changed_email)
    public void onClickSendChangeEmail() {
        if(isEmailValid()) {
            Map<String, String> credentials = new HashMap<>();
            credentials.put(Field.EMAIL, editEmail.getText().toString().trim());
            changeEmail(credentials);
        } else {
            showNotification(getResources().getString(R.string.setting_notification_incorrect_email));
            dividerBelowEditEmail.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @Override
    protected void onResume() {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        setColorArrowToggle(toolbar, getResources().getColor(R.color.text_color_grey));
        super.onResume();
    }

    private void showNotification(String errMsg) {
        topSnackBar.setSnackBar(findViewById(R.id.relative), errMsg, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }
}
