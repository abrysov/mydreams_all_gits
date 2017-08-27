package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.CountryResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 18.04.16.
 */
public class SearchCountryCaller extends BaseCaller {

    private String prefix;

    public SearchCountryCaller(String prefix, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.prefix = prefix;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().searchCountry(prefix);
        sendRequest(call, new CountryResponse(), this);
    }
}
