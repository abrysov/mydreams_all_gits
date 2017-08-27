package com.mydreams.android.fragments;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.widget.DatePicker;

import com.mydreams.android.components.OnDatePickerListener;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.Map;

/**
 * Created by mikhail on 14.03.16.
 */
public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {

    private OnDatePickerListener callback;
    private Map<String, Integer> monthsList;
    private Calendar calendar;

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);

        try {
            callback = (OnDatePickerListener) activity;
        } catch (ClassCastException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    private void initMonthsList() {
        monthsList = calendar.getDisplayNames(Calendar.MONTH, Calendar.SHORT, Locale.getDefault());
    }

    public void setCallback(OnDatePickerListener datePickerListener) {
        callback = datePickerListener;
    }

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);

        initMonthsList();

        DatePickerDialog datePickerDialog = new DatePickerDialog(getActivity(), this, year, month, day);
        datePickerDialog.getDatePicker().setMaxDate(calendar.getTimeInMillis());

        return datePickerDialog;
    }

    private String getMonthName(int month) {
        String monthName = null;
        for (Map.Entry<String, Integer> months: monthsList.entrySet()) {
            if (month == months.getValue()) {
                monthName = months.getKey();
            }
        }
        return monthName;
    }

    private String getDateFormat(int day, int monthNum, int year) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(0);
        cal.set(year, monthNum, day);
        Date date = cal.getTime();

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        return simpleDateFormat.format(date);
    }

    @Override
    public void onDateSet(DatePicker view, int year, int month, int day) {
        String monthName = getMonthName(month);
        String dateFormat = getDateFormat(day, month, year);

        if (callback != null) {
            callback.setDate(year, monthName, day, dateFormat);
        }
    }
}
