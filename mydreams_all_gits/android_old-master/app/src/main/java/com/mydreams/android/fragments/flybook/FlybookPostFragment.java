package com.mydreams.android.fragments.flybook;

import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.FlybookPostAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.AddPostFragment;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.fragments.PostInfoFragment;
import com.mydreams.android.models.PostInfo;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.models.PostInfoDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.GetPostsResponse;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class FlybookPostFragment extends BaseFragment implements SwipeRefreshLayout.OnRefreshListener, EndlessScrollListener.IEndlessListener
{
	private static final int POST_PAGE_SIZE = 10;
	private static final String USER_INFO_ARGS_NAME = "USER_INFO_ARGS_NAME";
	@Bind(R.id.list)
	RecyclerView mList;
	@Bind(R.id.refreshLayout)
	SwipeRefreshLayout mRefreshLayout;
	@Bind(R.id.layoutRetry)
	View mLayoutRetry;
	private FlybookPostAdapter mAdapter;
	private UserPreference mUserPreference;
	private boolean mWaitPosts;
	/**
	 * Индекс следующей страницы. Индекс в отличии от самой страници начинается с НУЛЯ
	 */
	private int mNextPageIndex;
	private BaseSpiceRequest<GetPostsResponse> mPostsUpdateRequest;
	/**
	 * ещё есть страницы для загрузки
	 */
	private boolean mHasMorePages = true;

	public static FlybookPostFragment getInstance(UserInfo user,@Nullable @StyleRes Integer theme)
	{
		final Bundle args = new Bundle();
		if (user != null)
			args.putParcelable(USER_INFO_ARGS_NAME, Parcels.wrap(user));

		if(theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		FlybookPostFragment result = new FlybookPostFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		if (mWaitPosts || !mHasMorePages)
			return;

		mAdapter.setShowFooter(true);
		updatePosts(false);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_flybook_post, container, false);

		ButterKnife.bind(this, result);

		setShowRetry(false);

		mRefreshLayout.setOnRefreshListener(this);
		mRefreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new FlybookPostAdapter(dream -> handlePostClick(dream, false), dream -> handlePostClick(dream, true));
		mAdapter.setFooterView(R.layout.row_load_more);
		mAdapter.setShowFooter(true);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

		boolean isMe = mUserPreference.getUser() != null && getUserId() == mUserPreference.getUser().getId();
		fabAdd.setVisibility(isMe ? View.VISIBLE : View.GONE);

		return result;
	}

	@Override
	public void onRefresh()
	{
		mRefreshLayout.setRefreshing(true);
		mRefreshLayout.setEnabled(false);

		refreshAll();
	}

	@Override
	public void onResume()
	{
		super.onResume();

		refreshAll();
	}

	@Bind(R.id.fabAdd)
	View fabAdd;

	@OnClick(R.id.fabAdd)
	void onClickAdd()
	{
		Fragment fragment = AddPostFragment.getInstance(getThemeIdFromArgs());
		MainActivity mainActivity = (MainActivity) getActivity();
		mainActivity.putFragmentWithBackStack(fragment);
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		setShowRetry(false);
		refreshAll();
	}

	private int getUserId()
	{
		return getUserInfo().getId();
	}

	private UserInfo getUserInfo()
	{
		if (getArguments().containsKey(USER_INFO_ARGS_NAME))
			return Parcels.unwrap(getArguments().getParcelable(USER_INFO_ARGS_NAME));

		return new UserInfo(mUserPreference.getUser());
	}

	private void handlePost(@NonNull List<PostInfo> posts, boolean fullRefresh)
	{
		if (fullRefresh)
		{
			mAdapter.clear();
		}

		mAdapter.addAll(posts);
	}

	private void handlePostClick(PostInfo item, boolean showComment)
	{
		Fragment fragment = PostInfoFragment.getInstance(item, showComment, getThemeIdFromArgs());
		MainActivity mainActivity = (MainActivity) getActivity();
		mainActivity.putFragmentWithBackStack(fragment);
	}

	private void handlePostUpdateError(GetPostsResponse response)
	{
		if (response != null)
		{
			String message = response.getMessage();
			if (StringUtils.isNotBlank(message))
				showToast(message);
		}

		setShowRetry(true);
	}

	private void refreshAll()
	{
		stopPostUpdateRequest();

		mNextPageIndex = 0;
		mHasMorePages = true;

		mAdapter.setShowFooter(true);
		updatePosts(true);
	}

	private void setShowRetry(boolean show)
	{
		mRefreshLayout.setVisibility(show ? View.GONE : View.VISIBLE);
		mLayoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void setWaitPosts(boolean waitPosts)
	{
		this.mWaitPosts = waitPosts;
		updateLoadIndicators();
	}

	private void stopPostUpdateRequest()
	{
		if (mPostsUpdateRequest != null && !mPostsUpdateRequest.isCancelled())
		{
			mPostsUpdateRequest.cancel();
		}

		mPostsUpdateRequest = null;
	}

	private void updateLoadIndicators()
	{
		if (!mWaitPosts)
		{//скрываем все индикаторы загрузки если ни чего в данный момент не загружается
			mRefreshLayout.setEnabled(true);

			if (mRefreshLayout.isRefreshing())
				mRefreshLayout.setRefreshing(false);

			if (mAdapter.isShowFooter())
				mAdapter.setShowFooter(false);
		}
	}

	private void updatePosts(boolean fullRefresh)
	{
		setWaitPosts(true);

		stopPostUpdateRequest();

		mPostsUpdateRequest = RequestFactory.getPosts(getUserId(), mNextPageIndex + 1, POST_PAGE_SIZE);
		getSpiceManager().execute(mPostsUpdateRequest, new RequestListener<GetPostsResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handlePostUpdateError(null);

				setWaitPosts(false);
			}

			@Override
			public void onRequestSuccess(GetPostsResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					List<PostInfoDto> posts = response.getPosts();
					if (posts.size() > 0)
					{
						mNextPageIndex++;
					}
					else
					{
						mHasMorePages = false;
					}

					handlePost(Stream.of(posts).map(PostInfo::new).collect(Collectors.toList()), fullRefresh);

					FlybookFragment fragment = (FlybookFragment) getParentFragment();
					fragment.setPostCount(response.getPostTotal());
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						handlePostUpdateError(response);
					}
				}

				setWaitPosts(false);
			}
		});
	}
}
