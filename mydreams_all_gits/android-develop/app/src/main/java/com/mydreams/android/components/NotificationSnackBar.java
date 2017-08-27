package com.mydreams.android.components;

import android.view.View;
import android.widget.TextView;

import com.androidadvance.topsnackbar.TSnackbar;

/**
 * Created by mikhail on 26.05.16.
 */
public class NotificationSnackBar {

    private TextView notificationText;
    private TSnackbar snackBar;
    private View snackBarView;

    public void setSnackBar(View view, String text, int duration) {
        snackBar = TSnackbar.make(view, text, duration);
        snackBarView = snackBar.getView();
        notificationText = (TextView) snackBarView.findViewById(com.androidadvance.topsnackbar.R.id.snackbar_text);
    }

    public void setBackgroundColor(int color) {
        snackBarView.setBackgroundColor(color);
    }

    public void show() {
        snackBar.show();
    }

    public void setTextGravity(int gravity) {
        notificationText.setGravity(gravity);
    }

    public void setTextSize(int unit, float size) {
        notificationText.setTextSize(unit, size);
    }

    public void setTextColor(int color) {
        notificationText.setTextColor(color);
    }

}
