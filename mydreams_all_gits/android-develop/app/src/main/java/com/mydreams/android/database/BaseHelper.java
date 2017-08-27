package com.mydreams.android.database;
import com.mydreams.android.App;

import javax.inject.Inject;

import io.realm.Realm;
import io.realm.RealmConfiguration;

/**
 * Created by mikhail on 22.04.16.
 */
public class BaseHelper {

    @Inject
    RealmConfiguration realmConfiguration;

    public BaseHelper() {
        App.getComponent().inject(this);
    }

    protected Realm realm() {
        Realm realm = Realm.getInstance(realmConfiguration);
        return realm;
    }
}
