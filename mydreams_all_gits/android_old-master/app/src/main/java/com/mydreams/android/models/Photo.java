package com.mydreams.android.models;

import android.support.annotation.Nullable;

import com.mydreams.android.service.MyDreamsSpiceService;
import com.mydreams.android.service.models.PhotoDto;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;

@Parcel(Parcel.Serialization.BEAN)
public class Photo
{
	private int id;
	private String url;
	private String thumbUrl;

	public Photo()
	{
	}

	public Photo(PhotoDto dto)
	{
		id = dto.getId();
		url = dto.getUrl();
		thumbUrl = dto.getThumbUrl();
	}

	@Nullable
	public String getFullImageUrl()
	{
		return url == null ? null : MyDreamsSpiceService.BASE_URL + "/" + StringUtils.stripStart(url, "/");
	}

	@Nullable
	public String getFullThumbUrl()
	{
		return thumbUrl == null ? null : MyDreamsSpiceService.BASE_URL + "/" + StringUtils.stripStart(thumbUrl, "/");
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getThumbUrl()
	{
		return thumbUrl;
	}

	public void setThumbUrl(String thumbUrl)
	{
		this.thumbUrl = thumbUrl;
	}

	public String getUrl()
	{
		return url;
	}

	public void setUrl(String url)
	{
		this.url = url;
	}
}
