package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.BaseResponse;
import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 18.04.16.
 */
public class RecoveryPasswordCaller extends BaseCaller {

    private Map<String, String> email;

    public RecoveryPasswordCaller(Map<String, String> email, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.email = email;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().recoveryPassword(email);
        sendRequest(call, new BaseResponse(), this, false);
    }
}
