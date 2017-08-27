package com.mydreams.android.imageutils;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.ExifInterface;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.annimon.stream.Stream;
import com.mydreams.android.imageutils.effects.IEffect;
import com.mydreams.android.utils.FileUtils;
import com.octo.android.robospice.request.SpiceRequest;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

public class PreprocessPhotoRequest extends SpiceRequest<PreprocessPhotoRequest.PreprocessResult>
{
	private static final String TAG = "PreprocessPhotoRequest";
	private static final int compressQuality = 85;
	private final int maxOriginalSize;
	private final int maxThumbSize;
	@NonNull
	private IEffect[] effects;
	@NonNull
	private String originalPhotoPath;
	private File folderPath;

	public PreprocessPhotoRequest(@NonNull String originalPhotoPath, @NonNull String folderPath, int maxOriginalSize, int thumbMaxSize, @NonNull IEffect[] effects)
	{
		super(PreprocessPhotoRequest.PreprocessResult.class);

		this.originalPhotoPath = originalPhotoPath;
		this.folderPath = new File(folderPath);
		this.maxOriginalSize = maxOriginalSize;
		this.maxThumbSize = thumbMaxSize;
		this.effects = effects;
	}

	private static void applyOrientationExif(@NonNull File file, @Nullable Integer orientation)
	{
		if (orientation != null)
		{
			ExifInterface exif;
			try
			{
				exif = new ExifInterface(file.toString());
				exif.setAttribute(ExifInterface.TAG_ORIENTATION, orientation.toString());
				exif.saveAttributes();
			}
			catch (IOException e)
			{
				Log.d(TAG, "Error set exif for:" + file, e);
			}
		}
	}

	private static void resizeImage(@NonNull Bitmap originalBitmap, @NonNull File output, int maxWidth, int maxHeight, Integer orientation) throws IOException
	{
		int width = originalBitmap.getWidth();
		int height = originalBitmap.getHeight();

		float scaleFactor = Math.min((float) maxWidth / width, (float) maxHeight / height);
		int destWidth = (int) (scaleFactor * width);
		int destHeight = (int) (scaleFactor * height);

		Bitmap bitmap = null;
		OutputStream stream = null;

		try
		{
			bitmap = Bitmap.createScaledBitmap(originalBitmap, destWidth, destHeight, true);
			stream = new FileOutputStream(output);
			bitmap.compress(Bitmap.CompressFormat.JPEG, compressQuality, stream);

			applyOrientationExif(output, orientation);
		}
		finally
		{
			if (bitmap != null)
				bitmap.recycle();

			if (stream != null)
				stream.close();
		}
	}

	@SuppressWarnings("ResultOfMethodCallIgnored")
	@Override
	public PreprocessResult loadDataFromNetwork() throws Exception
	{
		ExifInterface exif;
		Integer orientation = null;
		try
		{
			exif = new ExifInterface(originalPhotoPath);
			orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED);
		}
		catch (IOException e)
		{
			Log.d(TAG, "Error get exif from:" + originalPhotoPath, e);
		}

		BitmapFactory.Options originalOptions = new BitmapFactory.Options();
		originalOptions.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(originalPhotoPath, originalOptions);

		int width = originalOptions.outWidth;
		int height = originalOptions.outHeight;

		File originalResultPath = FileUtils.createTempFile(folderPath);
		File thumbResultPath = FileUtils.createTempFile(folderPath);

		boolean needOriginalResize = width > maxOriginalSize || height > maxOriginalSize;
		boolean needThumbResize = width > maxThumbSize || height > maxThumbSize;

		Bitmap originalBitmap = null;

