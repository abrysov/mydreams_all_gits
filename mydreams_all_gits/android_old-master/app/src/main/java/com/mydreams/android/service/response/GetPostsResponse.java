package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.PostInfoDto;
import com.mydreams.android.service.response.bodys.GetPostsResponseBody;

import java.util.ArrayList;
import java.util.List;

public class GetPostsResponse extends BaseServiceResponse<GetPostsResponseBody>
{
	public int getPostTotal()
	{
		GetPostsResponseBody.PostCollectionBody collection = getBody().getPostCollection();
		if (collection != null)
		{
			return collection.getTotal();
		}

		return 0;
	}

	@NonNull
	public List<PostInfoDto> getPosts()
	{
		GetPostsResponseBody.PostCollectionBody collection = getBody().getPostCollection();
		if (collection != null)
		{
			return collection.getPosts();
		}

		return new ArrayList<>();
	}
}
