package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.CityHelper;
import com.mydreams.android.models.City;
import com.mydreams.android.models.Field;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityResponse extends BaseResponse {

    @Inject
    CityHelper cityHelper;

    public CityResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        List<City> cityList = getParsedCityList(getTypedAnswer());
        if (cityList != null) {
            return cityHelper.addCitiesFormList(cityList);
        }
        return false;
    }

    private List<City> getParsedCityList(Object typedAnswer) {
        List<City> cityList = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONArray citiesArray = jsonObject.getJSONArray(Field.CITIES);
            cityList = new ArrayList<City>();
            JSONObject cities;

            for (int i = 0; i < citiesArray.length(); i++) {
                cities = citiesArray.getJSONObject(i);
                City city = new City();
                city.setCityId(cities.getInt(Field.ID));
                city.setCityName(cities.isNull(Field.NAME) ? null : cities.getString(Field.NAME));
                city.setCityMeta(cities.isNull(Field.CITY_META) ? null : cities.getString(Field.CITY_META));

                cityList.add(city);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return cityList;
    }
}
