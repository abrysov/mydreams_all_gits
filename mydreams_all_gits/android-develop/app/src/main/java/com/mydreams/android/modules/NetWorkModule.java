package com.mydreams.android.modules;

import com.mydreams.android.manager.AgreementManager;
import com.mydreams.android.manager.Authorization;
import com.mydreams.android.manager.AuthorizationManager;
import com.mydreams.android.manager.CityManager;
import com.mydreams.android.manager.CountryManager;
import com.mydreams.android.manager.DreamersListManager;
import com.mydreams.android.manager.DreamsListManager;
import com.mydreams.android.manager.ProfileRecoveryManager;
import com.mydreams.android.manager.RecoveryPasswordManager;
import com.mydreams.android.manager.RegistrationManager;
import com.mydreams.android.manager.UserManager;

import dagger.Module;
import dagger.Provides;

/**
 * Created by mikhail on 09.03.16.
 */
@Module()
public class NetWorkModule {

    @Provides
    AuthorizationManager provideAuthorizationManager() {
        return new AuthorizationManager();
    }

    @Provides
    RetrofitService providesRetrofitService() {
        return new RetrofitService();
    }

    @Provides
    Authorization provideSocialAuth() {
        return new AuthorizationManager();
    }

    @Provides
    UserManager provideUserManager() {
        return new UserManager();
    }

    @Provides
    CountryManager provideCountryManager() {
        return new CountryManager();
    }

    @Provides
    RecoveryPasswordManager provideRecoveryPasswordManager() {
        return new RecoveryPasswordManager();
    }

    @Provides
    ProfileRecoveryManager provideProfileRecoveryManager() {
        return new ProfileRecoveryManager();
    }

    @Provides
    CityManager provideCityManager() {
        return new CityManager();
    }

    @Provides
    AgreementManager provideAgreementManager() {
        return new AgreementManager();
    }

    @Provides
    DreamsListManager provideDreamsListManager() {
        return new DreamsListManager();
    }

    @Provides
    DreamersListManager provideDreamersListManager() {
        return new DreamersListManager();
    }

    @Provides
    RegistrationManager provideRegistrationManager() {
        return new RegistrationManager();
    }
}
