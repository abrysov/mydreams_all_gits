package com.mydreams.android;

/**
 * Created by user on 25.02.16.
 */
public class Config {

    public static final String APP_PREFERENCES = "setting";

    public static final String USER_LOGIN = "USER_LOGIN";
    public static final String USER_PASSWORD = "USER_PASSWORD";
    public static final String USER_EMAIL = "USER_EMAIL";

    public static final String TWITTER_KEY = "jutrRJL7YZM4JgvcCfPhqTnvi";
    public static final String TWITTER_SECRET = "s7pHDsJ2D5LJlQ9twK1TOPiyKYVfoQAFlfkvS6YAvZUg6m7QYI";

    public static int FTYPE_UNKNOWN = -1;
    public static final int FTYPE_PROFILE = 1;
    public static final int FTYPE_LAUNCH = 2;
    public static final int FTYPE_AUTHORIZATION = 3;
    public static final int FTYPE_REG_FIRST_STAGE = 4;
    public static final int FTYPE_REG_SECOND_STAGE = 5;
    public static final int FTYPE_REG_THIRD_STAGE = 6;
    public static final int FTYPE_REDIRECT_PASSWORD = 7;
    public static final int FTYPE_REDIRECT_STATUS = 8;
    public static final int FTYPE_SELECTION_COUNTRY = 9;
    public static final int FTYPE_PROFILE_RECOVERY = 10;
    public static final int FTYPE_SELECTION_LOCALITY = 11;
    public static final int FTYPE_BLOCKED_USER = 12;
    public static final int FTYPE_AGREEMENT = 13;
    public static final int FTYPE_DREAMS = 14;
    public static final int FTYPE_FULFILLED_DREAM = 15;
    public static final int FTYPE_DREAMERS = 16;
    public static final int FTYPE_FULFILL_DREAM = 17;
    public static final int FTYPE_SETTINGS = 18;
    public static final int FTYPE_SEND_REG_DATA = 19;

    public static final String ACCESS_TOKEN = "ACCESS_TOKEN";
    public static final String FACEBOOK_USER_TOKEN = "FACEBOOK_USER_TOKEN";
    public static final String VK_ACCESS_TOKEN = "VK_ACCESS_TOKEN";
    public static final String VK_USER_EMAIL = "VK_USER_EMAIL";

    public static final String INSTAGRAM_ACCESS_TOKEN = "INSTAGRAM_ACCESS_TOKEN";
    public static final String TWITTER_ACCESS_TOKEN = "TWITTER_ACCESS_TOKEN";

    public static final int REQUEST_CAMERA = 0;
    public static final int REQUEST_GALLERY = 1;

    public static final String BUNDLE_USER_MAIL = "BUNDLE_USER_MAIL";
    public static final String BUNDLE_USER_PASSWORD = "BUNDLE_USER_PASSWORD";
    public static final String BUNDLE_USER_NAME = "BUNDLE_USER_NAME";
    public static final String BUNDLE_USER_LAST_NAME = "BUNDLE_USER_LAST_NAME";
    public static final String BUNDLE_USER_BIRTH_DAY = "BUNDLE_USER_BIRTH_DAY";
    public static final String BUNDLE_USER_BIRTH_MONTH = "BUNDLE_USER_BIRTH_MONTH";
    public static final String BUNDLE_USER_BIRTH_YEAR = "BUNDLE_USER_BIRTH_YEAR";
    public static final String BUNDLE_USER_GENDER = "BUNDLE_USER_GENDER";
    public static final String BUNDLE_USER_PHONE = "BUNDLE_USER_PHONE";
    public static final String BUNDLE_USER_LOCATION = "BUNDLE_USER_LOCATION";
    public static final String BUNDLE_USER_PHOTO = "BUNDLE_USER_PHOTO";
    public static final String BUNDLE_COUNTRY = "BUNDLE_COUNTRY";
    public static final String BUNDLE_COUNTRY_ID = "BUNDLE_COUNTRY_ID";
    public static final String BUNDLE_CITY_ID = "BUNDLE_CITY_ID";
    public static final String BUNDLE_CITY = "BUNDLE_CITY";
    public static final String BUNDLE_AGE_FROM = "BUNDLE_AGE_FROM";
    public static final String BUNDLE_AGE_TO = "BUNDLE_AGE_TO";
    public static final String BUNDLE_TAB_TAG_DREAMERS_FILTER = "BUNDLE_TAB_TAG_DREAMERS_FILTER";
    public static final String BUNDLE_CHECKBOX_ALL = "BUNDLE_CHECKBOX_ALL";
    public static final String BUNDLE_CHECKBOX_NEW = "BUNDLE_CHECKBOX_NEW";
    public static final String BUNDLE_CHECKBOX_POPULARS = "BUNDLE_CHECKBOX_POPULARS";
    public static final String BUNDLE_CHECKBOX_VIP = "BUNDLE_CHECKBOX_VIP";
    public static final String BUNDLE_CHECKBOX_ONLINE = "BUNDLE_CHECKBOX_ONLINE";
    public static final String BUNDLE_CROP_X = "BUNDLE_CROP_X";
    public static final String BUNDLE_CROP_Y = "BUNDLE_CROP_Y";
    public static final String BUNDLE_CROP_WIDTH = "BUNDLE_CROP_WIDTH";
    public static final String BUNDLE_CROP_HEIGHT = "BUNDLE_CROP_HEIGHT";

