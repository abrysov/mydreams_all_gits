package com.mydreams.android.imageutils;

import android.graphics.Bitmap;
import android.support.annotation.Nullable;

import com.facebook.common.references.CloseableReference;
import com.facebook.imagepipeline.bitmaps.PlatformBitmapFactory;
import com.facebook.imagepipeline.nativecode.Bitmaps;
import com.facebook.imagepipeline.request.BasePostprocessor;
import com.mydreams.android.imageutils.effects.IEffect;

public class FrescoPostprocessor extends BasePostprocessor
{
	@Nullable
	private IEffect effect;

	public FrescoPostprocessor(@Nullable IEffect effect)
	{
		this.effect = effect;
	}

	@Override
	public CloseableReference<Bitmap> process(Bitmap sourceBitmap, PlatformBitmapFactory bitmapFactory)
	{
		if (effect != null)
		{
			Bitmap processImage = effect.process(sourceBitmap);
			CloseableReference<Bitmap> result = bitmapFactory.createBitmap(sourceBitmap.getWidth(), sourceBitmap.getHeight());
			Bitmaps.copyBitmap(result.get(), processImage);
			processImage.recycle();
			return result;
		}

		return super.process(sourceBitmap, bitmapFactory);
	}
}
