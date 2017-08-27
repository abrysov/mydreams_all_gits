package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.response.bodys.SocialLoginResponseBody;

public class SocialLoginResponse extends BaseServiceResponse<SocialLoginResponseBody>
{
	@Nullable
	public String getToken()
	{
		return getBody().getToken();
	}
}
