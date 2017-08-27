package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.UserHelper;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.City;
import com.mydreams.android.models.Country;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserStatus;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
 * Created by mikhail on 14.04.16.
 */
public class UserResponse extends BaseResponse {

    @Inject
    UserHelper userHelper;

    private boolean savedUser;

    public UserResponse(boolean savedUser) {
        App.getComponent().inject(this);
        this.savedUser = savedUser;
    }

    @Override
    public boolean save() {
        if (savedUser) {
            User user = getParsedUser(getTypedAnswer());
            return user != null ? userHelper.save(user) : false;
        } else {
            UserStatus userStatus = getParsedUserStatus(getTypedAnswer());
            return userStatus != null ? userHelper.saveUserStatus(userStatus) : false;
        }
    }

    public User getParsedUser(Object typedAnswer) {
        User user = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONObject jsonUser = jsonObject.getJSONObject(Field.DREAMER);

            user = new User();
            user.setUserId(jsonUser.getInt(Field.ID));
            user.setFullName(jsonUser.getString(Field.FULL_NAME));
            user.setGender(jsonUser.getString(Field.GENDER));
            user.setVip(jsonUser.isNull(Field.VIP) ? false : jsonUser.getBoolean(Field.VIP));
            user.setCelebrity(jsonUser.isNull(Field.CELEBRITY) ? false : jsonUser.getBoolean(Field.CELEBRITY));
            user.setVisitsCount(jsonUser.isNull(Field.VISITS_COUNT) ? 0 : jsonUser.getInt(Field.VISITS_COUNT));
            user.setVip(jsonUser.getBoolean(Field.VIP));
            user.setCelebrity(jsonUser.getBoolean(Field.CELEBRITY));
            user.setCity(getCity(jsonUser));
            user.setCountry(getCountry(jsonUser));
            user.setAvatar(getAvatar(jsonUser));
            user.setFirstName(jsonUser.isNull(Field.FIRST_NAME) ? null : jsonUser.getString(Field.FIRST_NAME));
            user.setLastName(jsonUser.isNull(Field.LAST_NAME) ? null : jsonUser.getString(Field.LAST_NAME));
            user.setBirthday(jsonUser.isNull(Field.BIRTHDAY) ? null : jsonUser.getString(Field.BIRTHDAY));
            user.setStatusUser(jsonUser.isNull(Field.STATUS) ? null : jsonUser.getString(Field.STATUS));
            user.setViewCount(jsonUser.isNull(Field.VIEWS_COUNT) ? 0 : jsonUser.getInt(Field.VIEWS_COUNT));
            user.setFriendsCount(jsonUser.isNull(Field.FRIENDS_COUNT) ? 0 : jsonUser.getInt(Field.FRIENDS_COUNT));
            user.setDreamsCount(jsonUser.isNull(Field.DREAMS_COUNT) ? 0 : jsonUser.getInt(Field.DREAMS_COUNT));
            user.setFulFilledDreamsCount(jsonUser.isNull(Field.FULFILLED_DREAMS_COUNT) ? 0 : jsonUser.getInt(Field.FULFILLED_DREAMS_COUNT));
            user.setLaunches_count(jsonUser.isNull(Field.LAUNCHES_COUNT) ? 0 : jsonUser.getInt(Field.LAUNCHES_COUNT));
            user.setIsBlocked(jsonUser.isNull(Field.IS_BLOCKED) ? false : jsonUser.getBoolean(Field.IS_BLOCKED));
            user.setIsDeleted(jsonUser.isNull(Field.IS_DELETED) ? false : jsonUser.getBoolean(Field.IS_DELETED));
            user.setIsOnline(jsonUser.isNull(Field.IS_ONLINE) ? false : jsonUser.getBoolean(Field.IS_ONLINE));
            user.setFolloweesCount(jsonUser.isNull(Field.FOLLOWEES_COUNT) ? 0 : jsonUser.getInt(Field.FOLLOWEES_COUNT));
            user.setUnreadedMessagesCount(jsonUser.isNull(Field.UNREADED_MESAGES_COUNT) ? 0 : jsonUser.getInt(Field.UNREADED_MESAGES_COUNT));
            user.setEmail(jsonUser.isNull(Field.EMAIL) ? null : jsonUser.getString(Field.EMAIL));

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return user;
    }

    private UserStatus getParsedUserStatus(Object typedAnswer) {
        UserStatus userStatus = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONObject jsonUser = jsonObject.getJSONObject(Field.DREAMER);

            userStatus = new UserStatus();
            userStatus.setId(jsonUser.getInt(Field.ID));
            userStatus.setCoinsCount(jsonUser.getInt(Field.COINS_COUNT));
            userStatus.setMessagesCount(jsonUser.getInt(Field.MESSAGES_COUNT));
            userStatus.setNotificationsCount(jsonUser.getInt(Field.NOTIFICATIONS_COUNT));
            userStatus.setFriendRequestsCount(jsonUser.getInt(Field.FRIEND_REQUESTS_COUNT));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userStatus;
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
