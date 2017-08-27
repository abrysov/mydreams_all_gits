package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.CountryCaller;
import com.mydreams.android.net.callers.SearchCountryCaller;

/**
 * Created by mikhail on 18.04.16.
 */
public class CountryManager extends BaseManager {

    private OnCountrySaveListener countrySaveListener;

    public Cancelable loadCountryList() {
        return new CountryCaller(this);
    }

    public Cancelable searchCountry(String prefix) {
        return new SearchCountryCaller(prefix, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        countrySaveListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        countrySaveListener.error(errMsg);
    }

    public void setOnSaveCountryListener(OnCountrySaveListener countrySaveListener) {
        this.countrySaveListener = countrySaveListener;
    }

    public interface OnCountrySaveListener {
        void complete();
        void error(String errMsg);
    }
}
