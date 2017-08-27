package com.mydreams.android.components;

import com.mydreams.android.models.Dreamer;
import com.mydreams.android.utils.CustomDateUtils;

/**
 * Created by mikhail on 24.05.16.
 */
public class StringAppendingComponent {

    public static String getDreamerInfo(Dreamer dreamer) {
        String birthday = dreamer.getBirthday();
        String country = dreamer.getCountry() != null ? dreamer.getCountry().getNameCountry() : null;
        String city = dreamer.getCity() != null ? dreamer.getCity().getCityName() : null;
        String age = null;
        if (birthday != null) {
            age = CustomDateUtils.getAge(birthday);
        }
        String dreamerInfo = "";
        dreamerInfo = stringByAppendingComponent(dreamerInfo, age);
        dreamerInfo = stringByAppendingComponent(dreamerInfo, city);
        dreamerInfo = stringByAppendingComponent(dreamerInfo, country);
        return dreamerInfo;
    }

    public static String stringByAppendingComponent(String string, String component) {
        if (component != null && component.length() > 0) {
            if (string.length() > 0) {
                string = string + ", ";
            }
            string = string + component;
        }

        return string;
    }
}
