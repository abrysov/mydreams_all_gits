package com.mydreams.android.fragments.dreaminfo;

import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.SparseArray;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.TextView;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.adapters.EndlessScrollListener;
import com.mydreams.android.adapters.dreaminfo.DreamCommentAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.fragments.DreamInfoFragment;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.models.Comment;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.service.models.CommentDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.GetCommentsResponse;
import com.mydreams.android.utils.animators.FadeInAnimator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class DreamCommentsFragment extends BaseFragment implements EndlessScrollListener.IEndlessListener, SwipeRefreshLayout.OnRefreshListener, TextView.OnEditorActionListener
{
	protected static final int PAGE_SIZE = 20;
	private static final String DREAM_INFO_EXTRA_NAME = "DREAM_INFO_EXTRA_NAME";
	/* когда былы последнее изменение лайка/анлайка для комента */
	private final SparseArray<Long> lastCommentLikeChange = new SparseArray<>();
	protected DreamCommentAdapter mAdapter;
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
	@Bind(R.id.commentWrapper)
	com.rey.material.widget.EditText commentWrapper;
	private DreamInfo dreamInfo;
	/**
	 * Последний исполняющийся  запрос
	 */
	@Nullable
	private BaseSpiceRequest<GetCommentsResponse> lastRequest;
	private int nextPageIndex;
	private AtomicInteger currentRequestId = new AtomicInteger();
	@Nullable
	private RequestCriteria waitingCriteria;
	private boolean availableNextPage = true;

	public static Fragment getInstance(@NonNull DreamInfo item, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(DREAM_INFO_EXTRA_NAME, Parcels.wrap(item));

		if (theme == null)
			theme = R.style.AppTheme;
		setThemeIdInArgs(args, theme);

		Fragment result = new DreamCommentsFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void OnEnd(int maxLastVisiblePosition)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		loadNextPage();
	}

	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_dream_comment, container, false);

		ButterKnife.bind(this, result);

		showRetry(false);
		showEmptyListMessage(false);
		lblEmptyListMessage.setText(getEmptyListMessage());

		refreshLayout.setOnRefreshListener(this);
		refreshLayout.setColorSchemeColors(getResources().getIntArray(R.array.progress_colors));

		mAdapter = new DreamCommentAdapter(this::handleItemClick, this::handleLikeClick);
		mAdapter.setFooterView(R.layout.row_load_more);

		mList.setAdapter(mAdapter);
		mList.setItemAnimator(new FadeInAnimator());
		mList.setHasFixedSize(false);
		mList.setLayoutManager(new LinearLayoutManager(getActivity()));
		mList.addOnScrollListener(new EndlessScrollListener(this));

		commentWrapper.setOnEditorActionListener(this);

		return result;
	}

	@Override
	public boolean onEditorAction(TextView v, int actionId, KeyEvent event)
	{
		if (actionId == EditorInfo.IME_ACTION_SEND)
		{
			sendComment();
		}

		return true;
	}

	@Override
	public void onPause()
	{
		super.onPause();

		closeCurrentRequest();
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

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		showRetry(false);
		refresh();
	}

	@OnClick(R.id.btnSubmit)
	void onClickSubmit()
	{
		sendComment();
	}

	@OnTextChanged(R.id.editComment)
	void onCommentChange()
	{
		commentWrapper.clearError();
	}

	private void addItems(List<CommentDto> items)
	{
		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		mAdapter.addAll(Stream.of(items).map(Comment::new).map(DreamCommentAdapter.CommentModel::new).collect(Collectors.toList()));
		showEmptyListMessage(mAdapter.getAdapterItemCount() == 0);
	}

	/**
	 * останавливает текущий запрос
	 */
	private void closeCurrentRequest()
	{
		if (lastRequest != null)
		{
			lastRequest.cancel();
			lastRequest = null;
		}

		waitingCriteria = null;
	}

	private void executeRequest(RequestCriteria criteria)
	{
		closeCurrentRequest();

		int requestId = currentRequestId.incrementAndGet();
		waitingCriteria = criteria;

		BaseSpiceRequest<GetCommentsResponse> request = RequestFactory.getDreamComments(getDreamInfo().getId(), nextPageIndex + 1, PAGE_SIZE);
		lastRequest = request;
		getSpiceManager().execute(request, new RequestListener<GetCommentsResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				handleRequestFailure(spiceException, requestId, criteria);
			}

			@Override
			public void onRequestSuccess(GetCommentsResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					handleRequestResult(response, requestId, criteria);
				}
				else
				{
					handleRequestFailure(null, requestId, criteria);
				}
			}
		});
	}

	private DreamInfo getDreamInfo()
	{
		if (dreamInfo == null)
		{
			dreamInfo = Parcels.unwrap(getArguments().getParcelable(DREAM_INFO_EXTRA_NAME));
		}

		return dreamInfo;
	}

	@StringRes
	private int getEmptyListMessage()
	{
		return R.string.dream_comments_empty_list;
	}

	private void handleItemClick(int position)
	{
		DreamCommentAdapter.CommentModel model = (DreamCommentAdapter.CommentModel) mAdapter.getItem(position);
		Fragment fragment = FlybookFragment.getInstance(model.getComment().getUser());

		MainActivity activity = (MainActivity) getActivity();
		activity.putFragmentWithBackStack(fragment);
	}

	private void handleLikeClick(int position)
	{
		DreamCommentAdapter.CommentModel model = (DreamCommentAdapter.CommentModel) mAdapter.getItem(position);

		Long lastChange = lastCommentLikeChange.get(model.getComment().getId());
		if (lastChange != null && System.currentTimeMillis() - lastChange < 1000)
		{
			return;
		}

		lastCommentLikeChange.put(model.getComment().getId(), System.currentTimeMillis());
		if (model.getComment().isliked())
		{
			BaseSpiceRequest<EmptyResponse> request = RequestFactory.unlikeComment(model.getComment().getId());
			getSpiceManager().execute(request, new RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					if (!model.getComment().isliked())
					{
						model.getComment().setIsliked(true);
						mAdapter.notifyItemChanged(position);
					}
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					if (response.getCode() == ResponseStatus.Ok)
					{
						if (model.getComment().isliked())
						{
							model.getComment().setIsliked(false);
							mAdapter.notifyItemChanged(position);
						}
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
					}
				}
			});
		}
		else
		{
			BaseSpiceRequest<EmptyResponse> request = RequestFactory.likeComment(model.getComment().getId());
			getSpiceManager().execute(request, new RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					model.getComment().setIsliked(false);
					mAdapter.notifyItemChanged(position);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					if (response.getCode() == ResponseStatus.Ok)
					{
						if (!model.getComment().isliked())
						{
							model.getComment().setIsliked(true);
							mAdapter.notifyItemChanged(position);
						}
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
					}
				}
			});
		}

		model.getComment().setIsliked(!model.getComment().isliked());
		mAdapter.notifyItemChanged(position);
	}

	private void handleRequestFailure(@Nullable SpiceException spiceException, int requestId, RequestCriteria criteria)
	{
		if (spiceException != null)
			spiceException.printStackTrace();

		if (isCurrentRequest(requestId))
		{
			waitingCriteria = null;

			if (!criteria.fullRefresh && shouldRetryRequest())
			{
				executeRequest(criteria);
			}
			else
			{
				hideLoadMoreProgress();

				handleRequestFailure();
			}

		}
	}

	private void handleRequestFailure()
	{
		waitingCriteria = null;

		refreshLayout.setRefreshing(false);
		refreshLayout.setEnabled(!refreshLayout.isRefreshing());

		showRetry(true);
	}

	private void handleRequestResult(GetCommentsResponse response, int requestId, RequestCriteria criteria)
	{
		if (isCurrentRequest(requestId))
		{
			waitingCriteria = null;

			hideLoadMoreProgress();

			if (criteria.fullRefresh)
				removeAllItems();

			if (response.getCode() == ResponseStatus.Ok)
			{
				List<CommentDto> comment = response.getComments();
				availableNextPage = comment.size() == PAGE_SIZE;

				addItems(comment);

				DreamInfoFragment parent = (DreamInfoFragment) getParentFragment();
				if (parent != null)
				{
					if (response.getBody().getCommentCollectionBody() != null)
						parent.setComments(response.getBody().getCommentCollectionBody().getTotal());
				}
			}
		}
	}

	private void hideLoadMoreProgress()
	{
		mAdapter.setShowFooter(false);
	}

	private boolean isCurrentRequest(int requestId)
	{
		return currentRequestId.get() == requestId;
	}

	private void loadNextPage()
	{
		if (waitingCriteria != null && waitingCriteria.fullRefresh)
			return;

		if (!availableNextPage)
			return;

		showLoadMoreProgress();

		RequestCriteria newCriteria = RequestCriteria.forLoadMore();
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		executeRequest(newCriteria);
		nextPageIndex++;
	}

	private void refresh()
	{
		RequestCriteria newCriteria = RequestCriteria.forRefresh();
		if (RequestCriteria.equals(waitingCriteria, newCriteria))
			return;

		showLoadMoreProgress();

		availableNextPage = true;
		nextPageIndex = 0;
		executeRequest(newCriteria);
		nextPageIndex++;
	}

	private void removeAllItems()
	{
		mAdapter.clear();
	}

	private void sendComment()
	{
		String comment = commentWrapper.getText().toString();
		if (StringUtils.isNotBlank(comment))
		{
			DialogInterface dialog = showProgressDialog(R.string.add_comment_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.addDreamComment(getDreamInfo().getId(), comment);
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
						commentWrapper.setText("");
						refresh();
					}
					else
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.add_comment_error_message);
						showToast(message);
					}
				}
			});
		}
		else
		{
			commentWrapper.setError(getString(R.string.empty_comment_error));
		}
	}

	private boolean shouldRetryRequest()
	{
		return mAdapter.getAdapterItemCount() != 0;
	}

	private void showEmptyListMessage(boolean show)
	{
		lblEmptyListMessage.setVisibility(show ? View.VISIBLE : View.GONE);
	}

	private void showLoadMoreProgress()
	{
		if (!refreshLayout.isRefreshing())
			mAdapter.setShowFooter(true);
	}

	private void showRetry(boolean show)
	{
		layoutRetry.setVisibility(show ? View.VISIBLE : View.GONE);
		layoutList.setVisibility(show ? View.GONE : View.VISIBLE);
	}

	private static class RequestCriteria
	{
		public boolean fullRefresh;
		public boolean loadMore;

		private RequestCriteria()
		{
		}

		public static boolean equals(RequestCriteria a, RequestCriteria b)
		{
			return a == null ? b == null : a.equals(b);
		}

		public static RequestCriteria forLoadMore()
		{
			RequestCriteria result = new RequestCriteria();

			result.loadMore = true;

			return result;
		}

		public static RequestCriteria forRefresh()
		{
			RequestCriteria result = new RequestCriteria();

			result.fullRefresh = true;

			return result;
		}

		@Override
		public boolean equals(Object other)
		{
			if (other == null)
				return false;

			if (other instanceof RequestCriteria)
				return equals((RequestCriteria) other);

			return super.equals(other);
		}

		private boolean equals(RequestCriteria other)
		{
			return other != null && loadMore == other.loadMore && fullRefresh == other.fullRefresh;
		}
	}

}
