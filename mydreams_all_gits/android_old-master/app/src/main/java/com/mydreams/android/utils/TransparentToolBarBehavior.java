package com.mydreams.android.utils;

import android.support.design.widget.AppBarLayout;
import android.support.design.widget.CoordinatorLayout;
import android.view.View;

import java.util.List;

public class TransparentToolBarBehavior extends CoordinatorLayout.Behavior<View>
{
	private int mOverlayTop;

	public TransparentToolBarBehavior()
	{
	}

	private static AppBarLayout findFirstAppBarLayout(List<View> views)
	{
		int i = 0;

		for (int z = views.size(); i < z; ++i)
		{
			View view = views.get(i);
			if (view instanceof AppBarLayout)
			{
				return (AppBarLayout) view;
			}
		}

		return null;
	}

	@Override
	public void onNestedScroll(CoordinatorLayout coordinatorLayout, View child, View target, int dxConsumed, int dyConsumed, int dxUnconsumed, int dyUnconsumed)
	{
		super.onNestedScroll(coordinatorLayout, child, target, dxConsumed, dyConsumed, dxUnconsumed, dyUnconsumed);
	}

}