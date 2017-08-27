package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.CityResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 20.04.16.
 */
public class SearchCityCaller extends BaseCaller {

    private int countryId;
    private String prefix;

    public SearchCityCaller(int countryId, String prefix, LoaderCallback loaderCallback) {
        super(loaderCallback);

        this.countryId = countryId;
        this.prefix = prefix;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().searchCity(countryId, prefix);
        sendRequest(call, new CityResponse(), this);
    }
}
