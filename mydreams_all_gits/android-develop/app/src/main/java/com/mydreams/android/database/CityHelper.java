package com.mydreams.android.database;

import com.mydreams.android.models.City;

import java.util.List;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityHelper extends BaseHelper {

    public boolean addCitiesFormList(List<City> cityList) {
        try {
            removeAllCities();
            realm().beginTransaction();
            realm().copyToRealm(cityList);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void removeAllCities() {
        realm().beginTransaction();
        realm().delete(City.class);
        realm().commitTransaction();
    }

    public boolean saveAddedCity(City city) {
        try {
            removeAllCities();
            realm().beginTransaction();
            realm().copyToRealm(city);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<City> getCityList() {
        return realm().where(City.class).findAll();
    }

    public City getAddedCity() {
        return realm().where(City.class).findFirst();
    }
}
