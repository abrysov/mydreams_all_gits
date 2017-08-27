package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.net.response.CityAddResponse;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityAddCaller extends BaseCaller {

    private int countryId;
    private String cityName;
    private String regionName;
    private String districtName;

    public CityAddCaller(int countryId, String cityName, String regionName, String districtName, LoaderCallback loaderCallback) {
        super(loaderCallback);
        this.countryId = countryId;
        this.cityName = cityName;
        this.regionName = regionName;
        this.districtName = districtName;

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().sendToAddCity(countryId, cityName, regionName, districtName, "");
        sendRequest(call, new CityAddResponse(), this);
    }
}
