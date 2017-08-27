package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.DreamDto;
import com.mydreams.android.service.models.DreamInfoDto;
import com.mydreams.android.service.response.bodys.DreamProposedResponseBody;

import java.util.ArrayList;
import java.util.List;

public class DreamProposedResponse extends BaseServiceResponse<DreamProposedResponseBody>
{
	@NonNull
	public List<DreamInfoDto> getDreams()
	{
		DreamProposedResponseBody.DreamCollectionBody collection = getBody().getDreamCollection();
		if (collection != null)
		{
			List<DreamInfoDto> dreams = collection.getDreams();
			if (dreams != null)
				return dreams;
		}

		return new ArrayList<>();
	}
}
