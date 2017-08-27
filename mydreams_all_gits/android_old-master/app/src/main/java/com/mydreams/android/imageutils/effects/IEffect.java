package com.mydreams.android.imageutils.effects;

import android.graphics.Bitmap;
import android.support.annotation.NonNull;

public interface IEffect
{
	Bitmap process(@NonNull Bitmap sourceBitmap);
}
