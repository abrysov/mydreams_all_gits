package com.mydreams.android.service.response;

import android.support.annotation.NonNull;

import com.mydreams.android.service.models.CommentDto;
import com.mydreams.android.service.response.bodys.GetCommentsResponseBody;

import java.util.ArrayList;
import java.util.List;

public class GetCommentsResponse extends BaseServiceResponse<GetCommentsResponseBody>
{
	@NonNull
	public List<CommentDto> getComments()
	{
		GetCommentsResponseBody.CommentCollectionBody collection = getBody().getCommentCollectionBody();
		if (collection != null)
		{
			return collection.getComments();
		}

		return new ArrayList<>();
	}
}
