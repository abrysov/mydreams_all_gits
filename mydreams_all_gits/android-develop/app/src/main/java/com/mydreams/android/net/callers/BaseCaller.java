package com.mydreams.android.net.callers;

import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.mydreams.android.App;
import com.mydreams.android.Config;
import com.mydreams.android.R;
import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.models.Field;
import com.mydreams.android.modules.RetrofitService;
import com.mydreams.android.net.Api;
import com.mydreams.android.net.response.BaseResponse;
import com.mydreams.android.services.NotificationService;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import javax.inject.Inject;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Created by mikhail on 13.04.16.
 */
public abstract class BaseCaller implements Cancelable {

    @Inject
    Context context;
    @Inject
    RetrofitService client;
    private LoaderCallback loaderCallback;
    private Call<ResponseBody> call;

    public BaseCaller(LoaderCallback loaderCallback) {
        App.getComponent().inject(this);
        this.loaderCallback = loaderCallback;
    }

    private String getTypeResponse(Response<ResponseBody> responseBody) throws IOException {
        if (responseBody.body() != null) {
            return responseBody.body().string();
        } else {
            return responseBody.errorBody().string();
        }
    }

    private boolean isOnline() {
        ConnectivityManager cm = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo != null && netInfo.isConnectedOrConnecting();
    }

    protected void sendRequest(Call<ResponseBody> call, final BaseResponse response, final BaseCaller caller) {
        sendRequest(call, response, caller, true);
    }

    protected void sendRequest(Call<ResponseBody> call, final BaseResponse response, final BaseCaller caller, final boolean needSave) {
        if (!isOnline()) {
            String errMsg = context.getResources().getString(R.string.notification_internet_is_not_connection);
            loaderCallback.onLoadError(errMsg, caller);
            return;
        }
        this.call = call;
        this.call.enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(Call<ResponseBody> call, Response<ResponseBody> bodyResponse) {
                try {
                    final BaseResponse baseResponse = response;
                    baseResponse.setRequestResult(bodyResponse.code());
                    baseResponse.setAnswer(getTypeResponse(bodyResponse));

                    switch (baseResponse.getRequestResult()) {
                        case 201:
                        case 200:
                            if (needSave) {
                                saveAnswer(baseResponse, caller);
                            } else {
                                loaderCallback.onLoadComplete(caller);
                            }
                            break;
                        case 401:
                            processingErrNotAuthorized();
                            loaderCallback.onLoadError(getErrorMessage(baseResponse.getTypedAnswer()), caller);
                            break;
                        default:
                            loaderCallback.onLoadError(getErrorMessage(baseResponse.getTypedAnswer()), caller);
                            break;
                    }
                }catch (IOException e) {
                    onError(getErrorMessage(""));
                }
            }

            @Override
            public void onFailure(Call<ResponseBody> call, Throwable t) {
            }
        });
    }

    private void saveAnswer(BaseResponse baseResponse, BaseCaller caller) {
        boolean isSave = baseResponse.save();
        if (isSave) {
            loaderCallback.onLoadComplete(caller);
        } else {
            loaderCallback.onLoadError(getErrorMessage(baseResponse.getTypedAnswer()), caller);
        }
    }

    @Override
    public void cancel() {
        if (call != null) {
            call.cancel();
        }
    }

    private String getErrorMessage(Object response) {
        String msgError = null;
        String msgStatus = null;
        try {
            JSONObject jsonObject = new JSONObject((String) response);
            JSONObject jsonItem = jsonObject.getJSONObject(Field.META);
            msgError = jsonItem.getString(Field.MESSAGE);
            msgStatus = jsonItem.getString(Field.STATUS);
            if (!jsonItem.isNull(Field.ERRORS)) {
                processingErrorsRegistration(jsonItem.getJSONObject(Field.ERRORS));
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }

        if (msgError != null && !msgError.isEmpty()) {
            return msgError;
        } else if (msgStatus != null && !msgStatus.isEmpty()) {
            return msgStatus;
        } else {
            msgError = context.getResources().getString(R.string.redirect_error_notification);
            return msgError;
        }
    }

    private void processingErrorsRegistration(JSONObject jsonItem) {
        Intent intent;
        if (!jsonItem.isNull(Field.EMAIL)) {
            intent = new Intent(Config.IF_BACKLIGHT_FIELDS_REG_FIRST_STAGE);
            intent.putExtra(Field.EMAIL, Field.EMAIL);
            context.sendBroadcast(intent);
        } else if (!jsonItem.isNull(Field.PASSWORD)) {
            intent = new Intent(Config.IF_BACKLIGHT_FIELDS_REG_FIRST_STAGE);
            intent.putExtra(Field.PASSWORD, Field.PASSWORD);
            context.sendBroadcast(intent);
        } else if (!jsonItem.isNull(Field.FIRST_NAME)) {
            intent = new Intent(Config.IF_BACKLIGHT_FIELDS_REG_SECOND_STAGE);
            intent.putExtra(Field.FIRST_NAME, Field.FIRST_NAME);
            context.sendBroadcast(intent);
        } else if (!jsonItem.isNull(Field.LAST_NAME)) {
            intent = new Intent(Config.IF_BACKLIGHT_FIELDS_REG_SECOND_STAGE);
            intent.putExtra(Field.LAST_NAME, Field.LAST_NAME);
            context.sendBroadcast(intent);
        } else if (!jsonItem.isNull(Field.PHONE)) {
            intent = new Intent(Config.IF_BACKLIGHT_FIELDS_REG_THIRD_STAGE);
            intent.putExtra(Field.PHONE, Field.PHONE);
            context.sendBroadcast(intent);
        }
    }

    protected Api getApi() {
        Api api = client.getRetrofit().create(Api.class);
        return api;
    }

    private void processingErrNotAuthorized() {
        Intent intent = new Intent(Config.IF_LOGOUT_BROADCAST);
        context.sendBroadcast(intent);
    }

    private void notificationError(String errMessage) {
        Intent intent = new Intent(context, NotificationService.class);
        intent.putExtra(Config.INTENT_SERVER_ERR_MSG, errMessage);
        context.startService(intent);
    }

    protected void onError(String errMessage) {
        notificationError(errMessage);
    }

    protected abstract void apiCall();
}
