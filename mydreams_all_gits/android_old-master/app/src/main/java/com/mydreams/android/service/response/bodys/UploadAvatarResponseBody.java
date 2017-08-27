package com.mydreams.android.service.response.bodys;

import com.google.gson.annotations.SerializedName;

public class UploadAvatarResponseBody
{
	@SerializedName("avatarUrl")
	private String avatarUrl;

	public String getAvatarUrl()
	{
		return avatarUrl;
	}

	public void setAvatarUrl(String avatarUrl)
	{
		this.avatarUrl = avatarUrl;
	}
}
