package com.mydreams.android.activities;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.net.Uri;
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
import android.widget.TextView;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.components.OnDatePickerListener;
import com.mydreams.android.components.SelectionPhotoDialog;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.fragments.DatePickerFragment;
import com.mydreams.android.manager.UserManager;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.User;
import com.mydreams.android.utils.BitmapUtils;
import com.mydreams.android.utils.CustomDateUtils;
import com.squareup.picasso.Picasso;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import butterknife.OnTextChanged;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by mikhail on 30.06.16.
 */
public class EditProfile extends BaseActivity implements OnDatePickerListener {

    @Bind(R.id.toolbar)                   Toolbar toolbar;
    @Bind(R.id.btn_send_change_info_user) Button btnSendChangedInfoUser;
    @Bind(R.id.user_name)                 EditText userName;
    @Bind(R.id.user_last_name)            EditText userLastName;
    @Bind(R.id.picker_day)                TextView pickerDay;
    @Bind(R.id.picker_month)              TextView pickerMonth;
    @Bind(R.id.picker_year)               TextView pickerYear;
    @Bind(R.id.female)                    TextView genderFemale;
    @Bind(R.id.divider_below_female)      ImageView dividerBelowFemale;
    @Bind(R.id.male)                      TextView genderMale;
    @Bind(R.id.divider_below_male)        ImageView dividerBelowMale;
    @Bind(R.id.user_country)              TextView userCountry;
    @Bind(R.id.user_city)                 TextView userCity;
    @Bind(R.id.photo_user)                CircleImageView photoUser;
    @Bind(R.id.divider_below_edit_last_name)   ImageView dividerBelowEditLastName;
    @Bind(R.id.divider_below_edit_name)        ImageView dividerBelowEditName;

    private String changeUserGender;
    private Uri selectedImageURI;
    private String birthday;
    private File photoFile;
    private User user;
    private int countryId;
    private int cityId;

