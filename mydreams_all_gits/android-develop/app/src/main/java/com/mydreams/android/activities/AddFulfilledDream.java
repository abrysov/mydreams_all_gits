package com.mydreams.android.activities;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.components.SelectionPhotoDialog;
import com.mydreams.android.manager.DreamsListManager;
import com.mydreams.android.models.Field;
import com.mydreams.android.utils.BitmapUtils;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 29.06.16.
 */
public class AddFulfilledDream extends AppCompatActivity {

    @Bind(R.id.toolbar)
    Toolbar toolbar;
    @Bind(R.id.title_edit_dream)
    EditText titleEditDream;
    @Bind(R.id.description_edit_dream)
    EditText descriptionEditDream;
    @Bind(R.id.img_fulfill_dream)
    ImageView imgFulfilledDream;
    @Bind(R.id.img_empty_photo)
    ImageView imgEmptyPhoto;
    @Bind(R.id.btn_create_fulfilled_dream)
    Button btnCreateFulfilledDream;

    private InputMethodManager inputMethodManager;
    private Uri selectedImageURI;
    private File photoFile;
    private Map<String, Object> paramsRequest;
    private ProgressDialog progressDialog;
    private boolean existPhoto = false;

    @Inject
    SelectionPhotoDialog selectionPhotoDialog;
    @Inject
    SharedPreferences preferences;
    @Inject
    NotificationSnackBar topSnackBar;
    @Inject
    DreamsListManager dreamsListManager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_fulfilled_dream_layout);

        App.getComponent().inject(this);
        ButterKnife.bind(this);
        initInputManager();
        selectionPhotoDialog.init(this);
        initMapParams();
        initProgressDialog();
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
    }

    private void initProgressDialog() {
        progressDialog = new ProgressDialog(this, R.style.ProgressDialogTheme);
        progressDialog.setCancelable(false);
    }

    private void initInputManager() {
        inputMethodManager = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    private void hideKeyboard() {
        View view = this.getCurrentFocus();
        if (view != null) {
            inputMethodManager.hideSoftInputFromWindow(view.getWindowToken(), 0);
        }
    }

    @Override
    protected void onResume() {
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
        super.onResume();
    }

    @OnClick({R.id.view_add_photo_fulfill_dream, R.id.img_fulfill_dream})
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
                    imgEmptyPhoto.setVisibility(View.GONE);
                    setCropPicture(data);
                    break;
            }
        } else {
            if (imgFulfilledDream.getVisibility() != View.VISIBLE) {
                imgEmptyPhoto.setVisibility(View.VISIBLE);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void setCropPicture(Intent data) {
        CropImage.ActivityResult result = CropImage.getActivityResult(data);
        setCropImageSize(result);
        Uri resultUri = result.getUri();
        String path = BitmapUtils.getRealPathFromURI(resultUri, this);
        photoFile = new File(path);
        Bitmap bitmap = BitmapUtils.decodeSampledBitmapFromResource(path, Config.PHOTO_DECODE_WIDTH, Config.PHOTO_DECODE_HEIGHT);
        imgFulfilledDream.setImageBitmap(bitmap);
        existPhoto = true;
    }

    private void setPhotoOfCamera() {
        String originalPath = preferences.getString(Config.ORIGINAL_PATH_IMG, "");
        selectionPhotoDialog.scanGallery(Uri.fromFile(new File(originalPath)));
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(originalPath)));
    }

    private void setPhotoOfGallery(Intent data) {
        selectedImageURI = data.getData();
        String imagePath = BitmapUtils.getRealPathFromURI(selectedImageURI, this);
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(imagePath)));
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
    }

    private void showNotification(String text) {
        topSnackBar.setSnackBar(findViewById(R.id.view_add_photo_fulfill_dream), text, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }

    private void dreamCreate() {
        String titleDream = titleEditDream.getText().toString();
        String descriptionDream = descriptionEditDream.getText().toString();
        progressDialog.show();
        paramsRequest.put(Field.TITLE, titleDream);
        paramsRequest.put(Field.DESCRIPTION, descriptionDream);
        paramsRequest.put(Field.PHOTO, photoFile);
        paramsRequest.put(Field.CAME_TRUE, true);
        paramsRequest.put(Field.RESTRICTION_LEVEL, Field.PUBLIC);
        dreamsListManager.setSaveDreamListener(listener);
        dreamsListManager.dreamCreate(paramsRequest);
    }

    private DreamsListManager.OnSaveDreamListener listener = new DreamsListManager.OnSaveDreamListener() {
        @Override
        public void complete() {
            progressDialog.dismiss();
            finish();
        }

        @Override
        public void error(String errMsg) {
            showNotification(errMsg);
            progressDialog.dismiss();
        }
    };

    @OnClick(R.id.btn_create_fulfilled_dream)
    public void onClickCreateFulfilledDream() {
        if (titleEditDream.getText().length() == 0) {
            showNotification(getResources().getString(R.string.fulfill_dream_notification_title_empty));
        } else if (descriptionEditDream.getText().length() == 0) {
            showNotification(getResources().getString(R.string.fulfill_dream_notification_description_empty));
        } else if (!existPhoto) {
            showNotification(getResources().getString(R.string.fulfill_dream_notification_photo_empty));
        } else {
            dreamCreate();
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        switch (item.getItemId()) {
            case android.R.id.home:
                onBackPressed();
                hideKeyboard();
                return true;
            default:
                return super.onOptionsItemSelected(item);
        }
    }
}
