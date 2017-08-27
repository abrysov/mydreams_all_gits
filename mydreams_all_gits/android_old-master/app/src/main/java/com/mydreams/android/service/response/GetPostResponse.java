package com.mydreams.android.service.response;

import android.support.annotation.Nullable;

import com.mydreams.android.service.models.PostDto;
import com.mydreams.android.service.response.bodys.GetPostResponseBody;

public class GetPostResponse extends BaseServiceResponse<GetPostResponseBody>
{
	@Nullable
	public PostDto getPost()
	{
		return getBody().getPost();
	}
}
