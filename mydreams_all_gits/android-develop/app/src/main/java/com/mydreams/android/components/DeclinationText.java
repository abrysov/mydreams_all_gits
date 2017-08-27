package com.mydreams.android.components;

import android.app.Activity;

import com.mydreams.android.R;

/**
 * Created by mikhail on 6/17/16.
 */
public class DeclinationText {

    private Activity activity;

    public DeclinationText(Activity activity) {
        this.activity = activity;
    }

    public String getFormatText(int count) {
        String text;

        count = count % 100;
        if (count > 10 && count < 20) {
            text = activity.getResources().getString(R.string.dreamers_filter_declination_text_plural);
        } else {
            count = count % 100;

            if (count > 1 && count < 5) {
                text = activity.getResources().getString(R.string.dreamers_filter_declination_text_singular);
            } else if (count == 1) {
                text = "";
            } else {
                text = activity.getResources().getString(R.string.dreamers_filter_declination_text_plural);
            }
        }
        return text;
    }
}
