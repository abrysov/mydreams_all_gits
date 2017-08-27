package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.BaseResponse;

import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 11.07.16.
 */
public class ChangePasswordCaller extends BaseCaller {

    private Map<String, Object> credentials;

    public ChangePasswordCaller(Map<String, Object> credentials, LoaderCallback loaderCallback) {
        super(loaderCallback);

        this.credentials = credentials;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().changePassword(credentials, "");
        sendRequest(call, new BaseResponse(), this, false);
    }
}
