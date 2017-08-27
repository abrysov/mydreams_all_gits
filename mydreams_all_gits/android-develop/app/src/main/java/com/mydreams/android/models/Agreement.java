package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 20.04.16.
 */
public class Agreement extends RealmObject {

    @PrimaryKey
    private String agreement;
    private String titleUserAgreement;

    public String getTitleUserAgreement() {
        return titleUserAgreement;
    }

    public void setTitleUserAgreement(String titleUserAgreement) {
        this.titleUserAgreement = titleUserAgreement;
    }

    public String getUserAgreement() {
        return agreement;
    }

    public void setUserAgreement(String agreement) {
        this.agreement = agreement;
    }
}
