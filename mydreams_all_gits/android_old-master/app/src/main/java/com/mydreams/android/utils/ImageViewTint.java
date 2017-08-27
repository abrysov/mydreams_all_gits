package com.mydreams.android.utils;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.PorterDuff;
import android.os.Build;
import android.support.annotation.ColorInt;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.widget.ImageView;

import com.mydreams.android.R;

public class ImageViewTint extends ImageView
{
	@Nullable
	@ColorInt
	private Integer mTintColor;

	public ImageViewTint(final Context context)
	{
		this(context, null);
	}

	public ImageViewTint(final Context context, final AttributeSet attrs)
	{
		this(context, attrs, 0);
	}

	public ImageViewTint(final Context context, final AttributeSet attrs, final int defStyleAttr)
	{
		super(context, attrs, defStyleAttr);
		intiView(context, attrs, defStyleAttr, 0);
	}

	@TargetApi(Build.VERSION_CODES.LOLLIPOP)
	public ImageViewTint(final Context context, final AttributeSet attrs, final int defStyleAttr, final int defStyleRes)
	{
		super(context, attrs, defStyleAttr, defStyleRes);

		intiView(context, attrs, defStyleAttr, defStyleRes);
	}

	private void intiView(final Context context, final AttributeSet attrs, final int defStyleAttr, final int defStyleRes)
	{
		TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.ImageViewTint, defStyleAttr, defStyleRes);

		if (a.hasValue(R.styleable.ImageViewTint_tintColor))
		{
			mTintColor = a.getColor(R.styleable.ImageViewTint_tintColor, 0);
			setColorFilter(mTintColor, PorterDuff.Mode.SRC_ATOP);
		}

		a.recycle();
	}
}
