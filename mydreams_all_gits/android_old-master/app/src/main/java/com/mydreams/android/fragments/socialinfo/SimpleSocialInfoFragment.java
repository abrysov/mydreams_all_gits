package com.mydreams.android.fragments.socialinfo;

import android.os.Bundle;
import android.support.annotation.StringRes;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.ContextThemeWrapper;
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
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.utils.animators.FadeInAnimator;

import java.util.ArrayList;
import java.util.List;
import java.util.ListIterator;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public abstract class SimpleSocialInfoFragment extends BaseSocialInfoFragment implements EndlessScrollListener.IEndlessListener, SwipeRefreshLayout.OnRefreshListener
{
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

	@StringRes
	protected abstract int getEmptyListMessage();

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		loadNextPage();
	}

	@Override
	protected void addItems(List items)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

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
	protected void handleRequestFailure()
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

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

		ContextThemeWrapper themeWrapper = new ContextThemeWrapper(inflater.getContext(), R.style.BlueTheme);
		inflater = LayoutInflater.from(themeWrapper);
		View result = inflater.inflate(R.layout.fragment_simple_social_info, container, false);

		ButterKnife.bind(this, result);

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

	protected void handleItemClick(Object item)
	{
		if (item instanceof SimpleSocialUserInfoAdapter.UserInfoModel)
		{
			SimpleSocialUserInfoAdapter.UserInfoModel model = (SimpleSocialUserInfoAdapter.UserInfoModel) item;
			Fragment fragment = FlybookFragment.getInstance(model.user);

			MainActivity activity = (MainActivity) getActivity();
			activity.putFragmentWithBackStack(fragment);
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
