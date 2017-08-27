package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.AccessTokenResponse;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 13.04.16.
 */
public class AccessTokenCaller extends BaseCaller {

    private Map<String, String> credentials;

    public AccessTokenCaller(Map<String, String> credentials, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.credentials = credentials;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().authorization(credentials);
        sendRequest(call, new AccessTokenResponse(), this);
    }
}
