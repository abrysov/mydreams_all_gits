package com.mydreams.android.models;

import com.mydreams.android.service.models.AgeRange;
import com.mydreams.android.service.models.SexType;

import org.parceler.Parcel;

@Parcel(Parcel.Serialization.BEAN)
public class FilterUser
{
	private AgeRange ageRange;
	private SexType sexType;
	private Country country;
	private Location city;
	private Boolean popular;
	private Boolean newUsers;
	private Boolean online;
	private Boolean vip;

	public Country getCountry()
	{
		return country;
	}

	public void setCountry(final Country country)
	{
		this.country = country;
	}

	public Location getCity()
	{
		return city;
	}

	public void setCity(final Location city)
	{
		this.city = city;
	}

	public AgeRange getAgeRange()
	{
		return ageRange;
	}

	public void setAgeRange(final AgeRange ageRange)
	{
		this.ageRange = ageRange;
	}

	public Boolean getNewUsers()
	{
		return newUsers;
	}

	public void setNewUsers(final Boolean newUsers)
	{
		this.newUsers = newUsers;
	}

	public Boolean getOnline()
	{
		return online;
	}

	public void setOnline(final Boolean online)
	{
		this.online = online;
	}

	public Boolean getPopular()
	{
		return popular;
	}

	public void setPopular(final Boolean popular)
	{
		this.popular = popular;
	}

	public SexType getSexType()
	{
		return sexType;
	}

	public void setSexType(final SexType sexType)
	{
		this.sexType = sexType;
	}

	public Boolean getVip()
	{
		return vip;
	}

	public void setVip(final Boolean vip)
	{
		this.vip = vip;
	}
}
