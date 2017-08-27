package com.mydreams.android.fragments;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.androidadvance.topsnackbar.TSnackbar;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.adapters.MarksAdapter;
import com.mydreams.android.components.DreamCreateSuccessAlertDialog;
import com.mydreams.android.components.ItemModifiedMark;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.components.SelectionPhotoDialog;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.manager.DreamsListManager;
import com.mydreams.android.models.Field;
import com.mydreams.android.utils.BitmapUtils;
import com.theartofdev.edmodo.cropper.CropImage;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 25.05.16.
 */
public class FulfillDreamFragment extends BaseFragment implements View.OnClickListener {

    @Bind(R.id.view_add_photo_fulfill_dream)           RelativeLayout viewAddPhotoFulFillDream;
    @Bind(R.id.title_edit_dream)                       EditText titleEditDream;
    @Bind(R.id.description_edit_dream)                 EditText descriptionEditDream;
    @Bind(R.id.view_selected_see_dream_only_me)        RelativeLayout viewSelectedSeeDreamOnlyMe;
    @Bind(R.id.view_selected_see_dream_me_and_friends) RelativeLayout viewSelectedSeeDreamMeAndFriend;
    @Bind(R.id.view_selected_see_dream_all)            RelativeLayout viewSelectedSeeDreamAll;
    @Bind(R.id.fulfill_dream_recycler_view)            RecyclerView fulfillDreamRecyclerView;
    @Bind(R.id.btn_add_to_my_dreambook)                Button btnAddToMyDreambook;
    @Bind(R.id.check_box_only_me)                      ImageView checkBoxOnlyMe;
    @Bind(R.id.check_box_me_and_friends)               ImageView checkBoxMeAndFriends;
    @Bind(R.id.check_box_all)                          ImageView checkBoxAll;
    @Bind(R.id.img_fulfill_dream)                      ImageView imgFulfillDream;
    @Bind(R.id.img_empty_photo)                        ImageView imgEmptyPhoto;

    private MarksAdapter marksAdapter;
    private boolean existPhoto = false;
    private ItemModifiedMark itemModifiedMark;
    private Uri selectedImageURI;
    private File photoFile;
    private Map<String, Object> paramsRequest;
    private ProgressDialog progressDialog;
    private String restrictionLevel;

