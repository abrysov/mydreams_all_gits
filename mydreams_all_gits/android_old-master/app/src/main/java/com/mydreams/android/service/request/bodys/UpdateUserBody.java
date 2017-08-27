package com.mydreams.android.service.request.bodys;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.fragments.EditUserFragment;

public class UpdateUserBody
{
	@SerializedName("quote")
	private String quote;
	@SerializedName("name")
	private String name;
	@SerializedName("surname")
	private String surname;
	@SerializedName("email")
	private String email;
	@SerializedName("birthday")
	private String birthday;
	@SerializedName("phone")
	private String phone;
	@SerializedName("password")
	private String newPassword;
	@SerializedName("oldpassword")
	private String oldPassword;
	@SerializedName("location")
	private Integer locationId;

	public UpdateUserBody()
	{
	}

	public UpdateUserBody(EditUserFragment.EditModel model)
	{
		name = model.firstName;
		surname = model.lastName;
		email = model.email;
		phone = model.phone;
		newPassword = model.newPassword;
		oldPassword = model.oldPassword;
		locationId = model.locationId;
		quote = model.quote;
	}

	public String getBirthday()
	{
		return birthday;
	}

	public void setBirthday(String birthday)
	{
		this.birthday = birthday;
	}

	public String getEmail()
	{
		return email;
	}

	public void setEmail(String email)
	{
		this.email = email;
	}

	public Integer getLocationId()
	{
		return locationId;
	}

	public void setLocationId(Integer locationId)
	{
		this.locationId = locationId;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getNewPassword()
	{
		return newPassword;
	}

	public void setNewPassword(String newPassword)
	{
		this.newPassword = newPassword;
	}

	public String getOldPassword()
	{
		return oldPassword;
	}

	public void setOldPassword(String oldPassword)
	{
		this.oldPassword = oldPassword;
	}

	public String getPhone()
	{
		return phone;
	}

	public void setPhone(String phone)
	{
		this.phone = phone;
	}

	public String getQuote()
	{
		return quote;
	}

	public void setQuote(String quote)
	{
		this.quote = quote;
	}

	public String getSurname()
	{
		return surname;
	}

	public void setSurname(String surname)
	{
		this.surname = surname;
	}
}
