package com.mydreams.android.utils;

import android.os.Build;
import android.support.annotation.ColorInt;
import android.support.annotation.ColorRes;
import android.support.v4.app.FragmentActivity;
import android.view.Window;
import android.view.WindowManager;

public class ActivityUtils
{
	public static void setStatusBarColor(FragmentActivity activity, @ColorInt int colorResId)
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
		{
			Window window = activity.getWindow();
			window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			window.setStatusBarColor(colorResId);
		}
	}

	@SuppressWarnings("deprecation")
	public static void setStatusBarColorRes(FragmentActivity activity, @ColorRes int colorResId)
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
		{
			Window window = activity.getWindow();
			window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
			window.setStatusBarColor(activity.getResources().getColor(colorResId));
		}
	}
}
