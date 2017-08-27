package com.mydreams.android.net.callers;

import com.mydreams.android.manager.LoaderCallback;
import com.mydreams.android.models.Field;
import com.mydreams.android.net.response.CreateAvatarResponse;

import java.io.File;
import java.util.Map;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;

/**
 * Created by mikhail on 27.06.16.
 */
public class CreateAvatarCaller extends BaseCaller {

    private MultipartBody.Part file;
    private MultipartBody.Part croppedFile;
    int x;
    int y;
    int width;
    int height;

    public CreateAvatarCaller(Map<String, Object> paramsRequest, LoaderCallback loaderCallback) {
        super(loaderCallback);

        file = getFileRequestBody((File)paramsRequest.get(Field.FILE));
        croppedFile = getCroppedFileRequestBody((File)paramsRequest.get(Field.CROPPED_FILE));
        x = (int) paramsRequest.get(Field.CROP_X);
        y = (int) paramsRequest.get(Field.CROP_Y);
        width = (int) paramsRequest.get(Field.CROP_WIDTH);
        height = (int) paramsRequest.get(Field.CROP_HEIGHT);

        apiCall();
    }

    private MultipartBody.Part getFileRequestBody(File photoFile) {
        if (photoFile != null) {
            RequestBody bodyRequest = RequestBody.create(MediaType.parse("multipart/form-data"), photoFile);
            MultipartBody.Part body = MultipartBody.Part.createFormData("file", photoFile.getName(), bodyRequest);
            return body;
        }
        return null;
    }

    private MultipartBody.Part getCroppedFileRequestBody(File croppedFile) {
        if (croppedFile != null) {
            RequestBody bodyRequest = RequestBody.create(MediaType.parse("multipart/form-data"), croppedFile);
            MultipartBody.Part body = MultipartBody.Part.createFormData("cropped_file", croppedFile.getName(), bodyRequest);
            return body;
        }
        return null;
    }

    @Override
    protected void apiCall() {
        Call<ResponseBody> call = getApi().createAvatar(file, croppedFile, x, y, width, height);
        sendRequest(call, new CreateAvatarResponse(), this);
    }
}
