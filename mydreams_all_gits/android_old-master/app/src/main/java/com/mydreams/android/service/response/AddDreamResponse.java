package com.mydreams.android.service.response;

import com.mydreams.android.service.response.bodys.AddDreamResponseBody;

public class AddDreamResponse extends BaseServiceResponse<AddDreamResponseBody>
{
	public int getId()
	{
		return getBody().getId();
	}
}
