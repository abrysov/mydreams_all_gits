package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class PostInfoDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("imageUrl")
	private String imageUrl;

	@SerializedName("title")
	private String title;

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
