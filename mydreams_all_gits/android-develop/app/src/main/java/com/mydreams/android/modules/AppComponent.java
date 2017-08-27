package com.mydreams.android.modules;

import com.mydreams.android.MainActivity;
import com.mydreams.android.activities.ChangeEmail;
import com.mydreams.android.activities.ChangePassword;
import com.mydreams.android.activities.AddFulfilledDream;
import com.mydreams.android.activities.DreamersFilter;
import com.mydreams.android.activities.EditProfile;
import com.mydreams.android.activities.SelectionLocality;
import com.mydreams.android.activities.SelectionLocation;
import com.mydreams.android.adapters.DreamListAdapter;
import com.mydreams.android.adapters.DreamersListAdapter;
import com.mydreams.android.components.AppPreferences;
import com.mydreams.android.components.SelectionPhotoDialog;
import com.mydreams.android.components.SessionService;
import com.mydreams.android.database.BaseHelper;
import com.mydreams.android.database.DreamerHelper;
import com.mydreams.android.fragments.AgreementFragment;
import com.mydreams.android.fragments.AuthorizationFragment;
import com.mydreams.android.fragments.DreamerListFragment;
import com.mydreams.android.fragments.FulfillDreamFragment;
import com.mydreams.android.fragments.FulfilledDreamFragment;
import com.mydreams.android.fragments.DreamListFragment;
import com.mydreams.android.fragments.ProfileFragment;
import com.mydreams.android.fragments.ProfileRecoveryFragment;
import com.mydreams.android.fragments.RecoveryPasswordFragment;
import com.mydreams.android.fragments.RegFirstStageFragment;
import com.mydreams.android.fragments.RegSecondStageFragment;
import com.mydreams.android.fragments.RegThirdStageFragment;
import com.mydreams.android.fragments.SelectionLocalityFragment;
import com.mydreams.android.fragments.SelectionLocationFragment;
import com.mydreams.android.fragments.SendRegDataFragment;
import com.mydreams.android.fragments.SettingsFragment;
import com.mydreams.android.manager.AuthorizationManager;
import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.response.AccessTokenResponse;
import com.mydreams.android.net.response.AgreementResponse;
import com.mydreams.android.net.response.CityAddResponse;
import com.mydreams.android.net.response.CityResponse;
import com.mydreams.android.net.response.CountryResponse;
import com.mydreams.android.net.response.CreateAvatarResponse;
import com.mydreams.android.net.response.DreamListResponse;
import com.mydreams.android.net.response.DreamerListResponse;
import com.mydreams.android.net.response.PaginationResponse;
import com.mydreams.android.net.response.UserResponse;

import javax.inject.Singleton;

import dagger.Component;

/**
 * Created by mikhail on 28.03.16.
 */
@Component(modules = {AppModule.class, NetWorkModule.class, SelectionPhotoModule.class, UserModule.class, RealmModule.class})
@Singleton
public interface AppComponent {
    void inject(MainActivity mainActivity);
    void inject(RegFirstStageFragment regFirstStageFragment);
    void inject(AuthorizationFragment authorizationFragment);
    void inject(RegThirdStageFragment regThirdStageFragment);
    void inject(RecoveryPasswordFragment redirectPasswordFragment);
    void inject(RegSecondStageFragment regSecondStageFragment);
    void inject(ProfileRecoveryFragment profileRecoveryFragment);
    void inject(AuthorizationManager socialAuthorizationManager);
    void inject(RetrofitService retrofitService);
    void inject(SelectionLocationFragment selectionLocationFragment);
    void inject(UserResponse userResponse);
    void inject(CountryResponse countryResponse);
    void inject(BaseCaller baseCaller);
    void inject(AccessTokenResponse accessTokenResponse);
    void inject(SelectionLocalityFragment selectionLocalityFragment);
    void inject(CityResponse cityResponse);
    void inject(CityAddResponse cityAddResponse);
    void inject(AgreementFragment agreementFragment);
    void inject(AgreementResponse agreementResponse);
    void inject(BaseHelper baseHelper);
    void inject(SessionService sessionService);
    void inject(DreamListResponse dreamListResponse);
    void inject(DreamListAdapter dreamListAdapter);
    void inject(FulfilledDreamFragment fulfilledDreamFragment);
    void inject(ProfileFragment profileFragment);
    void inject(DreamListFragment dreamListFragment);
    void inject(DreamerListFragment dreamerListFragment);
    void inject(DreamersListAdapter dreamersListAdapter);
    void inject(DreamerHelper dreamerHelper);
    void inject(DreamerListResponse dreamerResponse);
    void inject(FulfillDreamFragment fulfillDreamFragment);
    void inject(DreamersFilter dreamersFilter);
    void inject(SelectionPhotoDialog selectionPhotoDialog);
    void inject(SettingsFragment settingsFragment);
    void inject(CreateAvatarResponse createAvatarResponse);
    void inject(PaginationResponse paginationResponse);
    void inject(SelectionLocation selectionLocation);
    void inject(SelectionLocality selectionLocality);
    void inject(AppPreferences appPreferences);
    void inject(ChangeEmail changeEmail);
    void inject(EditProfile editProfile);
    void inject(ChangePassword changePassword);
    void inject(AddFulfilledDream addFulfilledDream);
    void inject(SendRegDataFragment sendRegDataFragment);
}