    @Inject
    NotificationSnackBar topSnackBar;
    @Inject
    SelectionPhotoDialog selectionPhotoDialog;
    @Inject
    UserHelper userHelper;
    @Inject
    SharedPreferences preferences;
    @Inject
    UserManager userManager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.profile_edit_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
        selectionPhotoDialog.init(this);
        fillingUserData();
    }

    @OnClick(R.id.btn_send_change_info_user)
    public void onClickSendChangeInfoUser() {
        Map<String, Object> credentials = new HashMap<>();
        credentials.put(Field.ID, user.getUserId());
        credentials.put(Field.FIRST_NAME, userName.getText().toString().trim());
        credentials.put(Field.LAST_NAME, userLastName.getText().toString().trim());
        credentials.put(Field.GENDER, changeUserGender);
        credentials.put(Field.AVATAR, photoFile);
        credentials.put(Field.BIRTHDAY, getUserBirthday());
        credentials.put(Field.COUNTRY_ID, getCountryId());
        credentials.put(Field.CITY_ID, getCityId());
        credentials.put(Field.STATUS, getUserStatus());
        updateProfile(credentials);
    }

    private String getUserStatus() {
        if (user.getStatusUser() != null) {
            return user.getStatusUser();
        }
        return null;
    }

    private void updateProfile(Map<String, Object> credentials) {
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

        if (isNameValid()) {
            userManager.updateProfile(credentials);
        } else {
            showNotification(getResources().getString(R.string.setting_notification_empty_name));
        }
    }

    private int getCountryId() {
        if (user.getCountry() != null) {
            return (int) user.getCountry().getId();
        }
        return countryId;
    }

    private int getCityId() {
        if (user.getCity() != null) {
            return user.getCity().getCityId();
        }
        return cityId;
    }

    private String getUserLastName() {
        if (user.getLastName() != null) {
            return user.getLastName();
        }
        return null;
    }

    private String getUserBirthday() {
        if (birthday == null) {
            return user.getBirthday() == null ? null : user.getBirthday();
        } else {
            return birthday;
        }
    }

    private boolean isNameValid() {
        String name = userName.getText().toString().trim();
        if (name.length() != 0) {
            return true;
        }
        return false;
    }

    @OnFocusChange(R.id.user_name)
    public void onChangeFocusEditName(View v, boolean hasFocus) {
        setDividerColor(dividerBelowEditName, hasFocus, isNameValid());
    }

    @OnFocusChange(R.id.user_last_name)
    public void onChangeFocusEditLastName(View v, boolean hasFocus) {
        setDividerColor(dividerBelowEditLastName, hasFocus, true);
    }

    @OnTextChanged(R.id.user_name)
    public void onChangeUserName(Editable s) {
        if (s.length() == 0) {
            setDividerColor(dividerBelowEditName, false, false);
        } else if (userName.hasFocus()) {
            setDividerColor(dividerBelowEditName, true, isNameValid());
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

    private void fillingUserData() {
        user = userHelper.getUser();
        String month = null;
        String day = null;
        String year = null;
        if (user.getBirthday() != null) {
            month = CustomDateUtils.getMonth(user.getBirthday());
            day = CustomDateUtils.getDay(user.getBirthday());
            year = CustomDateUtils.getYear(user.getBirthday());
        }
        Picasso.with(this).load(user.getAvatar().getLargeUrl()).into(photoUser);
        userName.setText(user.getFirstName());
        userLastName.setText(getUserLastName());
        pickerMonth.setText(month == null ? getResources().getString(R.string.title_month) : month);
        pickerDay.setText(day == null ? getResources().getString(R.string.title_day) : day);
        pickerYear.setText(year == null ? getResources().getString(R.string.title_year) : year);
        setUserGender(user);
        userCity.setText(getCity(user));
        userCountry.setText(getCountry(user));
    }

    private void setUserGender(User user) {
        if (user.getGender().equals(Field.MALE)) {
            changeUserGender = Field.MALE;
            selectedMale();
        } else {
            changeUserGender = Field.FEMALE;
            selectedFemale();
        }
    }

    private String getCity(User user) {
        if (user.getCity() != null) {
            return user.getCity().getCityName();
        } else {
            return getResources().getString(R.string.setting_no_selected_location);
        }
    }

    private String getCountry(User user) {
        if (user.getCountry() != null) {
            return user.getCountry().getNameCountry();
        } else {
            return getResources().getString(R.string.setting_no_selected_location);
        }
    }

    @OnClick({R.id.picker_day, R.id.picker_month, R.id.picker_year})
    public void onClickShowDatePicker() {
        showDatePickerDialog();
    }

    @OnClick(R.id.female)
    public void onSelectedFemale() {
        selectedFemale();
    }

    @OnClick(R.id.male)
    public void onSelectedMale() {
        selectedMale();
    }

    @OnClick(R.id.user_country)
    public void selectedCountry() {
        Intent intent = new Intent(this, SelectionLocation.class);
        startActivity(intent);
    }

    @OnClick(R.id.user_city)
    public void selectedCity() {
        if (userCountry.getText().length() != 0) {
            Intent intent = new Intent(this, SelectionLocality.class);
            intent.putExtra(Config.BUNDLE_COUNTRY_ID, countryId);
            startActivity(intent);
        }
    }

    private void selectedFemale() {
        dividerBelowFemale.setBackgroundColor(getResources().getColor(R.color.tabwidget_bottom_line_color_blue));
        dividerBelowMale.setBackgroundColor(getResources().getColor(R.color.bg_divider_dream_grey));
        genderMale.setTextColor(getResources().getColor(R.color.bg_divider_dream_grey));
        genderFemale.setTextColor(getResources().getColor(R.color.grey));
    }

    private void selectedMale() {
        dividerBelowFemale.setBackgroundColor(getResources().getColor(R.color.bg_divider_dream_grey));
        dividerBelowMale.setBackgroundColor(getResources().getColor(R.color.tabwidget_bottom_line_color_blue));
        genderFemale.setTextColor(getResources().getColor(R.color.bg_divider_dream_grey));
        genderMale.setTextColor(getResources().getColor(R.color.grey));
    }

    private void showDatePickerDialog() {
        DatePickerFragment dialogDatePickerFragment = new DatePickerFragment();
        dialogDatePickerFragment.setCallback(this);
        dialogDatePickerFragment.show(getSupportFragmentManager(), "datePicker");
    }

    @OnClick(R.id.photo_user)
    public void onClickSelectedPhoto() {
        selectionPhotoDialog.createDialog();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode != RESULT_CANCELED) {
            switch (requestCode) {
                case Config.REQUEST_CAMERA:
                    setPhotoOfCamera();
                    break;
                case Config.REQUEST_GALLERY:
                    setPhotoOfGallery(data);
                    break;
                case CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE:
                    setCropPicture(data);
                    break;
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void setCropPicture(Intent data) {
        CropImage.ActivityResult result = CropImage.getActivityResult(data);
        Uri resultUri = result.getUri();
        String pathPhoto = BitmapUtils.getRealPathFromURI(resultUri, this);
        photoFile = new File(pathPhoto);
        Bitmap bitmap = BitmapUtils.decodeSampledBitmapFromResource(pathPhoto, Config.PHOTO_DECODE_WIDTH, Config.PHOTO_DECODE_HEIGHT);
        photoUser.setImageBitmap(bitmap);
    }

    private void setPhotoOfCamera() {
        String originalPath = preferences.getString(Config.ORIGINAL_PATH_IMG_CAMERA, "");
        selectionPhotoDialog.scanGallery(Uri.fromFile(new File(originalPath)));
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(originalPath)));
    }

    private void setPhotoOfGallery(Intent data) {
        selectedImageURI = data.getData();
        String imagePath = BitmapUtils.getRealPathFromURI(selectedImageURI, this);
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(imagePath)));
    }

    @Override
    protected void onResume() {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        setColorArrowToggle(toolbar, getResources().getColor(R.color.text_color_grey));
        registerReceiver(getCountryIdBroadcast, new IntentFilter(Config.IF_GET_COUNTRY_ID));
        registerReceiver(getCityIdBroadcast, new IntentFilter(Config.IF_GET_CITY_ID));
        super.onResume();
    }

    @Override
    public void setDate(int year, String month, int day, String dateFormat) {
        pickerDay.setText(String.valueOf(day));
        pickerMonth.setText(month);
        pickerYear.setText(String.valueOf(year));
        birthday = dateFormat;
    }

    private BroadcastReceiver getCountryIdBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            countryId = intent.getIntExtra(Config.BUNDLE_COUNTRY_ID, 0);
            String countryName = intent.getStringExtra(Config.BUNDLE_COUNTRY);
            userCountry.setText(countryName);
        }
    };

    private BroadcastReceiver getCityIdBroadcast = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            cityId = intent.getIntExtra(Config.BUNDLE_CITY_ID, 0);
            String cityName = intent.getStringExtra(Config.BUNDLE_CITY);
            userCity.setText(cityName);
        }
    };

    @Override
    protected void onDestroy() {
        unregisterReceiver(getCountryIdBroadcast);
        unregisterReceiver(getCityIdBroadcast);
        super.onDestroy();
    }

    private void showNotification(String text) {
        topSnackBar.setSnackBar(findViewById(R.id.linear), text, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }
}
