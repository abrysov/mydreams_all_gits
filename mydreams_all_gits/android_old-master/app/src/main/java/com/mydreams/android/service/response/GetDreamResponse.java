package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.DreamDto;
import com.mydreams.android.service.response.bodys.GetDreamResponseBody;

public class GetDreamResponse extends BaseServiceResponse<GetDreamResponseBody>
{
	@Nullable
	public DreamDto getDream()
	{
		return getBody().getDream();
	}
}
