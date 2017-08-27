package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.LaunchDto;
import com.mydreams.android.service.response.bodys.GetDreamLaunchesResponseBody;

import java.util.List;

public class GetDreamLaunchesResponse extends BaseServiceResponse<GetDreamLaunchesResponseBody>
{
	@NonNull
	public List<LaunchDto> getLaunches()
	{
		return getBody().getLaunchCollectionBody().getLaunches();
	}
}
