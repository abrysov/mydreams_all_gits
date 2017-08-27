package com.mydreams.android.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.components.SelectionPhotoDialog;
import com.mydreams.android.models.Field;
import com.mydreams.android.utils.BitmapUtils;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnFocusChange;
import de.hdodenhof.circleimageview.CircleImageView;

/**
 * Created by mikhail on 15.03.16.
 */
public class RegThirdStageFragment extends BaseFragment {

    @Bind(R.id.btn_back) ImageButton btnBack;
    @Bind(R.id.user_phone) EditText userPhoneNumber;
    @Bind(R.id.user_country) TextView userLocation;
    @Bind(R.id.txt_agreement) TextView txtAgreement;
    @Bind(R.id.photo_user) CircleImageView userPhoto;
    @Bind(R.id.btn_add_photo) ImageButton btnAddPhoto;
    @Bind(R.id.btn_end_registration) Button btnEndRegistration;
    @Bind(R.id.circle_photo_layout) RelativeLayout circlePhotoLayout;
    @Bind(R.id.custom_view_phone) View customViewPhone;
    @Bind(R.id.custom_view_country) View customViewCountry;
    @Bind(R.id.img_divider_phone) ImageView dividerPhone;
    @Bind(R.id.img_divider_location) ImageView dividerLocation;

    private Bundle mBundle;
    private Bitmap photo;
    private Uri selectedImageURI;
    private Map<String, Object> paramsRequest;
    private File originalFile;
    private File croppedFile;
    private View view;
    private int countryId;
    private int cityId;
    private boolean isPhoneNumberNotValid;

