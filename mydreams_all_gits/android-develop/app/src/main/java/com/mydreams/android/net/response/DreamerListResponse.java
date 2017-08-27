package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.DreamerHelper;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.City;
import com.mydreams.android.models.Country;
import com.mydreams.android.models.Dreamer;
import com.mydreams.android.models.Field;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamerListResponse extends BaseResponse {

    @Inject
    DreamerHelper dreamerHelper;

    public DreamerListResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        List<Dreamer> dreamersList = getParsedDreamer(getTypedAnswer());
        if (dreamersList != null) {
            return dreamerHelper.save(dreamersList);
        }
        return false;
    }

    public List<Dreamer> getParsedDreamer(Object typedAnswer) {
        List<Dreamer> dreamersList = null;
        PaginationResponse paginationResponse = new PaginationResponse();
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONArray dreamersArray = jsonObject.getJSONArray(Field.DREAMERS);
            JSONObject meta = jsonObject.getJSONObject(Field.META);
            paginationResponse.save(meta);
            dreamersList = new ArrayList<>();
            JSONObject dreamers;

            for (int i = 0; i < dreamersArray.length(); i++) {
                dreamers = dreamersArray.getJSONObject(i);
                Dreamer dreamer = new Dreamer();
                dreamer.setId(dreamers.getInt(Field.ID));
                dreamer.setFullName(dreamers.getString(Field.FULL_NAME));
                dreamer.setGender(dreamers.getString(Field.GENDER));
                dreamer.setVip(dreamers.getBoolean(Field.VIP));
                dreamer.setCelebrity(dreamers.getBoolean(Field.CELEBRITY));
                dreamer.setCity(getCity(dreamers));
                dreamer.setCountry(getCountry(dreamers));
                dreamer.setVisitsCount(dreamers.getInt(Field.VISITS_COUNT));
                dreamer.setAvatar(getAvatar(dreamers));
                dreamer.setFirstName(dreamers.getString(Field.FIRST_NAME));
                dreamer.setLastName(dreamers.isNull(Field.LAST_NAME) ? null : dreamers.getString(Field.LAST_NAME));
                dreamer.setBirthday(dreamers.isNull(Field.BIRTHDAY) ? null : dreamers.getString(Field.BIRTHDAY));
                dreamer.setStatusUser(dreamers.isNull(Field.STATUS) ? null : dreamers.getString(Field.STATUS));
                dreamer.setViewCount(dreamers.getInt(Field.VIEWS_COUNT));
                dreamer.setFriendsCount(dreamers.getInt(Field.FRIENDS_COUNT));
                dreamer.setDreamsCount(dreamers.getInt(Field.DREAMS_COUNT));
                dreamer.setFulFilledDreamsCount(dreamers.getInt(Field.FULFILLED_DREAMS_COUNT));
                dreamer.setLaunchesCount(dreamers.getInt(Field.LAUNCHES_COUNT));
                dreamer.setBlocked(dreamers.getBoolean(Field.IS_BLOCKED));
                dreamer.setDeleted(dreamers.getBoolean(Field.IS_DELETED));
                dreamer.setOnline(dreamers.getBoolean(Field.IS_ONLINE));
                dreamer.setFollower(dreamers.getBoolean(Field.IS_FOLLOWER));
                dreamer.setFriend(dreamers.getBoolean(Field.IS_FRIEND));

                dreamersList.add(dreamer);
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return dreamersList;
    }

    public Country getCountry(JSONObject object) {
        Country country = null;
        try {
            JSONObject countryObject = object.getJSONObject(Field.COUNTRY);
            country = new Country();
            country.setId(countryObject.isNull(Field.ID) ? null : countryObject.getInt(Field.ID));
            country.setNameCountry(countryObject.isNull(Field.NAME) ? null : countryObject.getString(Field.NAME));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return country;
    }

    public City getCity(JSONObject object) {
        City city = null;
        try {
            JSONObject cityObject = object.getJSONObject(Field.CITY);
            city = new City();
            city.setCityId(cityObject.isNull(Field.ID) ? null : cityObject.getInt(Field.ID));
            city.setCityName(cityObject.isNull(Field.NAME) ? null : cityObject.getString(Field.NAME));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return city;
    }

    private Avatar getAvatar(JSONObject jsonObject) {
        Avatar avatar = null;
        try {
            JSONObject jsonAvatar = jsonObject.getJSONObject(Field.AVATAR);
            avatar = new Avatar();
            avatar.setSmallUrl(jsonAvatar.getString(Field.SMALL));
            avatar.setPreMediumUrl(jsonAvatar.getString(Field.PRE_MEDIUM));
            avatar.setMediumUrl(jsonAvatar.getString(Field.MEDIUM));
            avatar.setLargeUrl(jsonAvatar.getString(Field.LARGE));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return avatar;
    }
}
