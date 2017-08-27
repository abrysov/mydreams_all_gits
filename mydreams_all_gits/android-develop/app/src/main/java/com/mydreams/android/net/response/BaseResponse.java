package com.mydreams.android.net.response;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.mydreams.android.net.callers.BaseCaller;

/**
 * Created by mikhail on 13.04.16.
 */
public class BaseResponse {

    @Nullable
    private String mAnswer;

    private int mRequestResult;

    public BaseResponse() {
    }

    @NonNull
    public int getRequestResult() {
        return mRequestResult;
    }

    public BaseResponse setRequestResult(int requestResult) {
        mRequestResult = requestResult;
        return this;
    }

    @Nullable
    public <T> T getTypedAnswer() {
        if (mAnswer == null) {
            return null;
        }

        return (T) mAnswer;
    }

    public BaseResponse setAnswer(@Nullable String answer) {
        mAnswer = answer;
        return this;
    }

    public boolean save() {
        return false;
    }
}
