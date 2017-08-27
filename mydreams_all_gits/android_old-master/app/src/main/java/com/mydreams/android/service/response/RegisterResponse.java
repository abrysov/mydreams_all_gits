package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.response.bodys.RegisterResponseBody;

public class RegisterResponse extends BaseServiceResponse<RegisterResponseBody>
{
	@Nullable
	public String getToken()
	{
		return getBody().getToken();
	}
}
