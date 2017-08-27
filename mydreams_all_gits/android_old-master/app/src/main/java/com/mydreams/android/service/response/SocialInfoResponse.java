package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.UserInfoDto;
import com.mydreams.android.service.response.bodys.SocialInfoResponseBody;

import java.util.ArrayList;
import java.util.List;

public class SocialInfoResponse extends BaseServiceResponse<SocialInfoResponseBody>
{
	@NonNull
	public List<UserInfoDto> getUsers()
	{
		SocialInfoResponseBody.UserInfoCollectionBody collection = getBody().getUserInfoCollectionBody();
		if (collection != null)
		{
			List<UserInfoDto> result = collection.getUserInfos();
			return result != null ? collection.getUserInfos() : new ArrayList<>();
		}

		return new ArrayList<>();
	}
}
