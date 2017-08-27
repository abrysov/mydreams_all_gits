package com.mydreams.android.components;

import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.util.TypedValue;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.mydreams.android.R;

/**
 * Created by mikhail on 5/27/16.
 */
public class ItemModifiedMark {

    private FragmentActivity activity;
    private boolean isSelected = false;
    private int position;

    public ItemModifiedMark(FragmentActivity activity) {
        this.activity = activity;
    }

    public void setCurrentItem(View view) {
        ImageView icon = (ImageView) view.findViewById(R.id.ic_mark);
        ImageView icCheck = (ImageView) view.findViewById(R.id.ic_check);
        icCheck.setVisibility(View.VISIBLE);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) icon.getLayoutParams();
        params.width = getComplexUnitDIP(90);
        params.height = getComplexUnitDIP(115);
        params.setMargins(0, 0, 0, 0);
        icon.setLayoutParams(params);
        isSelected = true;
    }

    public void setCurrentPosition(int position) {
        this.position = position;
    }

    public void setDefaultStateItem(RecyclerView recyclerView) {
        int childCount = recyclerView.getChildCount();
        for (int i = 0; i < childCount; i++) {
            View view = recyclerView.getChildAt(i);
            ImageView icon = (ImageView) view.findViewById(R.id.ic_mark);
            ImageView icCheck = (ImageView) view.findViewById(R.id.ic_check);
            icCheck.setVisibility(View.INVISIBLE);
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) icon.getLayoutParams();
            params.width = getComplexUnitDIP(80);
            params.height = getComplexUnitDIP(105);
            params.topMargin = getComplexUnitDIP(10);
            params.bottomMargin = 0;
            params.leftMargin = getComplexUnitDIP(5);
            params.rightMargin = getComplexUnitDIP(5);
            icon.setLayoutParams(params);
        }
        isSelected = false;
    }

    public boolean isSelected() {
        if (isSelected) {
            return true;
        }
        return false;
    }

    public int getCurrentPosition() {
        return position;
    }

    private int getComplexUnitDIP(int dip) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dip, activity.getResources().getDisplayMetrics());
    }
}
