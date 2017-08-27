package com.mydreams.android.fragments.socialinfo;

import com.mydreams.android.R;
import com.mydreams.android.fragments.SocialInfoFragment;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.mydreams.android.service.response.bodys.SocialInfoResponseBody;

public class FriendsFragment extends SimpleSocialInfoFragment
{
	public static FriendsFragment getInstance()
	{
		return new FriendsFragment();
	}

	@Override
	protected BaseSpiceRequest<SocialInfoResponse> createRequest(String filter, int page)
	{
		return RequestFactory.getFriends(null, page, PAGE_SIZE, filter);
	}

	@Override
	protected int getEmptyListMessage()
	{
		return R.string.friends_empty_list;
	}

	@Override
	protected boolean handleRequestResult(final SocialInfoResponse response, final int requestId, final RequestCriteria criteria)
	{
		boolean result = super.handleRequestResult(response, requestId, criteria);
		if (result)
		{
			SocialInfoResponseBody.UserInfoCollectionBody collectionBody = response.getBody().getUserInfoCollectionBody();
			if (collectionBody != null)
			{
				int total = collectionBody.getTotal();
				SocialInfoFragment fragment = (SocialInfoFragment) getParentFragment();
				fragment.setFriendCount(total);
			}
		}

		return result;
	}
}
