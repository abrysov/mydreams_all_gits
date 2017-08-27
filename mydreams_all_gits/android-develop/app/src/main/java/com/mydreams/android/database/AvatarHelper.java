package com.mydreams.android.database;

import com.mydreams.android.models.Avatar;

/**
 * Created by mikhail on 27.06.16.
 */
public class AvatarHelper extends BaseHelper {

    public boolean saveAvatar(Avatar avatar) {
        try{
            realm().beginTransaction();
            realm().copyToRealmOrUpdate(avatar);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
