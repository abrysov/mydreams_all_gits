package com.mydreams.android.service.response;

import com.mydreams.android.service.response.bodys.AddPostResponseBody;

public class AddPostResponse extends BaseServiceResponse<AddPostResponseBody>
{
	public int getId()
	{
		return getBody().getId();
	}
}
