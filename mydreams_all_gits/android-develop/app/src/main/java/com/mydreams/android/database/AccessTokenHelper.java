package com.mydreams.android.database;

import com.mydreams.android.models.AccessTokenModel;

/**
 * Created by mikhail on 13.04.16.
 */
public class AccessTokenHelper extends BaseHelper {

    public boolean addAccessToken(AccessTokenModel accessToken) {
        try {
            removeAccessToken();
            realm().beginTransaction();
            realm().copyToRealm(accessToken);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void removeAccessToken() {
        realm().beginTransaction();
        realm().delete(AccessTokenModel.class);
        realm().commitTransaction();
    }

    public AccessTokenModel getAccessTokenModel() {
        return realm().where(AccessTokenModel.class).findFirst();
    }

    public boolean existAccessToken() {
        long accessToken = realm().where(AccessTokenModel.class).count();
        if (accessToken > 0) {
            return true;
        }
        return false;
    }
}
