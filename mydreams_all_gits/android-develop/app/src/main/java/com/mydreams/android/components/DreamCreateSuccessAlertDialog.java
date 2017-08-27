package com.mydreams.android.components;

import android.content.DialogInterface;
import android.support.v4.app.FragmentActivity;
import android.support.v7.app.AlertDialog;

import com.mydreams.android.Config;
import com.mydreams.android.R;

/**
 * Created by mikhail on 6/2/16.
 */
public class DreamCreateSuccessAlertDialog {

    private FragmentActivity activity;
    private OnItemClickListener itemClickListener;

    public void init(FragmentActivity activity) {
        this.activity = activity;
    }

    public void showDialog() {
        final String createNewDream = activity.getString(R.string.fulfill_dream_alert_dialog_btn_create_new);
        final String gotoDreambook = activity.getString(R.string.fulfill_dream_alert_dialog_btn_to_dreembook);

        final String[] menuItems = { createNewDream, gotoDreambook };
        AlertDialog.Builder alertDialog = new AlertDialog.Builder(activity, R.style.AlertDialogStyle);
        alertDialog.setTitle(activity.getString(R.string.fulfill_dream_successfully_added))
                .setCancelable(false)
                .setItems(menuItems, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int item) {
                        switch (item) {
                            case Config.ITEM_CREATE_NEW_DREAM:
                                itemClickListener.onClick(dialog, item);
                                break;
                            case Config.ITEM_GOTO_DREAMBOOK:
                                itemClickListener.onClick(dialog, item);
                                break;
                        }
                    }
                });
        alertDialog.show();
    }

    public void setOnItemClickListener(OnItemClickListener itemClickListener) {
        this.itemClickListener = itemClickListener;
    }

    public interface OnItemClickListener {
        void onClick(DialogInterface dialog, int item);
    }
}
