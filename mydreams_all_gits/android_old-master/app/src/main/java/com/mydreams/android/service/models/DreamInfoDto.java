package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class DreamInfoDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("imageUrl")
	private String imageUrl;

	@SerializedName("name")
	private String name;

	@SerializedName("description")
	private String description;

	/**
	 * дата добавления
	 */
	@SerializedName("date")
	private String addDate;

	/**
	 * количество лайков
	 */
	@SerializedName("likes")
	private int likeCount;

	/**
	 * количество коментов
	 */
	@SerializedName("comments")
	private int commentCount;

	/**
	 * количество марок
	 */
	@SerializedName("stamps")
	private int launchesCount;

	@SerializedName("isdone")
	private boolean isDone;

	public String getAddDate()
	{
		return addDate;
	}

	public void setAddDate(String addDate)
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

	public int getLaunchesCount()
	{
		return launchesCount;
	}

	public void setLaunchesCount(int launchesCount)
	{
		this.launchesCount = launchesCount;
	}

	public int getLikeCount()
	{
		return likeCount;
	}

	public void setLikeCount(int likeCount)
	{
		this.likeCount = likeCount;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public boolean isDone()
	{
		return isDone;
	}

	public void setIsDone(final boolean isDone)
	{
		this.isDone = isDone;
	}
}