		try
		{
			if (needOriginalResize || needThumbResize)
			{
				int scaleFactor = Math.min(width / maxOriginalSize, height / maxOriginalSize);

				originalOptions.inJustDecodeBounds = false;
				originalOptions.inSampleSize = scaleFactor;

				originalBitmap = BitmapFactory.decodeFile(originalPhotoPath, originalOptions);
			}

			if (needOriginalResize)
			{
				try
				{
					resizeImage(originalBitmap, originalResultPath, maxOriginalSize, maxOriginalSize, orientation);
				}
				catch (Exception e)
				{
					String message = "Неудалось пережать изображение, infile:" + originalPhotoPath + " outfile:" + originalResultPath.toString();
					Log.w(TAG, message, e);
					throw new Exception(message, e);
				}
			}
			else
			{
				org.apache.commons.io.FileUtils.copyFile(new File(originalPhotoPath), originalResultPath);
			}

			if (needThumbResize)
			{
				try
				{
					resizeImage(originalBitmap, thumbResultPath, maxThumbSize, maxThumbSize, orientation);
				}
				catch (Exception e)
				{
					String message = "Неудалось создать превью для изображения, infile:" + originalPhotoPath + "outfile:" + thumbResultPath.toString();
					Log.w(TAG, message, e);
					throw new Exception(message, e);
				}
			}
			else
			{
				org.apache.commons.io.FileUtils.copyFile(new File(originalPhotoPath), thumbResultPath);
			}

			if (originalBitmap != null)
			{
				originalBitmap.recycle();
				originalBitmap = null;
			}

			File[] originalWithEffectPaths;
			File[] thumbWithEffectPaths;

			List<File> originalWithEffectFiles = new ArrayList<>();
			List<File> thumbWithEffectFiles = new ArrayList<>();

			Bitmap resultOriginalBitmap = null;
			Bitmap thumbBitmap = null;

			try
			{
				resultOriginalBitmap = BitmapFactory.decodeFile(originalResultPath.toString(), new BitmapFactory.Options());
				thumbBitmap = BitmapFactory.decodeFile(thumbResultPath.toString(), new BitmapFactory.Options());

				for (IEffect effect : effects)
				{
					File output = FileUtils.createTempFile(folderPath);
					applyEffectAndSave(resultOriginalBitmap, output, effect, orientation);
					originalWithEffectFiles.add(output);

					output = FileUtils.createTempFile(folderPath);
					applyEffectAndSave(thumbBitmap, output, effect, orientation);
					thumbWithEffectFiles.add(output);
				}

				originalWithEffectPaths = originalWithEffectFiles.toArray(new File[originalWithEffectFiles.size()]);
				thumbWithEffectPaths = thumbWithEffectFiles.toArray(new File[thumbWithEffectFiles.size()]);
			}
			catch (Exception e)
			{
				Stream.of(originalWithEffectFiles).filter(File::exists).forEach(File::delete);
				Stream.of(thumbWithEffectFiles).filter(File::exists).forEach(File::delete);

				if (resultOriginalBitmap != null)
					resultOriginalBitmap.recycle();

				if (thumbBitmap != null)
					thumbBitmap.recycle();

				throw e;
			}

			return new PreprocessResult(originalResultPath.toString(), thumbResultPath.toString(), originalWithEffectPaths, thumbWithEffectPaths);
		}
		catch (Exception e)
		{
			if (originalResultPath.exists())
				originalResultPath.delete();

			if (thumbResultPath.exists())
				thumbResultPath.delete();

			throw e;
		}
		finally
		{
			if (originalBitmap != null)
				originalBitmap.recycle();
		}
	}

	private void applyEffectAndSave(Bitmap originalBitmap, File output, IEffect effect, Integer orientation) throws IOException
	{
		Bitmap bitmap = null;
		OutputStream stream = null;

		try
		{
			bitmap = effect.process(originalBitmap);
			stream = new FileOutputStream(output.toString());
			bitmap.compress(Bitmap.CompressFormat.JPEG, compressQuality, stream);

			applyOrientationExif(output, orientation);
		}
		finally
		{
			if (bitmap != null)
				bitmap.recycle();

			if (stream != null)
				stream.close();
		}
	}

	public static class PreprocessResult
	{
		@NonNull
		private String originalPhotoPath;
		@NonNull
		private String thumbPhotoPath;

		@NonNull
		private File[] originalWithEffectPaths;

		@NonNull
		private File[] thumbWithEffectPaths;

		public PreprocessResult(@NonNull String originalPhotoPath, @NonNull String thumbPhotoPath, @NonNull File[] originalWithEffectPaths, @NonNull File[] thumbWithEffectPaths)
		{
			this.originalPhotoPath = originalPhotoPath;
			this.thumbPhotoPath = thumbPhotoPath;
			this.originalWithEffectPaths = originalWithEffectPaths;
			this.thumbWithEffectPaths = thumbWithEffectPaths;
		}

		@NonNull
		public String getOriginalPhotoPath()
		{
			return originalPhotoPath;
		}

		@NonNull
		public File[] getOriginalWithEffectPaths()
		{
			return originalWithEffectPaths;
		}

		@NonNull
		public String getThumbPhotoPath()
		{
			return thumbPhotoPath;
		}

		@NonNull
		public File[] getThumbWithEffectPaths()
		{
			return thumbWithEffectPaths;
		}

	}
}
