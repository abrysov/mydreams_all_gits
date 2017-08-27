package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.AgreementHelper;
import com.mydreams.android.models.Agreement;
import com.mydreams.android.models.Field;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
 * Created by mikhail on 20.04.16.
 */
public class AgreementResponse extends BaseResponse {

    @Inject
    AgreementHelper agreementHelper;

    public AgreementResponse() {
        App.getComponent().inject(this);
    }

    @Override
    public boolean save() {
        Agreement agreement = getParsedAgreement(getTypedAnswer());
        if(agreement != null) {
            return agreementHelper.save(agreement);
        }
        return false;
    }

    private Agreement getParsedAgreement(Object typedAnswer) {
        Agreement agreement = null;
        try {
            JSONObject jsonObject = new JSONObject((String) typedAnswer);
            agreement = new Agreement();
            agreement.setUserAgreement(jsonObject.getString(Field.TERMS));
            JSONObject metaObject = jsonObject.getJSONObject(Field.META);
            agreement.setTitleUserAgreement(metaObject.getString(Field.MESSAGE));

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return agreement;
    }
}
