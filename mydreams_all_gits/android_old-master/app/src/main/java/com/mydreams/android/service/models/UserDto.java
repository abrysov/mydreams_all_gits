package com.mydreams.android.service.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class UserDto
{
	@SerializedName("id")
	private int id;

	@SerializedName("name")
	private String firstName;

	@SerializedName("surname")
	private String lastName;

	@SerializedName("sex")
	private SexType sex;

	@SerializedName("birthday")
	private String birthDayStr;

	/**
	 * локация (полное название)
	 */
	@SerializedName("location")
	private String location;
	@SerializedName("locationId")
	private int locationId;

	@SerializedName("avatarUrl")
	private String avatarUrl;

	/**
	 * статус, цитата
	 */
	@SerializedName("quote")
	private String quote;

	@SerializedName("friends")
	private int friendCount;

	/**
	 * Gjlgbcxbrjd
	 */
	@SerializedName("subscribers")
	private int subscriberCount;

	@SerializedName("launches")
	private int launchesCount;

	@SerializedName("isVip")
	private boolean isVip;

	@SerializedName("friendshipRequestSended")
	private boolean friendshipRequestSent;
	/**
	 * кол-во предложенных мечт от друзей
	 */
	@SerializedName("proposed")
	private int proposed;

	@SerializedName("email")
	private String email;

	@SerializedName("phone")
	private String phone;

	@SerializedName("photos")
	private List<PhotoDto> photos;
	/**
	 * Это наш друг
	 */
	@SerializedName("friend")
	private boolean friend;
	/**
	 * Мы подписаны на этого юзера
	 */
	@SerializedName("subscribed")
	private boolean subscribed;


	@SerializedName("dreamsComplete")
	private int dreamsComplete;

	@SerializedName("dreams")
	private int dreams;

	@SerializedName("posts")
	private int posts;

	public String getAvatarUrl()
	{
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl)
	{
		this.avatarUrl = avatarUrl;
	}

	public String getBirthDayStr()
	{
		return birthDayStr;
	}

	public void setBirthDayStr(String birthDayStr)
	{
		this.birthDayStr = birthDayStr;
	}

	public int getDreams()
	{
		return dreams;
	}

	public void setDreams(final int dreams)
	{
		this.dreams = dreams;
	}

	public int getDreamsComplete()
	{
		return dreamsComplete;
	}

	public void setDreamsComplete(final int dreamsComplete)
	{
		this.dreamsComplete = dreamsComplete;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	public String getFirstName()
	{
		return firstName;
	}

	public void setFirstName(String firstName)
	{
		this.firstName = firstName;
	}

	public int getFriendCount()
	{
		return friendCount;
	}

	public void setFriendCount(int friendCount)
	{
		this.friendCount = friendCount;
	}

	public int getId()
	{
		return id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getLastName()
	{
		return lastName;
	}

	public void setLastName(String lastName)
	{
		this.lastName = lastName;
	}

	public int getLaunchesCount()
	{
		return launchesCount;
	}

	public void setLaunchesCount(int launchesCount)
	{
		this.launchesCount = launchesCount;
	}

	public String getLocation()
	{
		return location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	public int getLocationId()
	{
		return locationId;
	}

	public void setLocationId(int locationId)
	{
		this.locationId = locationId;
	}

	public String getPhone()
	{
		return phone;
	}

	public void setPhone(String phone)
	{
		this.phone = phone;
	}

	public List<PhotoDto> getPhotos()
	{
		return photos;
	}

	public void setPhotos(List<PhotoDto> photos)
	{
		this.photos = photos;
	}

	public int getPosts()
	{
		return posts;
	}

	public void setPosts(int posts)
	{
		this.posts = posts;
	}

	public int getProposed()
	{
		return proposed;
	}

	public void setProposed(int proposed)
	{
		this.proposed = proposed;
	}

	public String getQuote()
	{
		return quote;
	}

	public void setQuote(String quote)
	{
		this.quote = quote;
	}

	public SexType getSex()
	{
		return sex;
	}

	public void setSex(SexType sex)
	{
		this.sex = sex;
	}

	public int getSubscriberCount()
	{
		return subscriberCount;
	}

	public void setSubscriberCount(int subscriberCount)
	{
		this.subscriberCount = subscriberCount;
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
