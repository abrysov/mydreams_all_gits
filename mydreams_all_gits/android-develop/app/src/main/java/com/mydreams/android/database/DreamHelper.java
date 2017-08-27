package com.mydreams.android.database;

import com.mydreams.android.models.Dream;

import java.util.List;

/**
 * Created by mikhail on 10.05.16.
 */
public class DreamHelper extends BaseHelper {

    public boolean save(List<Dream> dreamList) {
        try{
            realm().beginTransaction();
            realm().copyToRealmOrUpdate(dreamList);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Dream> getDreamList() {
        return realm().where(Dream.class).findAll();
    }

    public void clearDreamList() {
        realm().beginTransaction();
        realm().delete(Dream.class);
        realm().commitTransaction();
    }
}
