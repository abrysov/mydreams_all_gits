package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.DreamHelper;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.Dreamer;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Photo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

/**
 * Created by mikhail on 10.05.16.
 */
public class DreamListResponse extends BaseResponse {

    @Inject
    DreamHelper dreamHelper;

    private List<Dream> dreamList;

    public DreamListResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        List<Dream> dreamList = getParsedDreamsList(getTypedAnswer());
        if (dreamList != null) {
            return dreamHelper.save(dreamList);
        }
        return false;
    }

    private List<Dream> getParsedDreamsList(Object typedAnswer) {
        try {
             JSONObject jsonObject = new JSONObject((String) typedAnswer);
             dreamList = new ArrayList<>();
             dreamList = parsedDreamByTypeJson(jsonObject);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return dreamList;
    }

    private List<Dream> parsedDreamByTypeJson(JSONObject jsonObject) {
        try {
            if (!jsonObject.isNull(Field.DREAMS) && jsonObject.get(Field.DREAMS) instanceof JSONArray) {
                JSONArray dreamsArray = jsonObject.getJSONArray(Field.DREAMS);
                PaginationResponse paginationResponse = new PaginationResponse();
                JSONObject meta = jsonObject.getJSONObject(Field.META);
                paginationResponse.save(meta);
                dreamList = parsedDreamsArray(dreamsArray);
            } else if (!jsonObject.isNull(Field.DREAM) && jsonObject.get(Field.DREAM) instanceof JSONObject) {
                JSONObject dreamObject = jsonObject.getJSONObject(Field.DREAM);
                dreamList = parsedDreamObject(dreamObject);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return dreamList;
    }

    private List<Dream> parsedDreamsArray(JSONArray dreamsArray) {
        try {
            JSONObject dreams;
            for (int i = 0; i < dreamsArray.length(); i++) {
                dreams = dreamsArray.getJSONObject(i);
                Dream dream = new Dream();
                dream.setId(dreams.getInt(Field.ID));
                dream.setTitle(dreams.getString(Field.TITLE));
                dream.setDescription(dreams.getString(Field.DESCRIPTION));
                dream.setPhoto(getPhoto(dreams));
                dream.setCerificateType(dreams.getString(Field.CERTIFICATE_TYPE));
                dream.setFulfilled(dreams.getBoolean(Field.FULFILLED));
                dream.setLikesCount(dreams.getInt(Field.LIKES_COUNT));
                dream.setCommentsCount(dreams.getInt(Field.COMMENTS_COUNT));
                dream.setLaunchesCount(dreams.getInt(Field.LAUNCHES_COUNT));
                dream.setCreatedAt(dreams.getString(Field.CREATED_AT));
                dream.setRestrictionLevel(dreams.getString(Field.RESTRICTION_LEVEL));
                dream.setDreamer(getDreamer(dreams));

                dreamList.add(dream);
            }
        } catch (JSONException e) {
                e.printStackTrace();
        }
        return dreamList;
    }

    private List<Dream> parsedDreamObject(JSONObject dreams) {
        dreamList.add(getDream(dreams));
        return dreamList;
    }

    private Dream getDream(JSONObject dreams) {
        Dream dream = null;
        try {
            dream = new Dream();
            dream.setId(dreams.getInt(Field.ID));
            dream.setTitle(dreams.getString(Field.TITLE));
            dream.setDescription(dreams.getString(Field.DESCRIPTION));
            dream.setPhoto(getPhoto(dreams));
            dream.setCerificateType(dreams.getString(Field.CERTIFICATE_TYPE));
            dream.setFulfilled(dreams.getBoolean(Field.FULFILLED));
            dream.setLikesCount(dreams.getInt(Field.LIKES_COUNT));
            dream.setCommentsCount(dreams.getInt(Field.COMMENTS_COUNT));
            dream.setLaunchesCount(dreams.getInt(Field.LAUNCHES_COUNT));
            dream.setCreatedAt(dreams.getString(Field.CREATED_AT));
            dream.setRestrictionLevel(dreams.getString(Field.RESTRICTION_LEVEL));
            dream.setDreamer(getDreamer(dreams));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return dream;
    }

    private Dreamer getDreamer(JSONObject jsonObject) {
        DreamerListResponse dreamerResponse = new DreamerListResponse();
        Dreamer dreamer = null;
        try {
            JSONObject jsonDreamer = jsonObject.getJSONObject(Field.DREAMER);
            dreamer = new Dreamer();
            dreamer.setId(jsonDreamer.getInt(Field.ID));
            dreamer.setFullName(jsonDreamer.getString(Field.FULL_NAME));
            dreamer.setVip(jsonDreamer.getBoolean(Field.VIP));
            dreamer.setCelebrity(jsonDreamer.getBoolean(Field.CELEBRITY));
            dreamer.setAvatar(getAvatar(jsonDreamer));
            dreamer.setUrl(jsonDreamer.getString(Field.URL));
            dreamer.setOnline(jsonDreamer.getBoolean(Field.IS_ONLINE));
            dreamer.setFriend(jsonDreamer.isNull(Field.IS_FRIEND) ? false : jsonDreamer.getBoolean(Field.IS_FRIEND));
            dreamer.setFollower(jsonDreamer.isNull(Field.IS_FOLLOWER) ? false : jsonDreamer.getBoolean(Field.IS_FOLLOWER));
            dreamer.setCity(dreamerResponse.getCity(jsonDreamer));
            dreamer.setCountry(dreamerResponse.getCountry(jsonDreamer));
            dreamer.setGender(jsonDreamer.getString(Field.GENDER));
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return dreamer;
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

    private Photo getPhoto(JSONObject jsonObject) {
        Photo photo = null;
        try {
            JSONObject jsonAvatar = jsonObject.getJSONObject(Field.PHOTO);
            photo = new Photo();
            photo.setSmall(jsonAvatar.getString(Field.SMALL));
            photo.setMedium(jsonAvatar.getString(Field.MEDIUM));
            photo.setLarge(jsonAvatar.getString(Field.LARGE));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return photo;
    }
}
