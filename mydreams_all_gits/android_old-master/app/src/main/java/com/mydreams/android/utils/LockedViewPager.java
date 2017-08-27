package com.mydreams.android.utils;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class LockedViewPager extends ViewPager
{
	private boolean enabled;

	public LockedViewPager(Context context, AttributeSet attrs)
	{
		super(context, attrs);
		enabled = true;
	}

	@Override
	public boolean canScrollHorizontally(final int direction)
	{
		return enabled && super.canScrollHorizontally(direction);
	}

	@Override
	public boolean onInterceptTouchEvent(MotionEvent event)
	{
		return enabled && super.onInterceptTouchEvent(event);
	}

	@Override
	public boolean onTouchEvent(MotionEvent event)
	{
		return enabled && super.onTouchEvent(event);
	}

	public void setScrollEnabled(boolean enabled)
	{
		this.enabled = enabled;
	}
}
