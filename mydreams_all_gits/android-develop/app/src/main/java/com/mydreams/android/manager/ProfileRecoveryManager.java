package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.ProfileRecoveryCaller;

/**
 * Created by mikhail on 19.04.16.
 */
public class ProfileRecoveryManager extends BaseManager {

    private OnRecoveryProfileListener recoveryProfileListener;

    public Cancelable recoveryProfile() {
        return new ProfileRecoveryCaller(this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        recoveryProfileListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        recoveryProfileListener.error(errMsg);
    }

    public void setOnRecoveryProfileListener(OnRecoveryProfileListener recoveryProfileListener) {
        this.recoveryProfileListener = recoveryProfileListener;
    }

    public interface OnRecoveryProfileListener {
        void complete();
        void error(String errMsg);
    }
}