    public static final String ORIGINAL_PATH_IMG = "ORIGINAL_PATH_IMG";
    public static final String CROPPED_PATH_IMG = "CROPPED_PATH_IMG";

    public static final String INTENT_USER_COUNTRY = "INTENT_USER_COUNTRY";
    public static final String INTENT_USER_COUNTRY_ID = "INTENT_USER_COUNTRY_ID";
    public static final String INTENT_USER_CITY = "INTENT_USER_CITY";
    public static final String INTENT_USER_CITY_ID = "INTENT_USER_CITY_ID";
    public static final String INTENT_SERVER_ERR_MSG = "INTENT_SERVER_ERR_MSG";
    public static final String INTENT_FILTER_MODIFIED = "INTENT_FILTER_MODIFIED";
    public static final String INTENT_MAP_PARAMS_FILTER = "INTENT_MAP_PARAMS_FILTER";
    public static final String INTENT_MAP_PARAMS_AVATAR = "INTENT_MAP_PARAMS_AVATAR";
    public static final String INTENT_CATEGORIES_FILTER_POPULAR = "INTENT_CATEGORIES_FILTER_POPULAR";
    public static final String INTENT_CATEGORIES_FILTER_ONLINE = "INTENT_CATEGORIES_FILTER_ONLINE";
    public static final String INTENT_CATEGORIES_FILTER_VIP = "INTENT_CATEGORIES_FILTER_VIP";
    public static final String INTENT_CATEGORIES_FILTER_NEW = "INTENT_CATEGORIES_FILTER_NEW";

    public static final String IF_USER_COUNTRY_CHANGED = "IF_USER_COUNTRY_CHANGED";
    public static final String IF_SHOW_SERVER_ERR_MSG = "IF_SHOW_SERVER_ERR_MSG";
    public static final String IF_LOGOUT_BROADCAST = "IF_LOGOUT_BROADCAST";
    public static final String IF_OPEN_FRAGMENT_BY_USER_STATE = "IF_OPEN_FRAGMENT_BY_USER_STATE";
    public static final String IF_SHOW_NOTIFICATION_REG_ERR = "IF_SHOW_NOTIFICATION_REG_ERR";
    public static final String IF_BACKLIGHT_FIELDS_REG_FIRST_STAGE = "IF_BACKLIGHT_FIELDS_REG_FIRST_STAGE";
    public static final String IF_BACKLIGHT_FIELDS_REG_SECOND_STAGE = "IF_BACKLIGHT_FIELDS_REG_SECOND_STAGE";
    public static final String IF_BACKLIGHT_FIELDS_REG_THIRD_STAGE = "IF_BACKLIGHT_FIELDS_REG_THIRD_STAGE";

    public static final String IF_FILLING_PROFILE_MENU = "IF_FILLING_PROFILE_MENU";
    public static final String IF_GET_COUNTRY_ID = "IF_GET_COUNTRY_ID";
    public static final String IF_GET_CITY_ID = "IF_GET_CITY_ID";
    public static final String IF_FILLING_DREAMERS_RESULTS = "IF_FILLING_DREAMERS_RESULTS";

    public static final int COUNT_PAGE_DREAMS = 10;
    public static final int COUNT_PAGE_DREAMERS = 15;

    public static final String ORIGINAL_PATH_IMG_CAMERA = "ORIGINAL_PATH_IMG_CAMERA";

    public static final String TAG_TAB_POPULAR_DREAMS = "tag_tab_popular_dreams";
    public static final String TAG_TAB_DISCUSSED_DREAMS = "tag_tab_discussed_dreams";
    public static final String TAG_TAB_NEW_DREAMS = "tag_tab_new_dreams";
    public static final String TAG_TAB_ALL_DREAMS = "tag_tab_all_dreams";
    public static final String TAG_TAB_MALE_DREAMS = "tag_tab_male_dreams";
    public static final String TAG_TAB_FEMALE_DREAMS = "tag_tab_female_dreams";
    public static final String TAG_TAB_ALL_DREAMERS = "tag_tab_all_dreamers";
    public static final String TAG_TAB_MALE_DREAMERS = "tag_tab_male_dreamers";
    public static final String TAG_TAB_FEMALE_DREAMERS = "tag_tab_female_dreamers";

    public static final int ITEM_CAMERA = 0;
    public static final int ITEM_GALLERY = 1;
    public static final int ITEM_CANCEL = 2;
    public static final int PHOTO_DECODE_HEIGHT = 400;
    public static final int PHOTO_DECODE_WIDTH = 400;

    public static final int ITEM_CREATE_NEW_DREAM = 0;
    public static final int ITEM_GOTO_DREAMBOOK = 1;
}
