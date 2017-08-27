package com.mydreams.android.net;

import java.util.Map;

import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FieldMap;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.GET;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Part;
import retrofit2.http.Path;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;

/**
 * Created by mikhail on 03.03.16.
 */
public interface Api {

    @FormUrlEncoded()
    @POST(Url.AUTH_URL)
    Call<ResponseBody> authorization(@FieldMap Map<String, String> credentials);

    @FormUrlEncoded()
    @POST(Url.RECOVERY_PASSWORD_URL)
    Call<ResponseBody> recoveryPassword(@FieldMap Map<String, String> email);

    @FormUrlEncoded()
    @POST(Url.RECOVERY_PROFILE_URL)
    Call<ResponseBody> recoveryProfile(@Field("") String emptyString);

    @GET(Url.PROFILE_URL)
    Call<ResponseBody> loadUserInfo();

    @GET(Url.COUNTRY_LIST_URL)
    Call<ResponseBody> loadCountryList();

    @GET(Url.COUNTRY_LIST_URL)
    Call<ResponseBody> searchCountry(@Query("q") String prefix);

    @GET(Url.CITY_URL)
    Call<ResponseBody> loadCityList(@Path("countryId") int countryId);

    @GET(Url.CITY_URL)
    Call<ResponseBody> searchCity(@Path("countryId") int countryId, @Query("q") String prefix);

    @FormUrlEncoded
    @POST(Url.CITY_URL)
    Call<ResponseBody> sendToAddCity(@Path("countryId") int countryId,
                                     @Query("city_name") String cityName,
                                     @Query("region_name") String regionName,
                                     @Query("district_name") String districtName,
                                     @Field("") String emptyString);

    @GET(Url.AGREEMENT_URL)
    Call<ResponseBody> loadAgreement();

    @GET(Url.DREAMS_URL)
    Call<ResponseBody> loadDreamsList(@QueryMap Map<String, Object> paramsRequest);

    @GET(Url.DREAMERS_LIST_URL)
    Call<ResponseBody> loadDreamersList(@QueryMap Map<String, Object> paramsRequest);

    @Multipart
    @POST(Url.DREAMS_URL)
    Call<ResponseBody> dreamCreate(@Part("title") RequestBody title,
                                   @Part("description") RequestBody description,
                                   @Part("restriction_level") RequestBody restrictionLevel,
                                   @Part("came_true") boolean cameTrue,
                                   @Part("photo_crop[x]") int x,
                                   @Part("photo_crop[y]") int y,
                                   @Part("photo_crop[width]") int width,
                                   @Part("photo_crop[height]") int height,
                                   @Part MultipartBody.Part photo);

    @Multipart
    @POST(Url.CREATE_AVATAR_URL)
    Call<ResponseBody> createAvatar(@Part MultipartBody.Part file,
                                    @Part MultipartBody.Part croppedFile,
                                    @Part("crop[x]") int x,
                                    @Part("crop[y]") int y,
                                    @Part("crop[width]") int width,
                                    @Part("crop[height]") int height);

    @GET(Url.PROFILE_STATUS)
    Call<ResponseBody> loadProfileStatus();

    @FormUrlEncoded
    @POST(Url.CHANGE_EMAIL_URL)
    Call<ResponseBody> changeEmail(@QueryMap Map<String, String> credentials, @Field("") String emptyString);

    @FormUrlEncoded
    @POST(Url.CHANGE_PASSWORD_URL)
    Call<ResponseBody> changePassword(@QueryMap Map<String, Object> credentials, @Field("") String emptyString);

    @Multipart
    @PUT(Url.UPDATE_PROFILE_URL)
    Call<ResponseBody> updateProfile(@Part("first_name") RequestBody firstName,
                                     @Part("last_name") RequestBody lastName,
                                     @Part("birthday") RequestBody birthday,
                                     @Part MultipartBody.Part avatar,
                                     @Part("gender") RequestBody gender,
                                     @Part("country_id") int countryId,
                                     @Part("city_id") int cityId,
                                     @Part("status") RequestBody status);

    @FormUrlEncoded
    @POST(Url.SEND_REG_DATA_URL)
    Call<ResponseBody> sendUserRegData(@FieldMap Map<String, Object> credentials);
}