    @Inject
    SelectionPhotoDialog selectionPhotoDialog;
    @Inject
    SharedPreferences preferences;
    @Inject
    NotificationSnackBar topSnackBar;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.reg_third_stage_layout, null);

        setRetainInstance(true);

        if (savedInstanceState == null)
            mBundle = (Bundle) getArguments().clone();
        else
            mBundle = (Bundle) savedInstanceState.clone();

        App.getComponent().inject(this);

        selectionPhotoDialog.init(getActivity());
        initMapParams();
        return view;
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
    }

    private void insertSavedDataUser() {
        String phone = preferences.getString(Config.BUNDLE_USER_PHONE, "");
        String location = preferences.getString(Config.BUNDLE_USER_LOCATION, "");
        countryId = preferences.getInt(Config.BUNDLE_COUNTRY_ID, 0);
        cityId = preferences.getInt(Config.BUNDLE_CITY_ID, 0);

        userPhoneNumber.setText(phone);
        userLocation.setText(location);
        photo = BitmapUtils.decodeBase64(preferences.getString(Config.BUNDLE_USER_PHOTO, ""));
        String originalPathImg = preferences.getString(Config.ORIGINAL_PATH_IMG, "");
        String croppedPathImg = preferences.getString(Config.CROPPED_PATH_IMG, "");
        originalFile = new File(originalPathImg);
        croppedFile = new File(croppedPathImg);
        paramsRequest.put(Field.CROPPED_FILE, croppedFile);
        paramsRequest.put(Field.FILE, originalFile);

        if (originalFile != null) {
            paramsRequest.put(Field.CROP_X, preferences.getInt(Config.BUNDLE_CROP_X, 0));
            paramsRequest.put(Field.CROP_Y, preferences.getInt(Config.BUNDLE_CROP_Y, 0));
            paramsRequest.put(Field.CROP_WIDTH, preferences.getInt(Config.BUNDLE_CROP_WIDTH, 0));
            paramsRequest.put(Field.CROP_HEIGHT, preferences.getInt(Config.BUNDLE_CROP_HEIGHT, 0));
        }

        if (photo == null) {
            circlePhotoLayout.setVisibility(View.GONE);
        } else {
            hideImageEmptyPhoto();
            userPhoto.setImageBitmap(photo);
        }
    }

    @OnFocusChange(R.id.user_phone)
    public void focusChangeEditPhone(View v, boolean hasFocus) {
        if (userPhoneNumber.hasFocus()) {
            dividerPhone.setBackgroundColor(getResources().getColor(R.color.white));
        } else {
            dividerPhone.setBackgroundColor(getResources().getColor(R.color.grey_extra_light));
        }
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        hideKeyboard();
        getActivity().onBackPressed();
    }

    @OnClick(R.id.txt_agreement)
    public void onClickAgreement() {
        needOpenFragment(Config.FTYPE_AGREEMENT, null);
    }

    @OnClick({R.id.photo_user, R.id.btn_add_photo, R.id.circle_photo_layout})
    public void onClickSelectedPhoto() {
        selectionPhotoDialog.createDialog();
    }

    @OnClick(R.id.btn_end_registration)
    public void onClickEndRegistration() {
        putRegData();
        new Handler().post(new Runnable() {
            @Override
            public void run() {
                needOpenFragment(Config.FTYPE_SEND_REG_DATA, mBundle);
            }
        });
    }

    @OnClick(R.id.custom_view_phone)
    public void onClickRequestFocusEditPhone() {
        userPhoneNumber.requestFocus();
        showKeyboard(userPhoneNumber);
    }

    @OnClick({R.id.custom_view_country, R.id.user_country})
    public void onClickRequestFocusEditCountry() {
        hideKeyboard();
        needOpenFragment(Config.FTYPE_SELECTION_COUNTRY, null);
    }

    @Override
    public void onResume() {
        ButterKnife.bind(this, view);
        insertSavedDataUser();
        if (isPhoneNumberNotValid) {
            dividerPhone.setBackgroundColor(getActivity().getResources().getColor(R.color.snackbar_bg_color));
            isPhoneNumberNotValid = false;
        }
        getActivity().registerReceiver(onUserCountryChanged, new IntentFilter(Config.IF_USER_COUNTRY_CHANGED));
        getActivity().registerReceiver(showNotificationError, new IntentFilter(Config.IF_SHOW_NOTIFICATION_REG_ERR));
        getActivity().registerReceiver(backlightFieldsAtRegErrors, new IntentFilter(Config.IF_BACKLIGHT_FIELDS_REG_THIRD_STAGE));
        super.onResume();
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
        getActivity().unregisterReceiver(onUserCountryChanged);
        getActivity().unregisterReceiver(backlightFieldsAtRegErrors);
        getActivity().unregisterReceiver(showNotificationError);
        super.onDestroy();
    }

    private void hideImageEmptyPhoto() {
        btnAddPhoto.setVisibility(View.GONE);
        circlePhotoLayout.setVisibility(View.VISIBLE);
    }

    private void saveUserDate() {
        preferences.edit().putString(Config.BUNDLE_USER_PHONE, userPhoneNumber.getText().toString()).apply();
        preferences.edit().putString(Config.BUNDLE_USER_LOCATION, userLocation.getText().toString()).apply();
        preferences.edit().putInt(Config.BUNDLE_COUNTRY_ID, countryId).apply();
        preferences.edit().putInt(Config.BUNDLE_CITY_ID, cityId).apply();
    }

    private void savePhoto(Bitmap photo) {
        preferences.edit().putString(Config.BUNDLE_USER_PHOTO, BitmapUtils.encodeToBase64(photo)).apply();
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode != getActivity().RESULT_CANCELED) {
            switch (requestCode) {
                case Config.REQUEST_CAMERA:
                    setPhotoOfCamera();
                    break;
                case Config.REQUEST_GALLERY:
                    setPhotoOfGallery(data);
                    break;
                case CropImage.CROP_IMAGE_ACTIVITY_REQUEST_CODE:
                    hideImageEmptyPhoto();
                    setCropPicture(data);
                    break;
            }
        } else {
            if (userPhoto.getVisibility() != View.VISIBLE) {
                btnAddPhoto.setVisibility(View.VISIBLE);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void setCropPicture(Intent data) {
        CropImage.ActivityResult result = CropImage.getActivityResult(data);
        setCropImageSize(result);
        Uri resultUri = result.getUri();
        String path = BitmapUtils.getRealPathFromURI(resultUri, getActivity());
        savePathCroppedImg(path);
        croppedFile = new File(path);
        paramsRequest.put(Field.CROPPED_FILE, croppedFile);
        Bitmap bitmap = BitmapUtils.decodeSampledBitmapFromResource(path, Config.PHOTO_DECODE_WIDTH, Config.PHOTO_DECODE_HEIGHT);
        photo = bitmap;
        savePhoto(photo);
        userPhoto.setImageBitmap(bitmap);
    }

    private void savePathCroppedImg(String path) {
        preferences.edit().putString(Config.CROPPED_PATH_IMG, path).apply();
    }

    private void savePathOriginalImg(String path) {
        preferences.edit().putString(Config.ORIGINAL_PATH_IMG, path).apply();
    }

    private void setCropImageSize(CropImage.ActivityResult result) {
        Rect rect = result.getCropRect();
        int x = rect.left;
        int y = rect.top;
        int width = rect.width();
        int height = rect.height();

        paramsRequest.put(Field.CROP_X, x);
        paramsRequest.put(Field.CROP_Y, y);
        paramsRequest.put(Field.CROP_WIDTH, width);
        paramsRequest.put(Field.CROP_HEIGHT, height);

        saveCropImageSize(x, y, width, height);
    }

    private void saveCropImageSize(int x, int y, int width, int height) {
        preferences.edit().putInt(Config.BUNDLE_CROP_X, x).apply();
        preferences.edit().putInt(Config.BUNDLE_CROP_Y, y).apply();
        preferences.edit().putInt(Config.BUNDLE_CROP_WIDTH, width).apply();
        preferences.edit().putInt(Config.BUNDLE_CROP_HEIGHT, height).apply();
    }

    private void setPhotoOfCamera() {
        String originalPath = preferences.getString(Config.ORIGINAL_PATH_IMG, "");
        savePathOriginalImg(originalPath);
        selectionPhotoDialog.scanGallery(Uri.fromFile(new File(originalPath)));
        originalFile = new File(originalPath);
        paramsRequest.put(Field.FILE, originalFile);
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(originalPath)));
    }

    private void setPhotoOfGallery(Intent data) {
        selectedImageURI = data.getData();
        String imagePath = BitmapUtils.getRealPathFromURI(selectedImageURI, getActivity());
        originalFile = new File(imagePath);
        savePathOriginalImg(imagePath);
        paramsRequest.put(Field.FILE, originalFile);
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(imagePath)));
    }

    private void putRegData() {
        mBundle.putSerializable(Config.INTENT_MAP_PARAMS_AVATAR, (Serializable) paramsRequest);
        mBundle.putInt(Config.BUNDLE_COUNTRY_ID, countryId);
        mBundle.putInt(Config.BUNDLE_CITY_ID, cityId);
        mBundle.putString(Config.BUNDLE_USER_PHONE, userPhoneNumber.getText().toString().trim());
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putAll(mBundle);
    }

    private BroadcastReceiver onUserCountryChanged = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            countryId = intent.getIntExtra(Config.INTENT_USER_COUNTRY_ID, 0);
            cityId = intent.getIntExtra(Config.INTENT_USER_CITY_ID, 0);
            String country = intent.getStringExtra(Config.INTENT_USER_COUNTRY);
            String city = intent.getStringExtra(Config.INTENT_USER_CITY);
            userLocation.setText(country + ", " + city);
        }
    };

    private BroadcastReceiver backlightFieldsAtRegErrors = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getStringExtra(Field.PHONE).equals(Field.PHONE)) {
                isPhoneNumberNotValid = true;
            }
        }
    };

    private BroadcastReceiver showNotificationError = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            String errMsg = intent.getStringExtra(Field.ERRORS);
            showNotification(errMsg);
        }
    };

    private void showNotification(String text) {
        topSnackBar.setSnackBar(getActivity().findViewById(R.id.relativeLayout4), text, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }
}
