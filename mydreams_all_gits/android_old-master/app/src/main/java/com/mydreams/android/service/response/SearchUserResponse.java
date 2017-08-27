package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.UserInfoDto;
import com.mydreams.android.service.response.bodys.SearchUserResponseBody;

import java.util.ArrayList;
import java.util.List;

public class SearchUserResponse extends BaseServiceResponse<SearchUserResponseBody>
{
	@NonNull
	public List<UserInfoDto> getUsers()
	{
		SearchUserResponseBody.UserInfoCollectionBody collection = getBody().getUserInfoCollectionBody();
		if (collection != null)
		{
			List<UserInfoDto> result = collection.getUserInfos();
			return result != null ? collection.getUserInfos() : new ArrayList<>();
		}

		return new ArrayList<>();
	}
}
