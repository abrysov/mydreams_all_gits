package com.mydreams.android.models;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.service.MyDreamsSpiceService;
import com.mydreams.android.service.models.SexType;
import com.mydreams.android.service.models.UserDto;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Transient;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

@Parcel(Parcel.Serialization.BEAN)
public class User
{
	private int id;

	private String firstName;

	private String lastName;

	private SexType sex;

	private Calendar birthDay;

	/**
	 * локация (полное название)
	 */
	private String location;
	private int locationId;

	private String avatarUrl;

	/**
	 * статус, цитата
	 */
	private String quote;

	private int friendCount;

	private int subscriberCount;

	private int launchesCount;

	private boolean isVip;
	/**
	 * кол-во предложенных мечт от друзей
	 */
	private int proposedCount;

	private String email;

	private String phone;

	private List<Photo> photos;
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
	private int dreamsComplete;
	private int dreams;
	private int posts;

	public User()
	{
	}

	public User(UserDto dto)
	{
		if (dto == null)
			throw new IllegalArgumentException("dto == null");

		id = dto.getId();
		firstName = dto.getFirstName();
		lastName = dto.getLastName();
		sex = dto.getSex();

		if (StringUtils.isNotBlank(dto.getBirthDayStr()))
		{
			birthDay = Calendar.getInstance();

			try
			{
				final SimpleDateFormat birthdayFormat = new SimpleDateFormat("yyyy-MM-dd", Locale.getDefault());
				birthDay.setTime(birthdayFormat.parse(dto.getBirthDayStr()));
			}
			catch (Exception ex)
			{
				ex.printStackTrace();
			}
		}

		location = dto.getLocation();
		locationId = dto.getLocationId();
		avatarUrl = dto.getAvatarUrl();
		quote = dto.getQuote();
		friendCount = dto.getFriendCount();
		subscriberCount = dto.getSubscriberCount();
		launchesCount = dto.getLaunchesCount();
		isVip = dto.isVip();
		proposedCount = dto.getProposed();
		email = dto.getEmail();
		phone = dto.getPhone();
		friend = dto.isFriend();
		subscribed = dto.isSubscribed();
		friendshipRequestSent = dto.isFriendshipRequestSent();

		if (dto.getPhotos() != null)
		{
			photos = Stream.of(dto.getPhotos()).map(Photo::new).collect(Collectors.toList());
		}
		else
		{
			photos = new ArrayList<>();
		}

		dreamsComplete = dto.getDreamsComplete();
		dreams = dto.getDreams();
		posts = dto.getPosts();
	}

	@Transient
	public String getAge()
	{
		if (birthDay == null)
			return "0";

		long elapsed = Calendar.getInstance().getTimeInMillis() - birthDay.getTimeInMillis();
		return String.format("%d", (int) (elapsed / (1000f * 60 * 60 * 24 * 365)));
	}

	public String getAvatarUrl()
	{
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl)
	{
		this.avatarUrl = avatarUrl;
	}

	public Calendar getBirthDay()
	{
		return birthDay;
	}

	public void setBirthDay(Calendar birthDay)
	{
		this.birthDay = birthDay;
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

	@Transient
	public String getFullAvatarUrl()
	{
		return avatarUrl == null ? null : MyDreamsSpiceService.BASE_URL + "/" + StringUtils.stripStart(avatarUrl, "/");
	}

	@Transient
	public String getFullName()
	{
		return firstName + " " + lastName;
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

	public List<Photo> getPhotos()
	{
		return photos;
	}

	public void setPhotos(List<Photo> photos)
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

	public int getProposedCount()
	{
		return proposedCount;
	}

	public void setProposedCount(int proposedCount)
	{
		this.proposedCount = proposedCount;
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
