package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.CityHelper;
import com.mydreams.android.models.City;
import com.mydreams.android.models.Field;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityAddResponse extends BaseResponse {

    @Inject
    CityHelper cityHelper;

    public CityAddResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        City city = getParsedCity(getTypedAnswer());
        if (city != null) {
            cityHelper.saveAddedCity(city);
            return true;
        }
        return false;
    }

    private City getParsedCity(Object typedAnswer) {
        City city = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONObject jsonCity = jsonObject.getJSONObject(Field.CITY);

            city = new City();
            city.setCityId(jsonCity.getInt(Field.ID));
            city.setCityName(jsonCity.getString(Field.NAME));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return city;
    }
}
