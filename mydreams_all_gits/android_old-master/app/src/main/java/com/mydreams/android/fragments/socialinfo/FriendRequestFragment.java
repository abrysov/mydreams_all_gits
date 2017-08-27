package com.mydreams.android.fragments.socialinfo;

import android.content.DialogInterface;

import com.mydreams.android.R;
import com.mydreams.android.adapters.socialinfo.BaseSocialUserInfoAdapter;
import com.mydreams.android.adapters.socialinfo.FriendRequestAdapter;
import com.mydreams.android.fragments.SocialInfoFragment;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.mydreams.android.service.response.bodys.SocialInfoResponseBody;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class FriendRequestFragment extends SimpleSocialInfoFragment
{
	public static FriendRequestFragment getInstance()
	{
		return new FriendRequestFragment();
	}

	@Override
	protected void addItems(List items)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		List<FriendRequestAdapter.FriendRequestModel> models = new ArrayList<>();
		for (Object it : items)
		{
			FriendRequestAdapter.FriendRequestModel userInfoModel = new FriendRequestAdapter.FriendRequestModel((UserInfo) it);
			models.add(userInfoModel);
		}

		mAdapter.addAll(models);

		showEmptyListMessage(mAdapter.getAdapterItemCount() == 0);
	}

	@Override
	protected BaseSocialUserInfoAdapter createAdapter()
	{
		return new FriendRequestAdapter(this::handleClickAccept, this::handleClickRemove);
	}

	@Override
	protected BaseSpiceRequest<SocialInfoResponse> createRequest(String filter, int page)
	{
		return RequestFactory.getFriendRequests(null, page, PAGE_SIZE, filter);
	}

	@Override
	protected int getEmptyListMessage()
	{
		return R.string.friends_request_empty_list;
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
				fragment.setRequestCount(total);
			}
		}

		return result;
	}

	private void handleClickAccept(int position)
	{
		FriendRequestAdapter.FriendRequestModel item = (FriendRequestAdapter.FriendRequestModel) mAdapter.getItem(position);

		DialogInterface dialog = showProgressDialog(R.string.accept_friend_dialog_title, R.string.please_wait);

		BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.acceptRequest(item.getUser().getId());
		getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				dialog.cancel();

				showToast(R.string.connection_error_message);
			}

			@Override
			public void onRequestSuccess(EmptyResponse response)
			{
				dialog.cancel();

				if (response.getCode() == ResponseStatus.Ok)
				{
					SocialInfoFragment fragment = (SocialInfoFragment) getParentFragment();
					fragment.setRequestCount(fragment.getRequestCount() - 1);
					fragment.setFriendCount(fragment.getFriendCount() + 1);

					showToast(R.string.accept_request_friendship_success);
					mAdapter.remove(position);
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.accept_request_friendship_failed);
						showToast(message);
					}
				}
			}
		});
	}

	private void handleClickRemove(int position)
	{
		FriendRequestAdapter.FriendRequestModel item = (FriendRequestAdapter.FriendRequestModel) mAdapter.getItem(position);
		mAdapter.remove(position);

		SocialInfoFragment fragment = (SocialInfoFragment) getParentFragment();
		fragment.setRequestCount(fragment.getRequestCount() - 1);

		BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.denyRequest(item.getUser().getId());
		getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{

			}

			@Override
			public void onRequestSuccess(EmptyResponse response)
			{
			}
		});
	}
}
