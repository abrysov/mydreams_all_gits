package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.UserResponse;

import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 29.04.16.
 */
public class RegistrationCaller extends BaseCaller {

    private Map<String, Object> credentials;

    public RegistrationCaller(Map<String, Object> credentials, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.credentials = credentials;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().sendUserRegData(credentials);
        sendRequest(call, new UserResponse(true), this);
    }
}
