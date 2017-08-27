package com.mydreams.android.service.request.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.SexType;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

public class RegisterRequestBody
{
	private static final SimpleDateFormat birthdayFormat = new SimpleDateFormat("dd-MM-yyyy", Locale.getDefault());
	@Nullable
	@SerializedName("name")
	private String firstName;
	@Nullable
	@SerializedName("surname")
	private String lastName;
	@Nullable
	@SerializedName("email")
	private String email;
	@Nullable
	@SerializedName("phone")
	private String phone;
	@Nullable
	@SerializedName("password")
	private String password;
	@SerializedName("sex")
	private SexType sex;
	@SerializedName("birthday")
	private String birthday;
	@SerializedName("location")
	private int location;

	public String getBirthday()
	{
		return birthday;
	}

	public void setBirthday(String birthday)
	{
		this.birthday = birthday;
	}

	@Nullable
	public String getEmail()
	{
		return email;
	}

	public void setEmail(@Nullable String email)
	{
		this.email = email;
	}

	@Nullable
	public String getFirstName()
	{
		return firstName;
	}

	public void setFirstName(@Nullable String firstName)
	{
		this.firstName = firstName;
	}

	@Nullable
	public String getLastName()
	{
		return lastName;
	}

	public void setLastName(@Nullable String lastName)
	{
		this.lastName = lastName;
	}

	public int getLocation()
	{
		return location;
	}

	public void setLocation(int location)
	{
		this.location = location;
	}

	@Nullable
	public String getPassword()
	{
		return password;
	}

	public void setPassword(@Nullable String password)
	{
		this.password = password;
	}

	@Nullable
	public String getPhone()
	{
		return phone;
	}

	public void setPhone(@Nullable String phone)
	{
		this.phone = phone;
	}

	public SexType getSex()
	{
		return sex;
	}

	public void setSex(SexType sex)
	{
		this.sex = sex;
	}

	public void setBirthday(Calendar birthDate)
	{
		this.birthday = birthDate != null ? birthdayFormat.format(birthDate.getTime()) : null;
	}
}
