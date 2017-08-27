package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.response.bodys.GetDreamsResponseBody;

import java.util.List;

public class GetDreamsResponse extends BaseServiceResponse<GetDreamsResponseBody>
{
	@Nullable
	public List<DreamInfoDto> getDreams()
	{
		GetDreamsResponseBody.DreamCollectionBody collection = getBody().getDreamCollection();
		if (collection != null)
		{
			return collection.getDreams();
		}

		return null;
	}
}
