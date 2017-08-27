package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.response.bodys.LoginResponseBody;

public class LoginResponse extends BaseServiceResponse<LoginResponseBody>
{
	@Nullable
	public String getToken()
	{
		return getBody().getToken();
	}
}
