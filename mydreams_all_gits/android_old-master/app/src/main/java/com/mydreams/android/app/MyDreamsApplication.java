package com.mydreams.android.app;

import android.app.Application;
import android.os.Build;
import android.os.StrictMode;

import com.crashlytics.android.Crashlytics;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.imagepipeline.core.ImagePipelineConfig;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.utils.LogImageCacheStatsTracker;
import com.mydreams.android.utils.ManualResetEvent;
import com.rey.material.app.ThemeManager;
import com.squareup.leakcanary.LeakCanary;
import com.squareup.leakcanary.RefWatcher;

import butterknife.ButterKnife;
import io.fabric.sdk.android.Fabric;

public class MyDreamsApplication extends Application //MultiDexApplication
{
	private static MyDreamsApplication instance;
	private RefWatcher refWatcher;

	public static MyDreamsApplication getInstance()
	{
		if (instance == null)
			throw new IllegalStateException();

		return instance;
	}

	/*@Override
	protected void attachBaseContext(Context base)
	{
		super.attachBaseContext(base);
		MultiDex.install(this);
	}*/

	private static void setInstance(MyDreamsApplication instance)
	{
		MyDreamsApplication.instance = instance;
	}

	public static RefWatcher getRefWatcher()
	{
		return getInstance().refWatcher;
	}

	@Override
	public void onCreate()
	{
		super.onCreate();
		Fabric.with(this, new Crashlytics());
		setInstance(this);

		ButterKnife.setDebug(BuildConfig.DEBUG);

		ImagePipelineConfig config = ImagePipelineConfig.newBuilder(this)
				.setDownsampleEnabled(true)
				.setImageCacheStatsTracker(new LogImageCacheStatsTracker())
				.build();

		Fresco.initialize(this, config);

		if (BuildConfig.DEBUG)
		{
			Fresco.getImagePipelineFactory().getMainDiskStorageCache().clearAll();
			Fresco.getImagePipelineFactory().getSmallImageDiskStorageCache().clearAll();
		}

		if (BuildConfig.DEBUG)
		{
			enabledStrictMode();
		}

		refWatcher = installLeakCanary();

		ManualResetEvent event = new ManualResetEvent(false);
		new Thread(() ->
		{
			//иногда падает получение настроек из SharedPreferences если выполнять в UI потоке, рандомно и в дебаге с StrictMode
			ThemeManager.init(MyDreamsApplication.this, 1, 0, null);
			event.set();
		}).start();

		try
		{
			event.waitOne();
		}
		catch (InterruptedException e)
		{
			e.printStackTrace();
		}
	}

	@Override
	public void onTerminate()
	{
		setInstance(null);

		super.onTerminate();
	}

	private void enabledStrictMode()
	{
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.GINGERBREAD)
		{
			StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder() //
					.detectAll()
					.penaltyDeath()
					.penaltyLog()
					.build());

			StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()
					.detectAll()
					.penaltyLog()
					.build());
		}
	}

	protected RefWatcher installLeakCanary()
	{
		if (BuildConfig.DEBUG)
		{
			return LeakCanary.install(this);
		}
		else
		{
			return RefWatcher.DISABLED;
		}
	}
}