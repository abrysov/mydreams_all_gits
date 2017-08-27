package com.mydreams.android.models;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.service.models.UserActivityDto;
import com.mydreams.android.utils.DateUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class UserActivity
{
	private int id;
	private UserInfo user;
	private Date date;
	private String text;
	private List<Photo> photos;
	private DreamInfo dream;

	public UserActivity()
	{
	}

	public UserActivity(UserActivityDto dto)
	{
		id = dto.getId();
		user = new UserInfo(dto.getUser());

		String addDateStr = dto.getDate();
		if (addDateStr != null)
		{
			date = DateUtils.toCalendar(addDateStr).getTime();
		}
		else
		{
			date = new Date();
		}

		text = dto.getText();

		if (dto.getPhotos() != null)
		{
			photos = Stream.of(dto.getPhotos()).map(Photo::new).collect(Collectors.toList());
		}
		else
		{
			photos = new ArrayList<>();
		}

		if (dto.getDream() != null)
			dream = new DreamInfo(dto.getDream());
	}

	public Date getDate()
	{
		return date;
	}

	public void setDate(final Date date)
	{
		this.date = date;
	}

	public DreamInfo getDream()
	{
		return dream;
	}

	public void setDream(final DreamInfo dream)
	{
		this.dream = dream;
	}

	public int getId()
	{
		return id;
	}

	public void setId(final int id)
	{
		this.id = id;
	}

	public List<Photo> getPhotos()
	{
		return photos;
	}

	public void setPhotos(final List<Photo> photos)
	{
		this.photos = photos;
	}

	public String getText()
	{
		return text;
	}

	public void setText(final String text)
	{
		this.text = text;
	}

	public UserInfo getUser()
	{
		return user;
	}

	public void setUser(final UserInfo user)
	{
		this.user = user;
	}

	public boolean isDreamActivity()
	{
		return dream != null;
	}

	public boolean isPhotoActivity()
	{
		return photos != null && !photos.isEmpty();
	}

	public boolean isSimpleActivity()
	{
		return dream == null && (photos == null || photos.isEmpty());
	}
}
