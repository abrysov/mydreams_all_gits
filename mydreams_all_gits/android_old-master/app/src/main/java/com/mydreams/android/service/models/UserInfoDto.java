package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

public class UserInfoDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("fullname")
	private String fullName;

	@SerializedName("avatarUrl")
	private String avatarUrl;

	@SerializedName("location")
	private String location;

	@SerializedName("age")
	private String age;

	@SerializedName("friend")
	private boolean friend;

	@SerializedName("subscribed ")
	private boolean subscribed;
	@SerializedName("friendshipRequestSended")
	private boolean friendshipRequestSent;

	@SerializedName("isVip")
	private boolean isVip;

	public String getAge()
	{
		return age;
	}

	public void setAge(String age)
	{
		this.age = age;
	}

	public String getAvatarUrl()
	{
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl)
	{
		this.avatarUrl = avatarUrl;
	}

	public String getFullName()
	{
		return fullName;
	}

	public void setFullName(String fullName)
	{
		this.fullName = fullName;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getLocation()
	{
		return location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	public boolean isFriend()
	{
		return friend;
	}

	public void setFriend(boolean friend)
	{
		this.friend = friend;
	}

	public boolean isFriendshipRequestSent()
	{
		return friendshipRequestSent;
	}

	public void setFriendshipRequestSent(boolean friendshipRequestSent)
	{
		this.friendshipRequestSent = friendshipRequestSent;
	}

	public boolean isSubscribed()
	{
		return subscribed;
	}

	public void setSubscribed(boolean subscribed)
	{
		this.subscribed = subscribed;
	}

	public boolean isVip()
	{
		return isVip;
	}

	public void setIsVip(boolean isVip)
	{
		this.isVip = isVip;
	}
}
