package com.mydreams.android;

import android.app.Application;
import android.graphics.Bitmap;

import com.mydreams.android.modules.AppComponent;
import com.mydreams.android.modules.AppModule;
import com.mydreams.android.modules.DaggerAppComponent;
import com.mydreams.android.modules.NetWorkModule;
import com.mydreams.android.modules.RealmModule;
import com.mydreams.android.modules.SelectionPhotoModule;
import com.mydreams.android.modules.UserModule;
import com.nostra13.universalimageloader.cache.disc.naming.Md5FileNameGenerator;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.ImageLoaderConfiguration;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.QueueProcessingType;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;
import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.vk.sdk.VKSdk;

import io.fabric.sdk.android.Fabric;

public class App extends Application {
    private static AppComponent component;

    @Override
    public void onCreate() {
        super.onCreate();
        component = buildComponent();
        initVkSdk();
        initTwitter();
        initImageLoader();
    }

    private void initImageLoader() {
        final DisplayImageOptions options = new DisplayImageOptions.Builder()
                .resetViewBeforeLoading(true)
                .cacheOnDisk(true)
                .imageScaleType(ImageScaleType.IN_SAMPLE_POWER_OF_2)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .displayer(new FadeInBitmapDisplayer(300))
                .build();

        final ImageLoaderConfiguration config = new ImageLoaderConfiguration.Builder(getApplicationContext())
                .threadPriority(Thread.NORM_PRIORITY - 2)
                .denyCacheImageMultipleSizesInMemory()
                .diskCacheFileNameGenerator(new Md5FileNameGenerator())
                .defaultDisplayImageOptions(options)
                .tasksProcessingOrder(QueueProcessingType.LIFO)
                .build();

        ImageLoader.getInstance().init(config);
    }

    private void initTwitter() {
        TwitterAuthConfig authConfig = new TwitterAuthConfig(Config.TWITTER_KEY, Config.TWITTER_SECRET);
        Fabric.with(this, new Twitter(authConfig));
    }

    private void initVkSdk() {
        VKSdk.initialize(this);
    }

    protected AppComponent buildComponent() {
        return DaggerAppComponent.builder()
                .appModule(new AppModule(this))
                .netWorkModule(new NetWorkModule())
                .selectionPhotoModule(new SelectionPhotoModule())
                .userModule(new UserModule())
                .realmModule(new RealmModule())
                .build();
    }

    public static AppComponent getComponent() {
        return component;
    }
}
