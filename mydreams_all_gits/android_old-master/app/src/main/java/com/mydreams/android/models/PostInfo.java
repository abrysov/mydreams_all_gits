package com.mydreams.android.models;

import android.support.annotation.Nullable;

import com.mydreams.android.service.MyDreamsSpiceService;
import com.mydreams.android.service.models.PostInfoDto;
import com.mydreams.android.utils.DateUtils;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;

import java.util.Date;

@Parcel(Parcel.Serialization.BEAN)
public class PostInfo
{
	private int id;
	private String imageUrl;
	private String title;
	private String description;
	private int likeCount;
	private int commentCount;
	private Date addDate;

	public PostInfo()
	{
	}

	public PostInfo(PostInfoDto dto)
	{
		id = dto.getId();
		imageUrl = dto.getImageUrl();
		title = dto.getTitle();
		description = dto.getDescription();

		String addDateStr = dto.getAddDate();
		if (addDateStr != null)
		{
			addDate = DateUtils.toCalendar(addDateStr).getTime();
		}
		else
		{
			addDate = new Date();
		}

		likeCount = dto.getLikeCount();
		commentCount = dto.getCommentCount();
	}

	public Date getAddDate()
	{
		return addDate;
	}

	public void setAddDate(Date addDate)
	{
		this.addDate = addDate;
	}

	public int getCommentCount()
	{
		return commentCount;
	}

	public void setCommentCount(int commentCount)
	{
		this.commentCount = commentCount;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	@Nullable
	public String getFullImageUrl()
	{
		return imageUrl == null ? null : MyDreamsSpiceService.BASE_URL + "/" + StringUtils.stripStart(imageUrl, "/");
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getImageUrl()
	{
		return imageUrl;
	}

	public void setImageUrl(String imageUrl)
	{
		this.imageUrl = imageUrl;
	}

	public int getLikeCount()
	{
		return likeCount;
	}

	public void setLikeCount(int likeCount)
	{
		this.likeCount = likeCount;
	}

	public String getTitle()
	{
		return title;
	}

	public void setTitle(String title)
	{
		this.title = title;
	}
}
