package com.mydreams.android.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.OnDatePickerListener;
import com.mydreams.android.components.SelectionSex;
import com.mydreams.android.models.Field;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;

/**
 * Created by mikhail on 14.03.16.
 */
public class RegSecondStageFragment extends BaseFragment implements OnDatePickerListener {

    @Bind(R.id.user_name)               EditText firstName;
    @Bind(R.id.user_last_name)          EditText lastName;
    @Bind(R.id.btn_back)                ImageButton btnBack;
    @Bind(R.id.date_picker_view)        View datePickerView;
    @Bind(R.id.btn_onward)              Button btnOnward;
    @Bind(R.id.picker_day)              TextView titleDay;
    @Bind(R.id.picker_month)            TextView titleMonth;
    @Bind(R.id.picker_year)             TextView titleYear;
    @Bind(R.id.girl)                    TextView selectGirl;
    @Bind(R.id.man)                     TextView selectMan;
    @Bind(R.id.custom_view_name)        View customViewName;
    @Bind(R.id.custom_view_last_name)   View customViewLasName;
    @Bind(R.id.img_divider_name)        ImageView dividerName;
    @Bind(R.id.img_divider_last_name)   ImageView dividerLastName;
    @Bind(R.id.divider_female)          View dividerFemale;
    @Bind(R.id.divider_male)            View dividerMale;

    private SelectionSex userGender;
    private Bundle mBundle;
    private boolean isSetDate = false;
    private int day;
    private String month;
    private int year;
    private View view;
    private boolean isFirstNameNotValid;
    private boolean isLastNameNotValid;

