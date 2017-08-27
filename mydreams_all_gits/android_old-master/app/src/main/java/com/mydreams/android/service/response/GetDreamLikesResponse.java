package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.LikeDto;
import com.mydreams.android.service.response.bodys.GetDreamLikesResponseBody;

import java.util.List;

public class GetDreamLikesResponse extends BaseServiceResponse<GetDreamLikesResponseBody>
{
	@NonNull
	public List<LikeDto> getLike()
	{
		return getBody().getLikeCollectionBody().getLikes();
	}
}
