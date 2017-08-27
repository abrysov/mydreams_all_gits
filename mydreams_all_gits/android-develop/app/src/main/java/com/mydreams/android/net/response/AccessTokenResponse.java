package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.AccessTokenHelper;
import com.mydreams.android.models.AccessTokenModel;
import com.mydreams.android.models.Field;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
 * Created by mikhail on 13.04.16.
 */
public class AccessTokenResponse extends BaseResponse {

    @Inject
    AccessTokenHelper accessTokenHelper;

    public AccessTokenResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        AccessTokenModel accessTokenModel = getParsedAccessToken(getTypedAnswer());
        if (accessTokenModel != null) {
            return accessTokenHelper.addAccessToken(accessTokenModel);
        }
        return false;
    }

    public AccessTokenModel getParsedAccessToken(Object typedAnswer) {
        AccessTokenModel accessTokenModel = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            accessTokenModel = new AccessTokenModel();
            accessTokenModel.setAccessToken(jsonObject.getString(Field.ACCESS_TOKEN));
            accessTokenModel.setCreatedAt(jsonObject.getInt(Field.CREATED_AT));
            accessTokenModel.setExpiresIn(jsonObject.getInt(Field.EXPIRES_IN));

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return accessTokenModel;
    }
}
