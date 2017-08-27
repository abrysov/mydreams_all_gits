package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.CityAddCaller;
import com.mydreams.android.net.callers.CityCaller;
import com.mydreams.android.net.callers.SearchCityCaller;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityManager extends BaseManager {

    private OnSaveCityListener saveCityListener;
    private OnAddCityListener addCityListener;

    public Cancelable loadCityList(int countryId) {
        return new CityCaller(countryId, this);
    }

    public Cancelable searchCity(int countryId, String prefix) {
        return new SearchCityCaller(countryId, prefix, this);
    }

    public Cancelable sendToAddCity(int countryId, String cityName, String regionName, String districtName) {
        return new CityAddCaller(countryId, cityName, regionName, districtName, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        if (caller instanceof CityCaller) {
            saveCityListener.complete();
        } else if (caller instanceof SearchCityCaller) {
            saveCityListener.complete();
        } else if (caller instanceof CityAddCaller) {
            addCityListener.complete();
        }
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        if (caller instanceof CityCaller) {
            saveCityListener.error(errMsg);
        } else if (caller instanceof SearchCityCaller) {
            saveCityListener.error(errMsg);
        } else if (caller instanceof CityAddCaller) {
            addCityListener.error(errMsg);
        }
    }

    public void setOnSaveCityListener(OnSaveCityListener saveCityListener) {
        this.saveCityListener = saveCityListener;
    }

    public void setOnAddCityListener(OnAddCityListener addCityListener) {
        this.addCityListener = addCityListener;
    }

    public interface OnSaveCityListener {
        void complete();
        void error(String errMsg);
    }

    public interface OnAddCityListener {
        void complete();
        void error(String errMsg);
    }
}
