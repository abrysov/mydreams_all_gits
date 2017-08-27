package com.mydreams.android.components;

import android.content.SharedPreferences;

import com.mydreams.android.App;
import com.mydreams.android.database.AccessTokenHelper;

import javax.inject.Inject;

import io.realm.Realm;
import io.realm.RealmConfiguration;

/**
 * Created by mikhail on 27.04.16.
 */
public class SessionService {

    @Inject
    AccessTokenHelper accessTokenHelper;
    @Inject
    SharedPreferences preferences;
    @Inject
    RealmConfiguration realmConfiguration;
    @Inject
    Realm realm;

    public SessionService() {
        App.getComponent().inject(this);
    }

    public boolean isAuthorized() {
        return accessTokenHelper.existAccessToken();
    }

    public void logout() {
        realm.beginTransaction();
        realm.deleteAll();
        realm.commitTransaction();
        preferences.edit().clear().apply();
    }
}
