package com.mydreams.android.manager;
import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.RecoveryPasswordCaller;

import java.util.Map;

/**
 * Created by mikhail on 19.04.16.
 */
public class RecoveryPasswordManager extends BaseManager {

    private OnRecoveryPasswordListener recoveryPasswordListener;

    public Cancelable recoveryPassword(Map<String, String> emailUser) {
        return new RecoveryPasswordCaller(emailUser, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        recoveryPasswordListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        recoveryPasswordListener.error(errMsg);
    }

    public void setOnRecoveryPasswordListener(OnRecoveryPasswordListener recoveryPasswordListener) {
        this.recoveryPasswordListener = recoveryPasswordListener;
    }

    public interface OnRecoveryPasswordListener {
        void complete();
        void error(String errMsg);
    }
}
