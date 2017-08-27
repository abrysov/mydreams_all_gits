package com.mydreams.android.fragments;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.annimon.stream.function.Function;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.socialinfo.BaseSocialUserInfoAdapter;
import com.mydreams.android.adapters.socialinfo.SimpleSocialUserInfoAdapter;
import com.mydreams.android.fragments.socialinfo.BaseSocialInfoFragment;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.SocialInfoResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class ProposeDreamFragment extends BaseSocialInfoFragment implements EndlessScrollListener.IEndlessListener, SwipeRefreshLayout.OnRefreshListener
{
	private static final String DREAM_INFO_EXTRA_NAME = "DREAM_INFO_EXTRA_NAME";
	protected BaseSocialUserInfoAdapter mAdapter;
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout refreshLayout;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.layoutList)
	View layoutList;
	@Bind(R.id.lblEmptyListMessage)
	TextView lblEmptyListMessage;
	private ToolbarManager mToolbarManager;
	private DreamInfo dream;

	public static ProposeDreamFragment getInstance(DreamInfo dream)
	{
		Bundle args = new Bundle();
		args.putParcelable(DREAM_INFO_EXTRA_NAME, Parcels.wrap(dream));

		ProposeDreamFragment result = new ProposeDreamFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(true);

		loadNextPage();
	}

	@Override
	protected void addItems(List items)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(true);

		List<Object> userInfoModels = new ArrayList<>();

		for (Object obj : items)
		{
			UserInfo user = (UserInfo) obj;
			boolean showCapitalLetter = true;

			final String firstLetter = user.getFullName().substring(0, 1).toUpperCase();

			Function<List<Object>, Boolean> getShowCapitalLetter = value -> {
				ListIterator<Object> it = userInfoModels.listIterator(userInfoModels.size());
				while (it.hasPrevious())
				{
					Object obj2 = it.previous();
					if (obj2 instanceof SimpleSocialUserInfoAdapter.UserInfoModel)
					{
						String prevItemLetter = ((SimpleSocialUserInfoAdapter.UserInfoModel) obj2).capitalLetter;
						if (prevItemLetter.equalsIgnoreCase(firstLetter))
						{
							return false;
						}
					}
				}

				return true;
			};

			if (userInfoModels.size() != 0)
			{
				showCapitalLetter = getShowCapitalLetter.apply(userInfoModels);
			}
			else if (mAdapter.getAdapterItemCount() != 0)
			{
				showCapitalLetter = getShowCapitalLetter.apply(mAdapter.getItems());
			}

			if (showCapitalLetter && !(mAdapter.getAdapterItemCount() == 0 && userInfoModels.size() == 0))
			{
				userInfoModels.add(new SimpleSocialUserInfoAdapter.Divider());
			}

			SimpleSocialUserInfoAdapter.UserInfoModel userInfoModel = new SimpleSocialUserInfoAdapter.UserInfoModel(user, showCapitalLetter);
			userInfoModels.add(userInfoModel);
		}

		mAdapter.addAll(userInfoModels);

		showEmptyListMessage(mAdapter.getAdapterItemCount() == 0);
	}

	@Override
	protected BaseSpiceRequest<SocialInfoResponse> createRequest(String filter, int page)
	{
		return RequestFactory.getFriends(null, page, PAGE_SIZE, filter);
	}

	@Override
	protected void handleRequestFailure()
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(true);

		showRetry(true);
	}

	@Override
	protected void hideLoadMoreProgress()
	{
		mAdapter.setShowFooter(false);
	}

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		restoreSaveInstanceState(savedInstanceState);

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		View result = inflater.inflate(R.layout.fragment_friend_list, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.friends);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		showRetry(false);
		showEmptyListMessage(false);
		lblEmptyListMessage.setText(getEmptyListMessage());

		refreshLayout.setOnRefreshListener(this);
		refreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = createAdapter();
		mAdapter.setFooterView(R.layout.row_load_more);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

		return result;
	}

	@Override
	public void onRefresh()
	{
		refreshLayout.setRefreshing(true);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		hideLoadMoreProgress();

		refresh();
	}

	@Override
	public void onResume()
	{
		super.onResume();

		refresh();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);
	}

	@Override
	protected void removeAllItems()
	{
		mAdapter.clear();
	}

	@Override
	protected boolean shouldRetryRequest()
	{
		return mAdapter.getAdapterItemCount() != 0;
	}

	@Override
	protected void showLoadMoreProgress()
	{
		if (!refreshLayout.isRefreshing())
			mAdapter.setShowFooter(true);
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		showRetry(false);
		refresh();
	}

	protected BaseSocialUserInfoAdapter createAdapter()
	{
		return new SimpleSocialUserInfoAdapter(this::handleItemClick);
	}

	private DreamInfo getDream()
	{
		if (dream == null)
		{
			dream = Parcels.unwrap(getArguments().getParcelable(DREAM_INFO_EXTRA_NAME));
		}

		return dream;
	}

	protected int getEmptyListMessage()
	{
		return R.string.friends_empty_list;
	}

	private void handleItemClick(Object item)
	{
		if (item instanceof SimpleSocialUserInfoAdapter.UserInfoModel)
		{
			SimpleSocialUserInfoAdapter.UserInfoModel model = (SimpleSocialUserInfoAdapter.UserInfoModel) item;

			DialogInterface dialog = showProgressDialog(R.string.proposed_dream_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> request = RequestFactory.proposeDream(getDream().getId(), model.user.getId());
			getSpiceManager().execute(request, new RequestListener<EmptyResponse>()
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
						getFragmentManager().popBackStack();
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.propose_dream_error_message);
							showToast(message);
						}
					}
				}
			});
		}
	}

	protected void showEmptyListMessage(boolean show)
	{
		lblEmptyListMessage.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void showRetry(boolean show)
	{
		layoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
		layoutList.setVisibility(show ? View.GONE : View.VISIBLE);
	}
}
