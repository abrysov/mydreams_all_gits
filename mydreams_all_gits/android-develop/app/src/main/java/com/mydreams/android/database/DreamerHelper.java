package com.mydreams.android.database;

import com.mydreams.android.models.Dreamer;

import java.util.List;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamerHelper extends BaseHelper {

    public boolean save(List<Dreamer> dreamerList) {
        try {
            realm().beginTransaction();
            realm().copyToRealmOrUpdate(dreamerList);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Dreamer> getDreamersList() {
        return realm().where(Dreamer.class).findAll();
    }

    public void clearDreamersList() {
        realm().beginTransaction();
        realm().delete(Dreamer.class);
        realm().commitTransaction();
    }
}