    @Inject
    SettingsToolbar settingsToolbar;
    @Inject
    NotificationSnackBar topSnackBar;
    @Inject
    SelectionPhotoDialog selectionPhotoDialog;
    @Inject
    SharedPreferences preferences;
    @Inject
    DreamsListManager dreamsListManager;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fulfill_dream_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);
        initRecyclerView();
        checkBoxAll.setVisibility(View.VISIBLE);
        typeFragment = Config.FTYPE_FULFILL_DREAM;
        initMarkChangeItem();
        selectionPhotoDialog.init(getActivity());
        initMapParams();
        initProgressDialog();
        return view;
    }

    private void initMapParams() {
        paramsRequest = new HashMap<>();
        restrictionLevel = Field.PUBLIC;
    }

    private void initMarkChangeItem() {
        itemModifiedMark = new ItemModifiedMark(getActivity());
    }

    private List<Integer> getMarksPriceList() {
        int[] marksPriceArray = getResources().getIntArray(R.array.marks_price_list);
        List<Integer> marksPriceList = new ArrayList<>();
        for (int i = 0; i < marksPriceArray.length; i++) {
            marksPriceList.add(marksPriceArray[i]);
        }
        return marksPriceList;
    }

    private void initProgressDialog() {
        progressDialog = new ProgressDialog(getActivity(), R.style.ProgressDialogTheme);
        progressDialog.setCancelable(false);
    }

    private List<Drawable> getMarksIcons() {
        TypedArray marksIconArray = getResources().obtainTypedArray(R.array.marks_icon);
        List<Drawable> marksIconList = new ArrayList<>();
        for (int i = 0; i < marksIconArray.length(); i++) {
            marksIconList.add(marksIconArray.getDrawable(i));
        }
        return marksIconList;
    }

    @OnClick(R.id.view_selected_see_dream_only_me)
    public void onClickCheckedSeeDreamOnlyMe() {
        clearRestrictionLevel();
        checkBoxOnlyMe.setVisibility(View.VISIBLE);
        checkBoxAll.setVisibility(View.INVISIBLE);
        checkBoxMeAndFriends.setVisibility(View.INVISIBLE);
        restrictionLevel = Field.PRIVATE;
    }

    @OnClick(R.id.view_selected_see_dream_me_and_friends)
    public void onClickCheckedSeeDreamMeAndFriends() {
        clearRestrictionLevel();
        checkBoxMeAndFriends.setVisibility(View.VISIBLE);
        checkBoxAll.setVisibility(View.INVISIBLE);
        checkBoxOnlyMe.setVisibility(View.INVISIBLE);
        restrictionLevel = Field.FRIENDS;
    }

    @OnClick(R.id.view_selected_see_dream_all)
    public void onClickCheckedSeeDreamAll() {
        clearRestrictionLevel();
        checkBoxAll.setVisibility(View.VISIBLE);
        checkBoxMeAndFriends.setVisibility(View.INVISIBLE);
        checkBoxOnlyMe.setVisibility(View.INVISIBLE);
        restrictionLevel = Field.PUBLIC;
    }

    @OnClick({R.id.view_add_photo_fulfill_dream, R.id.img_fulfill_dream})
    public void onClickSelectedPhoto() {
        selectionPhotoDialog.createDialog();
    }

    private DreamsListManager.OnSaveDreamListener listener = new DreamsListManager.OnSaveDreamListener() {
        @Override
        public void complete() {
            progressDialog.dismiss();
            showNotificationDialog();
        }

        @Override
        public void error(String errMsg) {
            showNotification(errMsg);
            progressDialog.dismiss();
        }
    };

    private void clearRestrictionLevel() {
        paramsRequest.clear();
    }

    private void initRecyclerView() {
        LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
        layoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        fulfillDreamRecyclerView.setLayoutManager(layoutManager);
        marksAdapter = new MarksAdapter(getMarksPriceList(), getMarksIcons(), this);
        fulfillDreamRecyclerView.setAdapter(marksAdapter);
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
                    imgEmptyPhoto.setVisibility(View.GONE);
                    setCropPicture(data);
                    break;
            }
        } else {
            if (imgFulfillDream.getVisibility() != View.VISIBLE) {
                imgEmptyPhoto.setVisibility(View.VISIBLE);
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void setCropPicture(Intent data) {
        CropImage.ActivityResult result = CropImage.getActivityResult(data);
        setCropImageSize(result);
        Uri resultUri = result.getUri();
        String path = BitmapUtils.getRealPathFromURI(resultUri, getActivity());
        photoFile = new File(path);
        Bitmap bitmap = BitmapUtils.decodeSampledBitmapFromResource(path, Config.PHOTO_DECODE_WIDTH, Config.PHOTO_DECODE_HEIGHT);
        imgFulfillDream.setImageBitmap(bitmap);
        existPhoto = true;
    }

    private void setPhotoOfCamera() {
        String originalPath = preferences.getString(Config.ORIGINAL_PATH_IMG, "");
        selectionPhotoDialog.scanGallery(Uri.fromFile(new File(originalPath)));
        selectionPhotoDialog.performCrop(Uri.fromFile(new File(originalPath)));
    }

    private void setPhotoOfGallery(Intent data) {
        selectedImageURI = data.getData();
        String imagePath = BitmapUtils.getRealPathFromURI(selectedImageURI, getActivity());
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

    @Override
    public void onResume() {
        settingsToolbar.setTitle(getResources().getString(R.string.fulfill_dream_title_toolbar));
        settingsToolbar.setBackgroundColor(getResources().getColor(R.color.colorPrimary));
        getActivity().getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        super.onResume();
    }

    @Override
    public void onClick(View view) {
        int itemPosition = fulfillDreamRecyclerView.getChildLayoutPosition(view);
        if (itemModifiedMark.isSelected()) {
            if (itemPosition == itemModifiedMark.getCurrentPosition()) {
                itemModifiedMark.setDefaultStateItem(fulfillDreamRecyclerView);
            } else {
                itemModifiedMark.setDefaultStateItem(fulfillDreamRecyclerView);
                itemModifiedMark.setCurrentItem(view);
                itemModifiedMark.setCurrentPosition(itemPosition);
            }
        } else {
            itemModifiedMark.setCurrentItem(view);
            itemModifiedMark.setCurrentPosition(itemPosition);
        }
    }

    @OnClick(R.id.btn_add_to_my_dreambook)
    public void onClickAddToMyDreembook() {
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

    private void dreamCreate() {
        String titleDream = titleEditDream.getText().toString();
        String descriptionDream = descriptionEditDream.getText().toString();
        progressDialog.show();
        paramsRequest.put(Field.TITLE, titleDream);
        paramsRequest.put(Field.DESCRIPTION, descriptionDream);
        paramsRequest.put(Field.PHOTO, photoFile);
        paramsRequest.put(Field.CAME_TRUE, false);
        paramsRequest.put(Field.RESTRICTION_LEVEL, restrictionLevel);
        dreamsListManager.setSaveDreamListener(listener);
        dreamsListManager.dreamCreate(paramsRequest);
    }

    private void showNotification(String text) {
        topSnackBar.setSnackBar(getActivity().findViewById(R.id.container), text, TSnackbar.LENGTH_LONG);
        topSnackBar.setBackgroundColor(getResources().getColor(R.color.snackbar_bg_color));
        topSnackBar.setTextGravity(Gravity.CENTER);
        topSnackBar.setTextColor(getResources().getColor(R.color.white));
        topSnackBar.setTextSize(TypedValue.COMPLEX_UNIT_SP, 14);
        topSnackBar.show();
    }

    private void showNotificationDialog() {
        DreamCreateSuccessAlertDialog alertDialog = new DreamCreateSuccessAlertDialog();
        alertDialog.init(getActivity());
        alertDialog.showDialog();
        alertDialog.setOnItemClickListener(itemClickListener);
    }

    private DreamCreateSuccessAlertDialog.OnItemClickListener itemClickListener = new DreamCreateSuccessAlertDialog.OnItemClickListener() {
        @Override
        public void onClick(DialogInterface dialog, int item) {
            switch (item) {
                case Config.ITEM_CREATE_NEW_DREAM:
                    dialog.cancel();
                    refreshView();
                    break;
                case Config.ITEM_GOTO_DREAMBOOK:
                    dialog.cancel();
                    needOpenFragment(Config.FTYPE_PROFILE, null);
                    break;
            }
        }
    };

    private void refreshView() {
        refreshView(Config.FTYPE_FULFILL_DREAM);
        titleEditDream.setText("");
        descriptionEditDream.setText("");
        existPhoto = false;
    }
}
