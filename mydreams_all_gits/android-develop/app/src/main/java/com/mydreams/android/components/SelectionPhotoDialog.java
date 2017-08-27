package com.mydreams.android.components;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AlertDialog;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.theartofdev.edmodo.cropper.CropImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.inject.Inject;

/**
 * Created by mikhail on 15.03.16.
 */
public class SelectionPhotoDialog {

    public static final int MEDIA_TYPE_IMAGE = 1;
    public static final int MEDIA_TYPE_VIDEO = 2;

    private FragmentActivity activity;

    @Inject
    SharedPreferences preferences;

    public SelectionPhotoDialog() {
        App.getComponent().inject(this);
    }

    public void init(FragmentActivity activity) {
        this.activity = activity;
    }

    public void createDialog() {
        final String camera = activity.getResources().getString(R.string.dialog_camera);
        final String gallery = activity.getString(R.string.dialog_gallery);
        final String cancel = activity.getString(R.string.dialog_cancel);

        final String[] menuItems = { camera, gallery, cancel };

        AlertDialog.Builder builder = new AlertDialog.Builder(activity, R.style.AlertDialogStyle);
        builder.setTitle(R.string.dialog_photo);

        builder.setItems(menuItems, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                switch (item) {
                    case Config.ITEM_CAMERA:
                        openCamera(activity);
                        break;
                    case Config.ITEM_GALLERY:
                        openGallery(activity);
                        break;
                    case Config.ITEM_CANCEL:
                        dialog.dismiss();
                        break;
                }
            }
        });
        builder.show();
    }

    private void openCamera(Activity activity) {
        Uri uri = getOutputMediaFileUri(MEDIA_TYPE_IMAGE);

        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        activity.startActivityForResult(intent, Config.REQUEST_CAMERA);
    }

    private void openGallery(Activity activity) {
        Intent intent = new Intent(Intent.ACTION_PICK, android.provider.MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        intent.setType("image/*");
        activity.startActivityForResult(Intent.createChooser(intent, ""), Config.REQUEST_GALLERY);
    }

    private Uri getOutputMediaFileUri(int type){
        return Uri.fromFile(getOutputMediaFile(type));
    }

    private File getOutputMediaFile(int type){
        File mediaStorageDir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES), "mydreams");
        if (! mediaStorageDir.exists()){
            if (! mediaStorageDir.mkdirs()){
                return null;
            }
        }

        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        File mediaFile;
        if (type == MEDIA_TYPE_IMAGE){
            mediaFile = new File(mediaStorageDir.getPath() + File.separator + "IMG_"+ timeStamp + ".jpg");
        } else if(type == MEDIA_TYPE_VIDEO) {
            mediaFile = new File(mediaStorageDir.getPath() + File.separator + "VID_"+ timeStamp + ".mp4");
        } else {
            return null;
        }
        preferences.edit().putString(Config.ORIGINAL_PATH_IMG, mediaFile.toString()).apply();
        return mediaFile;
    }

    public void scanGallery(Uri uri) {
        Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        mediaScanIntent.setData(uri);
        activity.sendBroadcast(mediaScanIntent);
    }

    public void performCrop(final Uri uri) {
        CropImage.activity(uri)
                .setFixAspectRatio(true)
                .start(activity);
    }
}
