package com.mydreams.android.components;

import android.content.res.ColorStateList;
import android.os.Build;
import android.util.TypedValue;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TabHost;
import android.widget.TabWidget;
import android.widget.TextView;

/**
 * Created by mikhail on 06.05.16.
 */
public class CustomTabHost {

    private TabHost tabHost;
    private TabWidget tabWidget;
    private TabHost.TabSpec tabSpec;
    private TextView titleTab;

    public void setTabHost(TabHost tabHost) {
        this.tabHost = tabHost;
        this.tabHost.setup();
        tabWidget = tabHost.getTabWidget();
    }

    public void setNewTab(String tag, String indicator, int content) {
        tabSpec = tabHost.newTabSpec(tag);
        tabSpec.setIndicator(indicator);
        tabSpec.setContent(content);
        tabHost.addTab(tabSpec);

        for(int i=0; i < tabWidget.getChildCount(); i++) {
            titleTab = (TextView) tabWidget.getChildAt(i).findViewById(android.R.id.title);
            titleTab.setSingleLine(true);
            if (Build.VERSION.SDK_INT >= 21) {
                titleTab.setLetterSpacing(0.08f);
            }
            tabWidget.getChildAt(i).getLayoutParams().width = LinearLayout.LayoutParams.WRAP_CONTENT;
        }
    }

    public void setCurrentTab(int numberTab) {
        tabHost.setCurrentTab(numberTab);
    }

    public void setTabTextColor(ColorStateList textColor) {
        for(int i=0; i < tabWidget.getChildCount(); i++) {
            titleTab = (TextView) tabWidget.getChildAt(i).findViewById(android.R.id.title);
            titleTab.setTextColor(textColor);
        }
    }

    public void setTabTextSize(int textSize) {
        for(int i=0; i < tabWidget.getChildCount(); i++) {
            titleTab = (TextView) tabWidget.getChildAt(i).findViewById(android.R.id.title);
            titleTab.setTextSize(TypedValue.COMPLEX_UNIT_SP, textSize);
        }
    }

    public void setBackgroundTab(int backgroundTab) {
        for(int i=0; i < tabWidget.getChildCount(); i++) {
            View v = tabWidget.getChildAt(i);
            v.setBackgroundResource(backgroundTab);
        }
    }

    public void setOnTabChangedListener(TabHost.OnTabChangeListener onTabChangedListener) {
        tabHost.setOnTabChangedListener(onTabChangedListener);
    }

    public void setBackgroundLeftTab(int backgroundTab) {
        View v = tabWidget.getChildAt(0);
        v.setBackgroundResource(backgroundTab);
    }

    public void setBackgroundCenterTab(int backgroundTab) {
        View v = tabWidget.getChildAt(1);
        v.setBackgroundResource(backgroundTab);
    }

    public void setBackgroundRight(int backgroundTab) {
        View v = tabWidget.getChildAt(2);
        v.setBackgroundResource(backgroundTab);
    }

    public void setHeightTab() {
        for(int i=0; i < tabWidget.getChildCount(); i++) {
            tabWidget.getChildAt(i).getLayoutParams().height = LinearLayout.LayoutParams.WRAP_CONTENT;
        }
    }

    public int getCurrentTab() {
        return tabHost.getCurrentTab();
    }
}
