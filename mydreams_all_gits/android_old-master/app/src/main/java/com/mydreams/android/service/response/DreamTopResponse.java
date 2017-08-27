package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.response.bodys.DreamTopResponseBody;

import java.util.ArrayList;
import java.util.List;

public class DreamTopResponse extends BaseServiceResponse<DreamTopResponseBody>
{
	@NonNull
	public List<DreamInfoDto> getDreams()
	{
		DreamTopResponseBody.DreamCollectionBody collection = getBody().getDreamCollection();
		if (collection != null)
		{
			List<DreamInfoDto> dreams = collection.getDreams();
			if (dreams != null)
				return dreams;
		}

		return new ArrayList<>();
	}
}
