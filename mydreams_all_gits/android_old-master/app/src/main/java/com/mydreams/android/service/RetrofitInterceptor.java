package com.mydreams.android.service;

import com.mydreams.android.app.UserPreference;

import retrofit.RequestInterceptor;

public class RetrofitInterceptor implements RequestInterceptor
{
	private UserPreference mUserPreference;

	public RetrofitInterceptor(UserPreference userPreference)
	{
		mUserPreference = userPreference;
	}

	@Override
	public void intercept(RequestFacade request)
	{
		request.addHeader("Accept", "application/json");
		request.addHeader("User-agent", "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36");

		String userToken = mUserPreference.getUserToken();
		if (userToken != null)
		{
			request.addHeader("Authorization", userToken);
		}
	}
}
