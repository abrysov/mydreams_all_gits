package com.mydreams.android.components;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffColorFilter;
import android.graphics.drawable.Drawable;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageButton;
import android.widget.TextView;

import com.mydreams.android.R;

/**
 * Created by mikhail on 16.05.16.
 */
public class SettingsToolbar {

    private Toolbar toolbar;
    private TextView titleToolbar;

    public void setToolbar(Toolbar toolbar) {
        this.toolbar = toolbar;
    }

    public void setTitle(String title) {
        titleToolbar = (TextView) toolbar.findViewById(R.id.title_toolbar);
        titleToolbar.setText(title);
    }

    public void setTextColor(int color) {
        titleToolbar.setTextColor(color);
    }

    public void setColorToggle(int color) {
        final PorterDuffColorFilter colorFilter = new PorterDuffColorFilter(color, PorterDuff.Mode.MULTIPLY);

        for(int i = 0; i < toolbar.getChildCount(); i++) {
            final View v = toolbar.getChildAt(i);

            if (v instanceof ImageButton) {
                ((ImageButton) v).getDrawable().setColorFilter(colorFilter);
            }
        }
    }

    public void setBackgroundColor(int color) {
        toolbar.setBackgroundColor(color);
    }

    public void setNavigationIcon(Drawable icon) {
        toolbar.setNavigationIcon(icon);
    }

    public Toolbar getToolbar() {
        return toolbar;
    }
}
