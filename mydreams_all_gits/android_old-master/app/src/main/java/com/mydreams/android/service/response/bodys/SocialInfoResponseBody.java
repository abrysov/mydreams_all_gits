package com.mydreams.android.service.response.bodys;

import android.support.annotation.Nullable;

import com.google.gson.annotations.SerializedName;
import com.mydreams.android.service.models.UserInfoDto;

import java.util.List;

public class SocialInfoResponseBody
{
	@Nullable
	@SerializedName("users")
	private UserInfoCollectionBody userInfoCollectionBody;

	@Nullable
	public UserInfoCollectionBody getUserInfoCollectionBody()
	{
		return userInfoCollectionBody;
	}

	public void setUserInfoCollectionBody(@Nullable UserInfoCollectionBody userInfoCollectionBody)
	{
		this.userInfoCollectionBody = userInfoCollectionBody;
	}

	public static class UserInfoCollectionBody
	{
		@SerializedName("total")
		private int total;

		@Nullable
		@SerializedName("items")
		private List<UserInfoDto> userInfos;

		public int getTotal()
		{
			return total;
		}

		public void setTotal(int total)
		{
			this.total = total;
		}

		@Nullable
		public List<UserInfoDto> getUserInfos()
		{
			return userInfos;
		}

		public void setUserInfos(@Nullable List<UserInfoDto> userInfos)
		{
			this.userInfos = userInfos;
		}
	}
}
