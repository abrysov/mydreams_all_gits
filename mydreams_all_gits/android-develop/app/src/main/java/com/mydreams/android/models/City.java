package com.mydreams.android.models;


import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 17.03.16.
 */
public class City extends RealmObject {

    @PrimaryKey
    private int cityId;
    private String cityName;
    private String cityMeta;

    public int getCityId() {
        return cityId;
    }

    public void setCityId(int cityId) {
        this.cityId = cityId;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getCityMeta() {
        return cityMeta;
    }

    public void setCityMeta(String cityMeta) {
        this.cityMeta = cityMeta;
    }
}
