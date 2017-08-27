package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.response.BaseResponse;

import java.io.File;
import java.util.Map;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 11.07.16.
 */
public class UpdateProfileCaller extends BaseCaller {

    private MultipartBody.Part avatar;
    private RequestBody userName;
    private RequestBody userLastName;
    private RequestBody userGender;
    private RequestBody userBirthday;
    private int countryId;
    private int cityId;
    private RequestBody status;

    public UpdateProfileCaller(Map<String, Object> credentials, LoaderCallback loaderCallback) {
        super(loaderCallback);

        avatar = getFileRequestBody((File) credentials.get(Field.AVATAR));
        userName = getNameRequestBody((String) credentials.get(Field.FIRST_NAME));
        userLastName = getLastNameRequestBody((String) credentials.get(Field.LAST_NAME));
        userGender = getGenderRequestBody((String) credentials.get(Field.GENDER));
        userBirthday = getBirthdayRequestBody((String) credentials.get(Field.BIRTHDAY));
        countryId = (int) credentials.get(Field.COUNTRY_ID);
        cityId = (int) credentials.get(Field.CITY_ID);
        status = getStatusRequestBody((String) credentials.get(Field.STATUS));

        apiCall();
    }

    private RequestBody getNameRequestBody(String userName) {
        if (userName != null) {
            return RequestBody.create(MediaType.parse("multipart/form-data"), userName);
        }
        return null;
    }

    private RequestBody getStatusRequestBody(String userName) {
        if (status != null) {
            return RequestBody.create(MediaType.parse("multipart/form-data"), userName);
        }
        return null;
    }

    private RequestBody getLastNameRequestBody(String userLastName) {
        if (userLastName != null) {
            return RequestBody.create(MediaType.parse("multipart/form-data"), userLastName);
        }
        return null;
    }

    private RequestBody getGenderRequestBody(String userGender) {
        if (userGender != null) {
            return RequestBody.create(MediaType.parse("multipart/form-data"), userGender);
        }
        return null;
    }

    private RequestBody getBirthdayRequestBody(String birthday) {
        if (birthday != null) {
            return RequestBody.create(MediaType.parse("multipart/form-data"), birthday);
        }
        return null;
    }

    private MultipartBody.Part getFileRequestBody(File photoFile) {
        MultipartBody.Part body = null;
        if (photoFile != null) {
            RequestBody bodyRequest = RequestBody.create(MediaType.parse("multipart/form-data"), photoFile);
            body = MultipartBody.Part.createFormData("avatar", photoFile.getName(), bodyRequest);
        }
        return body;
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().updateProfile(userName, userLastName, userBirthday, avatar, userGender, countryId, cityId, status);
        sendRequest(call, new BaseResponse(), this, false);
    }
}
