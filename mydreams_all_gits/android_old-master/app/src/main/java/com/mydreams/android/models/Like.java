package com.mydreams.android.models;

import com.mydreams.android.service.models.LikeDto;
import com.mydreams.android.utils.DateUtils;

import org.apache.commons.lang3.StringUtils;

import java.util.Calendar;

public class Like
{
	private UserInfo owner;

	private Calendar date;

	public Like()
	{
	}

	public Like(LikeDto dto)
	{
		owner = new UserInfo(dto.getUser());

		if (StringUtils.isNotBlank(dto.getDateStr()))
		{
			date = DateUtils.toCalendar(dto.getDateStr());
		}
		else
		{
			date = Calendar.getInstance();
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
