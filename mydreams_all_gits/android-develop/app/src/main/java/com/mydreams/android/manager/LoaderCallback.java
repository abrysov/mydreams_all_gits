package com.mydreams.android.manager;

import com.mydreams.android.net.callers.BaseCaller;

/**
 * Created by mikhail on 26.04.16.
 */
public interface LoaderCallback {
    void onLoadComplete(BaseCaller caller);
    void onLoadError(String errMsg, BaseCaller caller);
}
