package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.response.DreamListResponse;

import java.io.File;
import java.util.Map;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 5/31/16.
 */
public class DreamCreateCaller extends BaseCaller {

    private RequestBody title;
    private RequestBody description;
    private RequestBody restrictionLevel;
    private boolean cameTrue;
    private MultipartBody.Part photo;
    int x;
    int y;
    int width;
    int height;

    public DreamCreateCaller(Map<String, Object> paramsRequest, LoaderCallback loaderCallback) {
        super(loaderCallback);
        title = getTitleDream((String)paramsRequest.get(Field.TITLE));
        description = getDescriptionDream((String)paramsRequest.get(Field.DESCRIPTION));
        restrictionLevel = getRestrictionLevel((String)paramsRequest.get(Field.RESTRICTION_LEVEL));
        cameTrue = (boolean) paramsRequest.get(Field.CAME_TRUE);
        photo = getPhotoRequestBody((File)paramsRequest.get(Field.PHOTO));
        x = (int) paramsRequest.get(Field.CROP_X);
        y = (int) paramsRequest.get(Field.CROP_Y);
        width = (int) paramsRequest.get(Field.CROP_WIDTH);
        height = (int) paramsRequest.get(Field.CROP_HEIGHT);

        apiCall();
    }

    private RequestBody getRestrictionLevel(String restrictionLevel) {
        return RequestBody.create(MediaType.parse("multipart/form-data"), restrictionLevel);
    }

    private RequestBody getTitleDream(String title) {
        return RequestBody.create(MediaType.parse("multipart/form-data"), title);
    }

    private RequestBody getDescriptionDream(String description) {
        return RequestBody.create(MediaType.parse("multipart/form-data"), description);
    }

    private MultipartBody.Part getPhotoRequestBody(File photoFile) {
        RequestBody bodyRequest = RequestBody.create(MediaType.parse("multipart/form-data"), photoFile);
        MultipartBody.Part body = MultipartBody.Part.createFormData("photo", photoFile.getName(), bodyRequest);
        return body;
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().dreamCreate(title, description, restrictionLevel, cameTrue, x, y, width, height, photo);
        sendRequest(call, new DreamListResponse(), this);
    }
}
