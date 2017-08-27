package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.CityResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityCaller extends BaseCaller {
    private int countryId;

    public CityCaller(int countryId, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.countryId = countryId;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadCityList(countryId);
        sendRequest(call, new CityResponse(), this);
    }
}
