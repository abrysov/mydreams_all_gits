package com.mydreams.android.utils;

import android.util.Log;

import com.facebook.imagepipeline.cache.CountingMemoryCache;
import com.facebook.imagepipeline.cache.ImageCacheStatsTracker;

public class LogImageCacheStatsTracker implements ImageCacheStatsTracker
{
	private static final String TAG = LogImageCacheStatsTracker.class.getSimpleName();

	@Override
	public void onBitmapCacheHit()
	{
		Log.d(TAG, "onBitmapCacheHit");
	}

	@Override
	public void onBitmapCacheMiss()
	{
		Log.d(TAG, "onBitmapCacheMiss");
	}

	@Override
	public void onBitmapCachePut()
	{
		Log.d(TAG, "onBitmapCachePut");
	}

	@Override
	public void onDiskCacheGetFail()
	{
		Log.d(TAG, "onDiskCacheGetFail");
	}

	@Override
	public void onDiskCacheHit()
	{
		Log.d(TAG, "onDiskCacheHit");
	}

	@Override
	public void onDiskCacheMiss()
	{
		Log.d(TAG, "onDiskCacheMiss");
	}

	@Override
	public void onMemoryCacheHit()
	{
		Log.d(TAG, "onMemoryCacheHit");
	}

	@Override
	public void onMemoryCacheMiss()
	{
		Log.d(TAG, "onMemoryCacheMiss");
	}

	@Override
	public void onMemoryCachePut()
	{
		Log.d(TAG, "onMemoryCachePut");
	}

	@Override
	public void onStagingAreaHit()
	{
		Log.d(TAG, "onStagingAreaHit");
	}

	@Override
	public void onStagingAreaMiss()
	{
		Log.d(TAG, "onStagingAreaMiss");
	}

	@Override
	public void registerBitmapMemoryCache(CountingMemoryCache<?, ?> countingMemoryCache)
	{
		Log.d(TAG, "registerBitmapMemoryCache");
	}

	@Override
	public void registerEncodedMemoryCache(CountingMemoryCache<?, ?> countingMemoryCache)
	{
		Log.d(TAG, "registerEncodedMemoryCache");
	}
}
