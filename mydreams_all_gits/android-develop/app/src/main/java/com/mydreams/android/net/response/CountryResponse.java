package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.CountryHelper;
import com.mydreams.android.models.Country;
import com.mydreams.android.models.Field;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

/**
 * Created by mikhail on 18.04.16.
 */
public class CountryResponse extends BaseResponse {

    @Inject
    CountryHelper countryHelper;

    public CountryResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        List<Country> countryList = getParsedCountryList(getTypedAnswer());
        if (countryList != null) {
            return countryHelper.saveCountriesFormList(countryList);
        }
        return false;
    }

    private List<Country> getParsedCountryList(Object typedAnswer) {
        List<Country> countryList = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONArray countriesArray = jsonObject.getJSONArray(Field.COUNTRIES);
            countryList = new ArrayList<Country>();
            JSONObject countries;

            for (int i = 0; i < countriesArray.length(); i++) {
                countries = countriesArray.getJSONObject(i);
                Country country = new Country();
                country.setId(countries.getInt(Field.ID));
                country.setNameCountry(countries.isNull(Field.NAME) ? null : countries.getString(Field.NAME));

                countryList.add(country);
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return countryList;
    }
}
