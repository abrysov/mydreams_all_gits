package com.mydreams.android.fragments.socialinfo;

import com.mydreams.android.R;
import com.mydreams.android.fragments.SocialInfoFragment;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.mydreams.android.service.response.bodys.SocialInfoResponseBody;

public class SubscribersFragment extends SimpleSocialInfoFragment
{
	public static SubscribersFragment getInstance()
	{
		return new SubscribersFragment();
	}

	@Override
	protected BaseSpiceRequest<SocialInfoResponse> createRequest(String filter, int page)
	{
		return RequestFactory.getSubscribers(null, page, PAGE_SIZE, filter);
	}

	@Override
	protected int getEmptyListMessage()
	{
		return R.string.friends_subscribers_empty_list;
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
				fragment.setSubscribersCount(total);
			}
		}

		return result;
	}
}
