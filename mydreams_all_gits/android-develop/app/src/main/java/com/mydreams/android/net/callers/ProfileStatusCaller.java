package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.UserResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 6/10/16.
 */
public class ProfileStatusCaller extends BaseCaller {

    public ProfileStatusCaller(LoaderCallback loaderCallback) {
        super(loaderCallback);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadProfileStatus();
        sendRequest(call, new UserResponse(false), this);
    }
}
