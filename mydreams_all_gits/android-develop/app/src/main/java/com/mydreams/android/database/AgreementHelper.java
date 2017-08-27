package com.mydreams.android.database;

import com.mydreams.android.models.Agreement;

/**
 * Created by mikhail on 20.04.16.
 */
public class AgreementHelper extends BaseHelper {

    public boolean save(Agreement agreement) {
        try {
            realm().beginTransaction();
            realm().delete(Agreement.class);
            realm().copyToRealm(agreement);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Agreement getAgreement() {
        return realm().where(Agreement.class).findFirst();
    }
}
