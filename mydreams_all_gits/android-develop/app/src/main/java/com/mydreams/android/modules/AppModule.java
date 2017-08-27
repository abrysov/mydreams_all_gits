package com.mydreams.android.modules;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.support.annotation.NonNull;
import android.widget.ImageView;

import com.mydreams.android.Config;
import com.mydreams.android.components.AppPreferences;
import com.mydreams.android.components.NotificationSnackBar;
import com.mydreams.android.components.SettingsToolbar;
import com.mydreams.android.components.SessionService;
import com.nostra13.universalimageloader.core.DisplayImageOptions;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.ImageScaleType;
import com.nostra13.universalimageloader.core.assist.LoadedFrom;
import com.nostra13.universalimageloader.core.display.BitmapDisplayer;
import com.nostra13.universalimageloader.core.display.FadeInBitmapDisplayer;

import javax.inject.Singleton;

import dagger.Module;
import dagger.Provides;

/**
 * Created by mikhail on 28.03.16.
 */
@Module()
public class AppModule {

    private Context appContext;

    public AppModule(@NonNull Context context) {
        appContext = context;
    }

    @Provides
    @Singleton
    Context provideContext() {
        return appContext;
    }

    @Provides
    @Singleton
    SharedPreferences provideSharedPreferences() {
        return appContext.getSharedPreferences(Config.APP_PREFERENCES, Context.MODE_PRIVATE);
    }

    @Provides
    SessionService provideSessionService() {
        return new SessionService();
    }

    @Provides
    ImageLoader providesImageLoader() {
        ImageLoader mImageLoader = ImageLoader.getInstance();
        return mImageLoader;
    }

    @Provides
    DisplayImageOptions providesImageOption() {
        DisplayImageOptions mImageOptions = new DisplayImageOptions.Builder()
                .resetViewBeforeLoading(true)
                .cacheInMemory(true)
                .cacheOnDisk(true)
                .imageScaleType(ImageScaleType.IN_SAMPLE_POWER_OF_2)
                .considerExifParams(true)
                .bitmapConfig(Bitmap.Config.RGB_565)
                .displayer(new FadeInBitmapDisplayer(300))
                .resetViewBeforeLoading(true)
                .build();
        return mImageOptions;
    }

    @Provides
    @Singleton
    SettingsToolbar provideSettingToolbar() {
        return new SettingsToolbar();
    }

    @Provides
    NotificationSnackBar provideNotificationSnackBar() {
        return new NotificationSnackBar();
    }

    @Provides
    AppPreferences provideAppPreferences() {
        return new AppPreferences();
    }
}
