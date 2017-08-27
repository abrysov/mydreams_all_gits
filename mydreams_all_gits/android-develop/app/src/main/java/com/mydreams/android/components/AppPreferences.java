package com.mydreams.android.components;

import android.content.SharedPreferences;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.models.Field;

import javax.inject.Inject;

/**
 * Created by mikhail on 29.06.16.
 */
public class AppPreferences {

    @Inject
    SharedPreferences preferences;

    public AppPreferences() {
        App.getComponent().inject(this);
    }

    public void resetDreamersFilter() {
        preferences.edit().putString(Config.BUNDLE_COUNTRY, "").apply();
        preferences.edit().putInt(Config.BUNDLE_COUNTRY_ID, 0).apply();
        preferences.edit().putString(Config.BUNDLE_CITY, "").apply();
        preferences.edit().putInt(Config.BUNDLE_CITY_ID, 0).apply();
        preferences.edit().putString(Config.BUNDLE_AGE_FROM, "").apply();
        preferences.edit().putString(Config.BUNDLE_AGE_TO, "").apply();
        preferences.edit().putString(Config.BUNDLE_AGE_TO, "").apply();
        preferences.edit().putInt(Config.BUNDLE_TAB_TAG_DREAMERS_FILTER, 1).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_ALL, 0).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_NEW, 1).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_POPULARS, 1).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_VIP, 1).apply();
        preferences.edit().putInt(Config.BUNDLE_CHECKBOX_ONLINE, 1).apply();
        preferences.edit().putString(Config.BUNDLE_USER_GENDER, "").apply();
        preferences.edit().putString(Field.NEW, "").apply();
        preferences.edit().putString(Field.TOP_DREAMERS, "").apply();
        preferences.edit().putString(Field.VIP, "").apply();
        preferences.edit().putString(Field.ONLINE, "").apply();
    }

    public void clearSavedRegData() {
        preferences.edit().putString(Config.BUNDLE_USER_NAME, "").apply();
        preferences.edit().putString(Config.BUNDLE_USER_LAST_NAME, "").apply();
        preferences.edit().putInt(Config.BUNDLE_USER_BIRTH_DAY, 0).apply();
        preferences.edit().putString(Config.BUNDLE_USER_BIRTH_MONTH, "").apply();
        preferences.edit().putInt(Config.BUNDLE_USER_BIRTH_YEAR, 0).apply();
        preferences.edit().putString(Config.BUNDLE_USER_PHONE, "").apply();
        preferences.edit().putString(Config.BUNDLE_USER_LOCATION, "").apply();
        preferences.edit().putString(Config.BUNDLE_USER_GENDER, "").apply();
        preferences.edit().putString(Config.BUNDLE_USER_PHOTO, "").apply();
    }
}
