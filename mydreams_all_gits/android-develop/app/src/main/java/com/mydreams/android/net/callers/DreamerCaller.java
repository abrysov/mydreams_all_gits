package com.mydreams.android.net.callers;

import com.mydreams.android.Config;
import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.response.DreamerListResponse;

import java.util.Map;

import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 20.05.16.
 */
public class DreamerCaller extends BaseCaller {

    private Map<String, Object> paramsRequest;

    public DreamerCaller(Map<String, Object> paramsRequest, LoaderCallback loaderCallback) {
        super(loaderCallback);

        this.paramsRequest = paramsRequest;
        this.paramsRequest.put(Field.PER, Config.COUNT_PAGE_DREAMERS);

        apiCall();
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().loadDreamersList(paramsRequest);
        sendRequest(call, new DreamerListResponse(), this);
    }
}
