package com.mydreams.android.models;

import com.mydreams.android.service.models.LaunchDto;
import com.mydreams.android.utils.DateUtils;

import org.apache.commons.lang3.StringUtils;

import java.util.Calendar;

public class Launch
{
	private UserInfo owner;

	private Calendar date;

	public Launch()
	{
	}

	public Launch(LaunchDto dto)
	{
		owner = new UserInfo(dto.getUser());

		if (StringUtils.isNotBlank(dto.getDateStr()))
		{
			date = DateUtils.toCalendar(dto.getDateStr());
		}
	}

	public Calendar getDate()
	{
		return date;
	}

	public void setDate(Calendar date)
	{
		this.date = date;
	}

	public UserInfo getUser()
	{
		return owner;
	}

	public void setOwner(UserInfo owner)
	{
		this.owner = owner;
	}
}
