package com.mydreams.android.manager;

import com.mydreams.android.net.callers.AgreementCaller;
import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;

/**
 * Created by mikhail on 20.04.16.
 */
public class AgreementManager extends BaseManager {

    private OnAgreementSaveListener agreementSaveListener;

    public Cancelable loadAgreement() {
        return new AgreementCaller(this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        agreementSaveListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        agreementSaveListener.error(errMsg);
    }

    public void setOnAgreementSaveListener(OnAgreementSaveListener agreementSaveListener) {
        this.agreementSaveListener = agreementSaveListener;
    }

    public interface OnAgreementSaveListener {
        void complete();
        void error(String errMsg);
    }
}
