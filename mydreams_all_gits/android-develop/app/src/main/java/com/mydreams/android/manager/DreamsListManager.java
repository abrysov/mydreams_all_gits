package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.DreamCreateCaller;
import com.mydreams.android.net.callers.DreamListCaller;

import java.util.Map;

/**
 * Created by mikhail on 10.05.16.
 */
public class DreamsListManager extends BaseManager {

    private OnSaveDreamListener saveDreamListener;

    public Cancelable loadDreamsList(Map<String, Object> paramsRequest) {
        return new DreamListCaller(paramsRequest, this);
    }

    public Cancelable dreamCreate(Map<String, Object> paramsRequest) {
        return new DreamCreateCaller(paramsRequest, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        saveDreamListener.complete();
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        saveDreamListener.error(errMsg);
    }

    public void setSaveDreamListener(OnSaveDreamListener saveDreamListener) {
        this.saveDreamListener = saveDreamListener;
    }

    public interface OnSaveDreamListener {
        void complete();
        void error(String errMsg);
    }
}
