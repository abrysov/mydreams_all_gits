package com.mydreams.android.modules;

import android.content.SharedPreferences;
import android.util.Base64;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.database.AccessTokenHelper;
import com.mydreams.android.models.AccessTokenModel;
import com.mydreams.android.net.Url;

import java.io.IOException;
import java.util.Locale;

import javax.inject.Inject;

import okhttp3.Interceptor;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by mikhail on 30.03.16.
 */
public class RetrofitService {

    private String encodedCredentials;

    @Inject
    AccessTokenHelper accessTokenHelper;

    public RetrofitService() {
        App.getComponent().inject(this);
    }

    public Retrofit getRetrofit() {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(Url.BASE_URL)
                .client(getClient())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        return retrofit;
    }

    Interceptor interceptor = new Interceptor() {
        @Override
        public okhttp3.Response intercept(Chain chain) throws IOException {
            Request original = chain.request();
            Request.Builder requestBuilder = original.newBuilder();
            if (!getAccessToken().isEmpty()) {
                requestBuilder.addHeader(Url.HEADER_AUTHORIZATION, Url.BEARER + " " + getAccessToken());
            } else {
                requestBuilder.addHeader(Url.HEADER_AUTHORIZATION, getEncodeCredentials());
            }
            requestBuilder.addHeader(Url.HEADER_ACCEPT_LANGUAGE, getLocaleLanguage());
            Request request = requestBuilder.build();
            return chain.proceed(request);
        }
    };

    private String getAccessToken() {
        AccessTokenModel accessTokenModel = accessTokenHelper.getAccessTokenModel();
        if (accessTokenModel != null) {
            return accessTokenModel.getAccessToken();
        }
        return "";
    }

    private OkHttpClient getClient() {
        HttpLoggingInterceptor httpLoggingInterceptor = new HttpLoggingInterceptor();
        httpLoggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY);

        OkHttpClient.Builder builder = new OkHttpClient.Builder();
        builder.interceptors().add(interceptor);
        builder.addInterceptor(httpLoggingInterceptor);
        OkHttpClient client = builder.build();
        return client;
    }

    private String getEncodeCredentials() {
        String credentials = Url.LOGIN + ":" + Url.PASSWORD;
        encodedCredentials = Base64.encodeToString(credentials.getBytes(), Base64.NO_WRAP);
        return encodedCredentials;
    }

    private String getLocaleLanguage() {
        String language = Locale.getDefault().toString();
        return language.replace("_", "-");
    }
}
