package com.mydreams.android.net.callers;
import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.CountryResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 18.04.16.
 */
public class CountryCaller extends BaseCaller {

    public CountryCaller(LoaderCallback loaderCallback) {
        super(loaderCallback);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadCountryList();
        sendRequest(call, new CountryResponse(), this);
    }
}
