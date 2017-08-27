package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.UserResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 14.04.16.
 */
public class UserCaller extends BaseCaller {

    public UserCaller(LoaderCallback loaderCallback) {
        super(loaderCallback);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadUserInfo();
        sendRequest(call, new UserResponse(true), this);
    }
}
