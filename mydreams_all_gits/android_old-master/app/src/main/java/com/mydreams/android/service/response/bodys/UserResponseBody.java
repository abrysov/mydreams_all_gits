package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.UserDto;

public class UserResponseBody
{
	@SerializedName("profile")
	private UserDto profile;

	public UserDto getProfile()
	{
		return profile;
	}

	public void setProfile(UserDto profile)
	{
		this.profile = profile;
	}
}
