package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.DreamerCaller;

import java.util.Map;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamersListManager extends BaseManager {

    private OnDreamerSaveListener dreamerSaveListener;

    public Cancelable loadDreamersList(Map<String, Object> paramsRequest) {
        return new DreamerCaller(paramsRequest, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        dreamerSaveListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        dreamerSaveListener.error(errMsg);
    }

    public void setDreamerSaveListener(OnDreamerSaveListener dreamerSaveListener) {
        this.dreamerSaveListener = dreamerSaveListener;
    }

    public interface OnDreamerSaveListener {
        void complete();
        void error(String errMsg);
    }
}
