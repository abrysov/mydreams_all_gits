package com.mydreams.android.imageutils;

import android.graphics.Bitmap;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.facebook.common.executors.CallerThreadExecutor;
import com.facebook.common.references.CloseableReference;
import com.facebook.datasource.DataSource;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.datasource.BaseBitmapDataSubscriber;
import com.facebook.imagepipeline.image.CloseableImage;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.imageutils.effects.IEffect;
import com.mydreams.android.utils.ManualResetEvent;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.concurrent.Executor;

public class FrescoUtils
{
	public static void processAndSave(@NonNull File sourceImage, @NonNull File destImage,
									  @Nullable Integer width, @Nullable Integer height,
									  @Nullable IEffect effect, @Nullable Executor executor)
	{
		ResizeOptions resizeOptions = null;
		if (width != null && height != null)
		{
			resizeOptions = new ResizeOptions(width, height);
		}
		else if (width != null)
		{
			//noinspection SuspiciousNameCombination
			resizeOptions = new ResizeOptions(width, width);
		}
		else if (height != null)
		{
			//noinspection SuspiciousNameCombination
			resizeOptions = new ResizeOptions(height, height);
		}

		FrescoPostprocessor postprocessor = effect != null ? new FrescoPostprocessor(effect) : null;

		ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.fromFile(sourceImage))
				.setResizeOptions(resizeOptions)
				.setAutoRotateEnabled(true)
				.setPostprocessor(postprocessor)
				.build();

		final ManualResetEvent event = new ManualResetEvent(false);
		final RuntimeException[] exceptions = {null};

		BaseBitmapDataSubscriber subscriber = new BaseBitmapDataSubscriber()
		{
			@Override
			protected void onFailureImpl(DataSource<CloseableReference<CloseableImage>> dataSource)
			{
				exceptions[0] = new RuntimeException("Ошибка обработки изображения", dataSource.getFailureCause());

				event.set();

				throw exceptions[0];
			}

			@Override
			protected void onNewResultImpl(@Nullable Bitmap bitmap)
			{
				try
				{
					if (bitmap != null)
					{
						try
						{
							FileOutputStream stream = new FileOutputStream(destImage);
							bitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream);
							stream.close();
						}
						catch (IOException e)
						{
							exceptions[0] = new RuntimeException("Ошибка обработки изображения", e);
							throw exceptions[0];
						}
					}
				}
				finally
				{
					event.set();
				}
			}
		};

		DataSource<CloseableReference<CloseableImage>> dataSource = Fresco.getImagePipeline().fetchDecodedImage(request, null);
		try
		{
			dataSource.subscribe(subscriber, executor != null ? executor : CallerThreadExecutor.getInstance());

			try
			{
				event.waitOne();
			}
			catch (InterruptedException e)
			{
				throw new RuntimeException("Ошибка обработки изображения", e);
			}

			if (exceptions[0] != null)
			{
				throw new RuntimeException("", exceptions[0]);
			}

			if (dataSource.getResult() != null)
			{
				dataSource.getResult().get().close();
				dataSource.getResult().close();
			}
		}
		finally
		{
			dataSource.close();
		}
	}
}
