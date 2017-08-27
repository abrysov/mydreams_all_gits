package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.AgreementResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 20.04.16.
 */
public class AgreementCaller extends BaseCaller {

    public AgreementCaller(LoaderCallback loaderCallback) {
        super(loaderCallback);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadAgreement();
        sendRequest(call, new AgreementResponse(), this);
    }
}
