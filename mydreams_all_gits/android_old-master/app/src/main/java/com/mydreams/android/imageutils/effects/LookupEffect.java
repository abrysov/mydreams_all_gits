package com.mydreams.android.imageutils.effects;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.annotation.NonNull;

import com.mydreams.android.R;

import java.lang.ref.WeakReference;

import jp.co.cyberagent.android.gpuimage.GPUImage;
import jp.co.cyberagent.android.gpuimage.GPUImageLookupFilter;

public class LookupEffect implements IEffect
{
	private final WeakReference<Context> weakContext;

	public LookupEffect(Context context)
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

			GPUImageLookupFilter filter = new GPUImageLookupFilter();
			filter.setBitmap(BitmapFactory.decodeResource(context.getResources(), R.drawable.lookup_amatorka));

			gpuImage.setFilter(filter);
			return gpuImage.getBitmapWithFilterApplied(sourceBitmap);
		}
		else
		{
			throw new RuntimeException("Lost context");
		}
	}
}
