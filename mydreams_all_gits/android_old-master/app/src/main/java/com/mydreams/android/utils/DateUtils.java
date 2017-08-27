package com.mydreams.android.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

public final class DateUtils
{
	public static Calendar toCalendar(final String iso8601string)
	{
		Calendar calendar = Calendar.getInstance();
		String s = iso8601string.replace("Z", "+00:00");
		try
		{
			s = s.substring(0, 22) + s.substring(23);  // to get rid of the ":"
		}
		catch (IndexOutOfBoundsException e)
		{
			return calendar;
		}

		try
		{
			Date date = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ", Locale.getDefault()).parse(s);
			calendar.setTime(date);
			return calendar;
		}
		catch (ParseException e)
		{
			e.printStackTrace();
			return calendar;
		}
	}
}
