package com.mydreams.android.app;

import android.content.Context;
import android.content.SharedPreferences;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;

import com.google.gson.Gson;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.models.User;
import com.mydreams.android.service.gson.MyDreamsGsonBuilder;

import org.apache.commons.lang3.StringUtils;

import java.util.Random;

public class UserPreference
{
	private static final String PREFERENCES_NAME = "MyDreamsPreferencesName";
	private static final String USER_TOKEN_NAME = "USER_TOKEN";
	private static final String USER_NAME = "USER";
	@NonNull
	private final SharedPreferences preferences;
	@NonNull
	private final Gson mGson;
	private Boolean mUserIsVip;

	public UserPreference(@NonNull Context context)
	{
		preferences = context.getSharedPreferences(PREFERENCES_NAME, Context.MODE_PRIVATE);
		mGson = MyDreamsGsonBuilder.Build();
	}

	@Nullable
	public User getUser()
	{
		User user = getObject(USER_NAME, User.class);

		if (BuildConfig.DEBUG && user != null)
		{
			if(mUserIsVip == null )
				mUserIsVip  = new Random(System.currentTimeMillis()).nextBoolean();

			user.setIsVip(mUserIsVip);
		}

		return user;
	}

	private void setUser(@Nullable User value)
	{
		setObject(USER_NAME, value);
	}

	@Nullable
	public String getUserToken()
	{
		return getString(USER_TOKEN_NAME);
	}

	private void setUserToken(@Nullable String token)
	{
		setString(USER_TOKEN_NAME, token);
	}

	public boolean isLogined()
	{
		return StringUtils.isNotBlank(getUserToken()) && getUser() != null;
	}

	public void login(@NonNull String userToken, @NonNull User user)
	{
		setUserToken(userToken);
		setUser(user);
	}

	public void logout()
	{
		setUserToken(null);
		setUser(null);
	}

	public void updateUser(@NonNull User user)
	{
		if (isLogined())
		{
			setUser(user);
		}
	}

	private <T> T getObject(@NonNull String key, Class<T> classOfT)
	{
		String json = getString(key);
		if (json != null)
		{
			try
			{
				return mGson.fromJson(json, classOfT);
			}
			catch (Exception ex)
			{
				Log.w("UserPreference", "getObject", ex);
				setObject(key, null);
				return null;
			}
		}
		else
		{
			return null;
		}
	}

	@Nullable
	private String getString(@NonNull String key)
	{
		if (preferences.contains(key))
			return preferences.getString(key, null);

		return null;
	}

	private void setObject(@NonNull String key, @Nullable Object value)
	{
		if (value != null)
		{
			setString(key, mGson.toJson(value));
		}
		else
		{
			setString(key, null);
		}
	}

	private void setString(@NonNull String key, @Nullable String value)
	{
		if (value != null)
		{
			preferences.edit().putString(key, value).apply();
		}
		else
		{
			preferences.edit().remove(key).apply();
		}
	}
}