    @Inject
    SharedPreferences preferences;
    private String userBirthday;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.reg_second_stage_layout, null);

        setRetainInstance(true);

        App.getComponent().inject(this);

        if (savedInstanceState == null)
            mBundle = (Bundle) getArguments().clone();
        else
            mBundle = (Bundle) savedInstanceState.clone();

        checkIsSetData();

        return view;
    }

    private void checkIsSetData() {
        if (isSetDate) {
            setUserDate();
        }
    }

    @OnFocusChange(R.id.user_name)
    public void focusChangeEditUserName(View v, boolean hasFocus) {
        if (firstName.hasFocus()) {
            dividerName.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            if (checkIfUserHasEnteredName()) {
                dividerName.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
            } else {
                dividerName.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
            }
        }
    }

    @OnFocusChange(R.id.user_last_name)
    public void focusChangeEditUserLastName(View v, boolean hasFocus) {
        if (lastName.hasFocus()) {
            dividerLastName.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            dividerLastName.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
        }
    }

    private boolean checkIfUserHasEnteredName() {
        String name = firstName.getText().toString().trim();
        if (name.length() != 0) {
            return true;
        }
        return false;
    }

    private void showDatePickerDialog() {
        DatePickerFragment dialogDatePickerFragment = new DatePickerFragment();
        dialogDatePickerFragment.setCallback(this);
        dialogDatePickerFragment.setTargetFragment(this, 0);
        dialogDatePickerFragment.show(getActivity().getSupportFragmentManager(), "datePicker");
    }

    private void isSelectionSex() {
        if (userGender != null) {
            switch (userGender) {
                case MALE:
                    selectedMan();
                    break;
                case FEMALE:
                    selectedGirl();
                    break;
                default:
                    userGenderIsNotSelected();
                    break;
            }
        }
    }

    private void userGenderIsNotSelected() {
        selectGirl.setAlpha(0.5f);
        selectMan.setAlpha(0.5f);
    }

    private void selectedMan() {
        selectGirl.setAlpha(0.5f);
        selectMan.setAlpha(1);
        dividerMale.setBackgroundColor(getResources().getColor(R.color.white));
        dividerFemale.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
        userGender = SelectionSex.MALE;
    }

    private void selectedGirl() {
        selectMan.setAlpha(0.5f);
        selectGirl.setAlpha(1);
        dividerFemale.setBackgroundColor(getResources().getColor(R.color.white));
        dividerMale.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
        userGender = SelectionSex.FEMALE;
    }

    private void putUserData() {
        mBundle.putString(Config.BUNDLE_USER_NAME, firstName.getText().toString());
        mBundle.putString(Config.BUNDLE_USER_LAST_NAME, lastName.getText().toString());
        mBundle.putString(Config.BUNDLE_USER_GENDER, getUserGender());

        if (userBirthday != null && !userBirthday.isEmpty()) {
            mBundle.putString(Config.BUNDLE_USER_BIRTH_DAY, userBirthday);
        }
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        hideKeyboard();
        getActivity().onBackPressed();
    }

    @OnClick(R.id.date_picker_view)
    public void onClickShowDatePicker() {
        showDatePickerDialog();
    }

    @OnClick(R.id.girl)
    public void onClickSelectedGirl() {
        selectedGirl();
    }

    @OnClick(R.id.man)
    public void onClickSelectedMan() {
        selectedMan();
    }

    @OnClick(R.id.custom_view_name)
    public void onClickRequestFocusEditName() {
        firstName.requestFocus();
        showKeyboard(firstName);
    }

    @OnClick(R.id.custom_view_last_name)
    public void onClickRequestFocusEditLastName() {
        lastName.requestFocus();
        showKeyboard(lastName);
    }

    @OnClick(R.id.btn_onward)
    public void onClickNextStageRegistration() {
        putUserData();
        if (checkIfUserHasEnteredName()) {
            needOpenFragment(Config.FTYPE_REG_THIRD_STAGE, mBundle);
        } else if (!checkIfUserHasEnteredName()) {
            dividerName.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putAll(mBundle);
    }

    @Override
    public void onResume() {
        ButterKnife.bind(this, view);
        insertUserDateAndName();
        if (isFirstNameNotValid) {
            dividerName.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
            isFirstNameNotValid = false;
        }

        if (isLastNameNotValid) {
            dividerLastName.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
            isLastNameNotValid = false;
        }
        getActivity().registerReceiver(backlightFieldsAtRegErrors, new IntentFilter(Config.IF_BACKLIGHT_FIELDS_REG_SECOND_STAGE));
        super.onResume();
    }

    private void insertUserDateAndName() {
        String userName = preferences.getString(Config.BUNDLE_USER_NAME, "");
        String userLastName = preferences.getString(Config.BUNDLE_USER_LAST_NAME, "");
        day = preferences.getInt(Config.BUNDLE_USER_BIRTH_DAY, 0);
        month = preferences.getString(Config.BUNDLE_USER_BIRTH_MONTH, "");
        year = preferences.getInt(Config.BUNDLE_USER_BIRTH_YEAR, 0);

        firstName.setText(userName);
        lastName.setText(userLastName);
        titleDay.setText(String.valueOf(day == 0 ? getResources().getString(R.string.title_day) : day));
        titleMonth.setText(month.isEmpty() ? getResources().getString(R.string.title_month) : month);
        titleYear.setText(String.valueOf(year == 0 ? getResources().getString(R.string.title_year) : year));

        String savedFieldUserSex = preferences.getString(Config.BUNDLE_USER_GENDER, "");

        userGender = SelectionSex.valueOf(savedFieldUserSex.isEmpty() ? "FEMALE" : savedFieldUserSex);
        isSelectionSex();
    }

    private void setUserDate() {
        titleDay.setText(String.valueOf(day));
        titleYear.setText(String.valueOf(year));
        titleMonth.setText(month);
    }

    @Override
    public void setDate(int year, String month, int day, String dateFormat) {
        this.day = day;
        this.month = month;
        this.year = year;
        this.userBirthday = dateFormat;
        setUserDate();
        isSetDate = true;
    }

    private void saveUserDate() {
        preferences.edit().putString(Config.BUNDLE_USER_NAME, firstName.getText().toString()).apply();
        preferences.edit().putString(Config.BUNDLE_USER_LAST_NAME, lastName.getText().toString()).apply();
        preferences.edit().putInt(Config.BUNDLE_USER_BIRTH_DAY, day).apply();
        preferences.edit().putString(Config.BUNDLE_USER_BIRTH_MONTH, month).apply();
        preferences.edit().putInt(Config.BUNDLE_USER_BIRTH_YEAR, year).apply();
        preferences.edit().putString(Config.BUNDLE_USER_GENDER, userGender.toString()).apply();
    }

    @Override
    public void onPause() {
        saveUserDate();
        super.onPause();
    }

    @Override
    public void onDestroy() {
        saveUserDate();
        ButterKnife.unbind(this);
        getActivity().unregisterReceiver(backlightFieldsAtRegErrors);
        super.onDestroy();
    }

    private BroadcastReceiver backlightFieldsAtRegErrors = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getStringExtra(Field.FIRST_NAME).equals(Field.FIRST_NAME)) {
                isFirstNameNotValid = true;
            } else if (intent.getStringExtra(Field.LAST_NAME).equals(Field.LAST_NAME)) {
                isLastNameNotValid = true;
            }
        }
    };

    public String getUserGender() {
        if (userGender != null && userGender == SelectionSex.MALE) {
            return Field.MALE;
        } else {
            return Field.FEMALE;
        }
    }
}
