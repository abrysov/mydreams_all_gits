package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.RegistrationCaller;

import java.util.Map;

/**
 * Created by mikhail on 29.04.16.
 */
public class RegistrationManager extends BaseManager {

    private OnSendRegDataListener sendRegDataListener;

    public BaseCaller sendRegData(Map<String, Object> credentials) {
        return new RegistrationCaller(credentials, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        sendRegDataListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        sendRegDataListener.error(errMsg);
    }

    public void setSendRegDataListener(OnSendRegDataListener sendRegDataListener) {
        this.sendRegDataListener = sendRegDataListener;
    }

    public interface OnSendRegDataListener {
        void complete();
        void error(String errMsg);
    }
}
