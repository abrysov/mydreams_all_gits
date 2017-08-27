package com.mydreams.android.service.response;

import com.mydreams.android.service.response.bodys.UpdateProfileBody;

public class UpdateProfileResponse extends BaseServiceResponse<UpdateProfileBody>
{
	public boolean saveInfoSuccesses;
	public boolean saveAvatarSuccesses;

	public UpdateProfileResponse()
	{
	}
}
