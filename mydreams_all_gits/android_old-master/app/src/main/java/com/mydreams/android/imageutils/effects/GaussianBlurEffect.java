package com.mydreams.android.imageutils.effects;

import android.content.Context;
import android.graphics.Bitmap;
import android.support.annotation.NonNull;

import java.lang.ref.WeakReference;

import jp.co.cyberagent.android.gpuimage.GPUImage;
import jp.co.cyberagent.android.gpuimage.GPUImageGaussianBlurFilter;

public class GaussianBlurEffect implements IEffect
{
	private final WeakReference<Context> weakContext;

	public GaussianBlurEffect(Context context)
	{
		this.weakContext = new WeakReference<>(context);
	}

	@Override
	public Bitmap process(@NonNull Bitmap sourceBitmap)
	{
		Context context = weakContext.get();
		if (context != null)
		{
			GPUImage gpuImage = new GPUImage(context);
			gpuImage.setFilter(new GPUImageGaussianBlurFilter());
			return gpuImage.getBitmapWithFilterApplied(sourceBitmap);
		}
		else
		{
			throw new RuntimeException("Lost context");
		}
	}
}