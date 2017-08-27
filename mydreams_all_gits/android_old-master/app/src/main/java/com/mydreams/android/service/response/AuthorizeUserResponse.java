package com.mydreams.android.service.response;

import com.mydreams.android.service.models.UserDto;
import com.mydreams.android.service.response.bodys.AuthorizeUserBody;

public class AuthorizeUserResponse extends BaseServiceResponse<AuthorizeUserBody>
{
	public String getToken()
	{
		return getBody().getToken();
	}

	public UserDto getUser()
	{
		return getBody().getUser();
	}
}
