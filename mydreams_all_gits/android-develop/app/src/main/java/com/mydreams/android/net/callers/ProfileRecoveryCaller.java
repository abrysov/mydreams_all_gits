package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.BaseResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 19.04.16.
 */
public class ProfileRecoveryCaller extends BaseCaller {

    public ProfileRecoveryCaller(LoaderCallback loaderCallback) {
        super(loaderCallback);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().recoveryProfile("");
        sendRequest(call, new BaseResponse(), this, false);
    }
}
