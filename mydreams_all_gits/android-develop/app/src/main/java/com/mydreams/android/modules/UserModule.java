package com.mydreams.android.modules;

import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.User;

import dagger.Module;
import dagger.Provides;

/**
 * Created by mikhail on 30.03.16.
 */
@Module
public class UserModule {

    @Provides
    User provideUser() {
        return new User();
    }

    @Provides
    Avatar provideAvatar() {
        return new Avatar();
    }
}
