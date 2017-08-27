package com.mydreams.android.models;

import com.mydreams.android.service.models.CommentDto;
import com.mydreams.android.utils.DateUtils;

import org.apache.commons.lang3.StringUtils;

import java.util.Calendar;

public class Comment
{
	private int id;

	private UserInfo user;

	private Calendar date;

	private String text;

	private boolean isliked;

	public Comment()
	{
	}

	public Comment(CommentDto dto)
	{
		id = dto.getId();
		user = new UserInfo(dto.getUser());

		if (StringUtils.isNotBlank(dto.getDateStr()))
		{
			date = DateUtils.toCalendar(dto.getDateStr());
		}
		else
		{
			date = Calendar.getInstance();
		}

		text = dto.getText();
		isliked = dto.isliked();
	}

	public boolean isliked()
	{
		return isliked;
	}

	public Calendar getDate()
	{
		return date;
	}

	public void setDate(Calendar date)
	{
		this.date = date;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getText()
	{
		return text;
	}

	public void setText(String text)
	{
		this.text = text;
	}

	public UserInfo getUser()
	{
		return user;
	}

	public void setUser(UserInfo user)
	{
		this.user = user;
	}

	public void setIsliked(boolean isliked)
	{
		this.isliked = isliked;
	}
}
