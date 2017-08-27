package com.mydreams.android.database;

import com.mydreams.android.models.Pagination;

/**
<<<<<<< ff66d7ced1b8575cbb717606f178ba93cdf10435
 * Created by mikhail on 08.06.16.
=======
 * Created by mikhail on 6/17/16.
>>>>>>> фильтрация списка мечтетелй
 */
public class PaginationHelper extends BaseHelper {

    public boolean save(Pagination pagination) {
        try {
            realm().beginTransaction();
            realm().delete(Pagination.class);
            realm().copyToRealm(pagination);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Pagination getPaginationData() {
        return realm().where(Pagination.class).findFirst();
    }
}
