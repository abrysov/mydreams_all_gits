package com.mydreams.android.net;

/**
 * Created by mikhail on 01.03.16.
 */
public class Url {

    public static final String LOGIN = "936c2df0d752c810c9bbb3326067f6e1b8ab411c3a837b6b50d1c23ed4a8ea49";
    public static final String PASSWORD = "acb63e210e161c3e85e86d181c0a0e0b5b3bbbc41e64423347ba784ea0715fed";

    public static final String BASE_URL = "http://staging.mydreams.club";
    public static final String AUTH_URL = "/api/v1/oauth/token";
    public static final String RECOVERY_PASSWORD_URL = "/api/v1/passwords/reset";
    public static final String RECOVERY_PROFILE_URL = "/api/v1/profile/restore";
    public static final String PROFILE_URL = "/api/v1/me";
    public static final String COUNTRY_LIST_URL = "/api/v1/countries";
    public static final String CITY_URL = "/api/v1/countries/{countryId}/cities";
    public static final String AGREEMENT_URL = "/api/v1/static/terms";
    public static final String DREAMS_URL = "/api/v1/dreams";
    public static final String DREAMERS_LIST_URL = "/api/v1/dreamers";
    public static final String CREATE_AVATAR_URL = "/api/v1/profile/avatar";
    public static final String PROFILE_STATUS = "/api/v1/profile/status";
    public static final String CHANGE_EMAIL_URL = "/api/v1/profile/settings/change_email";
    public static final String CHANGE_PASSWORD_URL = "/api/v1/profile/settings/change_password";
    public static final String UPDATE_PROFILE_URL = "/api/v1/profile";

    public static final String SEND_REG_DATA_URL = "/api/v1/dreamers";

    public static final String HEADER_AUTHORIZATION = "Authorization";
    public static final String HEADER_ACCEPT_LANGUAGE = "Accept-Language";
    public static final String BEARER = "Bearer";
}
