package com.mydreams.android.utils;

import android.text.format.DateFormat;
import android.text.format.DateUtils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by mikhail on 12.05.16.
 */
public class CustomDateUtils {

    public static String getDateFormat(CharSequence date) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
        Date oldDate = null;
        try {
            oldDate = simpleDateFormat.parse((String) date);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        date = DateUtils.getRelativeTimeSpanString(oldDate.getTime(), System.currentTimeMillis(), 0, DateUtils.FORMAT_ABBREV_ALL);

        return (String) date;
    }

    public static String getAge(CharSequence dreamerBirthday) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = simpleDateFormat.parse((String) dreamerBirthday);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        Calendar birthday = Calendar.getInstance();
        Calendar today = Calendar.getInstance();

        int year = Integer.parseInt((String) DateFormat.format("yyyy", date));
        int month = Integer.parseInt((String) DateFormat.format("MM", date));
        int day = Integer.parseInt((String) DateFormat.format("dd", date));

        birthday.set(year, month - 1, day);
        int age = today.get(Calendar.YEAR) - birthday.get(Calendar.YEAR);
        int todayMonth = today.get(Calendar.YEAR);
        int todayDayOfMonth = today.get(Calendar.DAY_OF_MONTH);

        if (todayMonth < birthday.get(Calendar.MONTH)) {
            age--;
        } else if(todayMonth == birthday.get(Calendar.MONTH) && todayDayOfMonth < birthday.get(Calendar.DAY_OF_MONTH)) {
            age--;
        }

        int ageInt = age;
        return String.valueOf(ageInt);
    }

    public static String getMonth(String birthday) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = simpleDateFormat.parse(birthday);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String month = (String) DateFormat.format("MM", date);
        return month;
    }

    public static String getDay(String birthday) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = simpleDateFormat.parse(birthday);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String day = (String) DateFormat.format("dd", date);
        return day;
    }

    public static String getYear(String birthday) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        Date date = null;
        try {
            date = simpleDateFormat.parse(birthday);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        String year = (String) DateFormat.format("yyyy", date);
        return year;
    }
}
