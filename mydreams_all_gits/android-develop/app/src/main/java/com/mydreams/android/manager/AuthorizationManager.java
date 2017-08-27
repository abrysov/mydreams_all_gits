package com.mydreams.android.manager;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.support.v4.app.FragmentActivity;
import android.widget.Toast;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.components.InstagramApp;
import com.mydreams.android.database.AccessTokenHelper;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.callers.AccessTokenCaller;
import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.UserCaller;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterAuthClient;
import com.vk.sdk.VKAccessToken;
import com.vk.sdk.VKCallback;
import com.vk.sdk.VKSdk;
import com.vk.sdk.api.VKError;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

/**
 * Created by mikhail on 03.03.16.
 */
public class AuthorizationManager extends BaseManager implements Authorization {

    private static final String FACEBOOK = "facebook";
    private static final String VKONTAKTE = "vkontakte";
    private static final String INSTAGRAM = "instagram";
    private static final String TWITTER = "twitter";

    public static final String INSTAGRAM_CLIENT_ID = "c53575532542455d812918836156fec5";
    public static final String INSTAGRAM_CLIENT_SECRET = "64b389607ed74aed8e88dad7bf746123";
    public static final String INSTAGRAM_CALLBACK_URL = "http://staging.mydreams.club/social/auth/instagram";

    @Inject
    SharedPreferences preferences;
    @Inject
    AccessTokenHelper accessTokenHelper;
    @Inject
    UserManager userManager;
    @Inject
    Context context;

    private CallbackManager callbackManager;
    private OnAuthListener onAuthListener;

    private InstagramApp instagramApp;

    private TwitterAuthClient twitterAuthClient;
    private Map<String, String> credentials;
    private String email;
    private boolean needLoadProfile = true;

    public AuthorizationManager() {
        App.getComponent().inject(this);
        initTwitterClient();
        callbackManager = CallbackManager.Factory.create();
    }

    private void initTwitterClient() {
        twitterAuthClient = new TwitterAuthClient();
    }

    @Override
    public Cancelable authorization(Map<String, String> credentials) {
        this.credentials = credentials;
        return new AccessTokenCaller(credentials, this);
    }

    @Override
    public void getFacebookToken(FragmentActivity activity) {
        LoginManager.getInstance().logInWithPublishPermissions(activity, Arrays.asList("publish_actions"));
        LoginManager.getInstance().registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                AccessToken token = loginResult.getAccessToken();
                String accessToken = token.getToken();

                preferences.edit().putString(Config.FACEBOOK_USER_TOKEN, accessToken).commit();

                authSocial(accessToken, FACEBOOK);
            }

            @Override
            public void onCancel() {

            }

            @Override
            public void onError(FacebookException error) {
                Toast.makeText(context, error.toString(), Toast.LENGTH_LONG).show();
            }
        });
    }

    @Override
    public void getVKToken(FragmentActivity activity) {
        VKSdk.login(activity, new String[]{"wall", "photos", "email"});
    }

    @Override
    public void getInstagramToken(FragmentActivity activity) {
        instagramApp = new InstagramApp(activity, INSTAGRAM_CLIENT_ID, INSTAGRAM_CLIENT_SECRET, INSTAGRAM_CALLBACK_URL);
        instagramApp.authorize();
        instagramApp.setListener(new InstagramApp.OAuthAuthenticationListener() {
            @Override
            public void onSuccess(String accessToken) {
                preferences.edit().putString(Config.INSTAGRAM_ACCESS_TOKEN, accessToken).commit();

                authSocial(accessToken, INSTAGRAM);
            }

            @Override
            public void onFail(String error) {
                showNotificationError(error);
            }
        });
    }

    public void getTwitterToken(FragmentActivity activity) {
        twitterAuthClient.authorize(activity, new Callback<TwitterSession>() {
            @Override
            public void success(Result<TwitterSession> result) {
                String accessToken = result.data.getAuthToken().token;
                preferences.edit().putString(Config.TWITTER_ACCESS_TOKEN, accessToken).commit();

                authSocial(accessToken, TWITTER);
            }

            @Override
            public void failure(TwitterException e) {
                showNotificationError(e.getMessage());
            }
        });
    }

    @Override
    public void authSocial(String accessToken, String typeSocial) {
        credentials = new HashMap<>();
        credentials.put(Field.GRANT_TYPE, "assertion");
        credentials.put(Field.ASSERTION, accessToken);

        if (email != null && !email.isEmpty()) {
            credentials.put(Field.EMAIL, email);
        }

        credentials.put(Field.PROVIDER, typeSocial);

        authorization(credentials);
    }

    public void needLoadProfile(boolean needLoadProfile) {
        this.needLoadProfile = needLoadProfile;
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (!VKSdk.onActivityResult(requestCode, resultCode, data, new VKCallback<VKAccessToken>() {
            @Override
            public void onResult(VKAccessToken res) {
                preferences.edit().putString(Config.VK_ACCESS_TOKEN, res.accessToken).commit();
                preferences.edit().putString(Config.VK_USER_EMAIL, res.email).commit();

                email = res.email;
                authSocial(res.accessToken, VKONTAKTE);
            }
            @Override
            public void onError(VKError error) {
                showNotificationError(error.errorMessage);
            }
        }));
        twitterAuthClient.onActivityResult(requestCode, resultCode, data);
        callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    public void setAuthListener(OnAuthListener onAuthListener) {
        this.onAuthListener = onAuthListener;
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        if (onAuthListener != null) {
            onAuthListener.complete();
        }

        if (needLoadProfile) {
            authComplete();
        }
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        if (caller instanceof AccessTokenCaller) {
            if (onAuthListener != null) {
                onAuthListener.error(errMsg);
            } else {
                showNotificationError(errMsg);
            }
        } else if (caller instanceof UserCaller) {
            saveUserListener.error(errMsg);
        }
    }

    private void authComplete() {
        userManager.setUserSaveListener(saveUserListener);
        userManager.loadUserInfo();
    }

    private UserManager.OnUserSaveListener saveUserListener = new UserManager.OnUserSaveListener() {
        @Override
        public void complete() {
            Intent intent = new Intent(Config.IF_OPEN_FRAGMENT_BY_USER_STATE);
            context.sendBroadcast(intent);
        }

        @Override
        public void error(String errMsg) {
            showNotificationError(errMsg);
        }
    };

    public interface OnAuthListener {
        void complete();
        void error(String errMsg);
    }

    private void showNotificationError(String errMsg) {
        Toast.makeText(context, errMsg, Toast.LENGTH_SHORT).show();
    }
}
