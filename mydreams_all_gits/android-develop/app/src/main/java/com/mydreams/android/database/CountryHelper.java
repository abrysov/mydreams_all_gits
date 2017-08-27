package com.mydreams.android.database;

import com.mydreams.android.models.Country;

import java.util.List;

/**
 * Created by mikhail on 18.04.16.
 */
public class CountryHelper extends BaseHelper {

    public boolean saveCountriesFormList(List<Country> countryList) {
        try{
            removeAllCountries();
            realm().beginTransaction();
            realm().copyToRealm(countryList);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void removeAllCountries() {
        realm().beginTransaction();
        realm().delete(Country.class);
        realm().commitTransaction();
    }

    public List<Country> getCountryList() {
        return realm().where(Country.class).findAll();
    }
}
