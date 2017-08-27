package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.UserDto;
import com.mydreams.android.service.response.bodys.UserResponseBody;

public class UserResponse extends BaseServiceResponse<UserResponseBody>
{
	@Nullable
	public UserDto getUser()
	{
		return getBody().getProfile();
	}
}
