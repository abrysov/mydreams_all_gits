package com.mydreams.android.utils;

import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;

import com.facebook.drawee.drawable.ForwardingDrawable;

public class FixSizeDrawable extends ForwardingDrawable implements Animatable
{
	private final int mWidth;
	private final int mHeight;

	public FixSizeDrawable(final Drawable drawable, final int width, final int height)
	{
		super(drawable);
		mWidth = width;
		mHeight = height;
	}

	@Override
	public int getIntrinsicHeight()
	{
		return mHeight;
	}

	@Override
	public int getIntrinsicWidth()
	{
		return mWidth;
	}

	@Override
	public boolean isRunning()
	{
		Drawable drawable = getCurrent();
		return drawable instanceof Animatable && ((Animatable) drawable).isRunning();

	}

	@Override
	public void start()
	{
		Drawable drawable = getCurrent();
		if (drawable instanceof Animatable)
		{
			((Animatable) drawable).start();
		}
	}

	@Override
	public void stop()
	{
		Drawable drawable = getCurrent();
		if (drawable instanceof Animatable)
		{
			((Animatable) drawable).stop();
		}
	}
}
