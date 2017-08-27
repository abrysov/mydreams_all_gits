package com.mydreams.android.modules;

import android.content.Context;

import com.mydreams.android.database.AccessTokenHelper;
import com.mydreams.android.database.AgreementHelper;
import com.mydreams.android.database.AvatarHelper;
import com.mydreams.android.database.CityHelper;
import com.mydreams.android.database.CountryHelper;
import com.mydreams.android.database.DreamHelper;
import com.mydreams.android.database.DreamerHelper;
import com.mydreams.android.database.PaginationHelper;
import com.mydreams.android.database.UserHelper;

import dagger.Module;
import dagger.Provides;
import io.realm.Realm;
import io.realm.RealmConfiguration;

/**
 * Created by mikhail on 30.03.16.
 */
@Module
public class RealmModule {

    @Provides
    Realm provideRealm(RealmConfiguration realmConfiguration) {
        return Realm.getInstance(realmConfiguration);
    }

    @Provides
    RealmConfiguration provideRealmConfiguration(Context context) {
        RealmConfiguration realmConfiguration = new RealmConfiguration.Builder(context)
                .name("mydreams")
                .schemaVersion(2)
                .deleteRealmIfMigrationNeeded()
                .build();
        return realmConfiguration;
    }

    @Provides
    AccessTokenHelper provideAccessTokenHelper() {
        return new AccessTokenHelper();
    }

    @Provides
    UserHelper provideUserHelper() {
        return new UserHelper();
    }

    @Provides
    CountryHelper provideCountryHelper() {
        return new CountryHelper();
    }

    @Provides
    CityHelper provideCityHelper() {
        return new CityHelper();
    }

    @Provides
    AgreementHelper provideAgreementHelper() {
        return new AgreementHelper();
    }

    @Provides
    DreamHelper provideDreamHelper() {
        return new DreamHelper();
    }

    @Provides
    DreamerHelper provideDreamerHelper() {
        return new DreamerHelper();
    }

    @Provides
    AvatarHelper provideAvatarHelper() {
        return new AvatarHelper();
    }

    @Provides
    PaginationHelper providePaginationHelper() {
        return new PaginationHelper();
    }
}
