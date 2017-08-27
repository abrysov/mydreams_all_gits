package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.AvatarHelper;
import com.mydreams.android.models.Avatar;
import com.mydreams.android.models.CropMeta;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Photo;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
 * Created by mikhail on 27.06.16.
 */
public class CreateAvatarResponse extends BaseResponse {

    @Inject
    AvatarHelper avatarHelper;

    public CreateAvatarResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        Avatar avatar = getParsedCreateAvatarResponse(getTypedAnswer());
        if (avatar != null) {
            return avatarHelper.saveAvatar(avatar);
        }
        return false;
    }

    private Avatar getParsedCreateAvatarResponse(Object typedAnswer) {
        UserResponse userResponse = new UserResponse(true);
        Avatar avatar = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            JSONObject avatarObject = jsonObject.getJSONObject(Field.AVATAR);

            avatar = new Avatar();
            avatar.setId(avatarObject.getInt(Field.ID));
            avatar.setPhoto(getPhoto(avatarObject));
            avatar.setUser(userResponse.getParsedUser(avatarObject.toString()));
            avatar.setCropMeta(getCropMetaParsed(avatarObject));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return avatar;
    }

    private CropMeta getCropMetaParsed(JSONObject avatarObject) {
        CropMeta cropMeta = null;
        try {
            JSONObject cropMetaObject = avatarObject.getJSONObject(Field.CROP_META);
            cropMeta = new CropMeta();
            cropMeta.setX(cropMetaObject.isNull(Field.CROP_X) ? 0 : cropMetaObject.getInt(Field.CROP_X));
            cropMeta.setY(cropMetaObject.isNull(Field.CROP_Y) ? 0 : cropMetaObject.getInt(Field.CROP_Y));
            cropMeta.setWidth(cropMetaObject.isNull(Field.CROP_WIDTH) ? 0 : cropMetaObject.getInt(Field.CROP_WIDTH));
            cropMeta.setHeight(cropMetaObject.isNull(Field.CROP_HEIGHT) ? 0 : cropMetaObject.getInt(Field.CROP_HEIGHT));
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return cropMeta;
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
