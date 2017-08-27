package com.mydreams.android.models;

import com.mydreams.android.service.MyDreamsSpiceService;
import com.mydreams.android.service.models.UserInfoDto;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Transient;

@Parcel(Parcel.Serialization.BEAN)
public class UserInfo
{
	private int id;

	private String fullName;

	private String avatarUrl;

	private String location;

	private String age;

	/**
	 * Это наш друг
	 */
	private boolean friend;

	/**
	 * Мы подписаны на этого юзера
	 */
	private boolean subscribed;
	/**
	 * Мы отправили запрос на дружбу
	 */
	private boolean friendshipRequestSent;
	private boolean isVip;

	public UserInfo()
	{
	}

	public UserInfo(User user)
	{
		id = user.getId();
		fullName = user.getFullName();
		avatarUrl = user.getAvatarUrl();
		location = user.getLocation();
		age = user.getAge();
		friend = user.isFriend();
		subscribed = user.isSubscribed();
		friendshipRequestSent = user.isFriendshipRequestSent();
		isVip = user.isVip();
	}

	public UserInfo(UserInfoDto dto)
	{
		id = dto.getId();
		fullName = dto.getFullName();
		avatarUrl = dto.getAvatarUrl();
		location = dto.getLocation();
		age = dto.getAge();
		friend = dto.isFriend();
		subscribed = dto.isSubscribed();
		friendshipRequestSent = dto.isFriendshipRequestSent();
		isVip = dto.isVip();
	}

	public String getAge()
	{
		return age != null ? age : "0";
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

	@Transient
	public String getFullAvatarUrl()
	{
		return avatarUrl == null ? null : MyDreamsSpiceService.BASE_URL + "/" + StringUtils.stripStart(avatarUrl, "/");
	}

	public String getFullName()
	{
		return StringUtils.defaultString(fullName);
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
		return StringUtils.defaultString(location);
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
