package com.mydreams.android.fragments.postinfo;

import android.content.DialogInterface;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.Post;
import com.mydreams.android.models.PostInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.GetPostResponse;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.text.SimpleDateFormat;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PostDescFragment extends BaseFragment
{
	private static final String POST_INFO_EXTRA_NAME = "POST_INFO_EXTRA_NAME";
	@Bind(R.id.lblName)
	TextView lblName;
	@Bind(R.id.lblDesc)
	TextView lblDesc;
	@Bind(R.id.lblDate)
	TextView lblDate;
	@Bind(R.id.imgMainPhoto)
	SimpleDraweeView imgMainPhoto;
	@Bind(R.id.dreamLayout)
	View dreamLayout;
	@Bind(R.id.progressBar)
	View progressBar;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.fabLike)
	View fabLike;
	@Nullable
	private Post post;
	private UserPreference userPreferneces;
	private int maxPostPhoto;
	private SimpleDateFormat dateFormat;

	public static Fragment getInstance(@NonNull PostInfo item, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(POST_INFO_EXTRA_NAME, Parcels.wrap(item));

		if (theme == null)
			theme = R.style.AppTheme;
		setThemeIdInArgs(args, theme);

		Fragment result = new PostDescFragment();
		result.setArguments(args);
		return result;
	}

	@Nullable
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		userPreferneces = new UserPreference(getActivity());

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_post_desc, container, false);
		ButterKnife.bind(this, result);

		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
		maxPostPhoto = getContext().getResources().getInteger(R.integer.max_post_photo_size);

		return result;
	}

	@Override
	public void onResume()
	{
		super.onResume();

		if (post == null)
		{
			updatePost();
		}
		else
		{
			showCard();
		}
	}

	@OnClick(R.id.fabLike)
	void onClickLike()
	{
		if (post != null && !post.isLiked())
		{
			DialogInterface dialog = showProgressDialog(R.string.like_post_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.likePost(getPostInfo().getId());
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
						showToast(R.string.like_post_success);
						fabLike.setVisibility(View.INVISIBLE);
						post.setLiked(true);
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.like_post_error_message);
							showToast(message);
						}
					}
				}
			});
		}
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		updatePost();
	}

	private PostInfo getPostInfo()
	{
		return Parcels.unwrap(getArguments().getParcelable(POST_INFO_EXTRA_NAME));
	}

	private void showCard()
	{
		dreamLayout.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);

		if (post != null)
		{
			boolean showLike = post.getOwner() == null
					|| userPreferneces.getUser() == null
					|| (post.getOwner().getId() != userPreferneces.getUser().getId() && !post.isLiked());
			fabLike.setVisibility(showLike ? View.VISIBLE : View.INVISIBLE);

			String avatarUrlStr = post.getFullImageUrl();
			if (avatarUrlStr != null)
			{
				ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.parse(avatarUrlStr))
						.setResizeOptions(new ResizeOptions(maxPostPhoto, maxPostPhoto))
						.setAutoRotateEnabled(true)
						.build();

				AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
						.setImageRequest(request)
						.setOldController(imgMainPhoto.getController())
						.build();

				imgMainPhoto.setController(controller);
			}
			else
			{
				imgMainPhoto.setImageURI(null);
			}

			lblName.setText(post.getTitle());
			lblDate.setText(dateFormat.format(post.getAddDate()));
			lblDesc.setText(post.getDescription());
		}
		else
		{
			fabLike.setVisibility(View.INVISIBLE);
			updatePost();
		}
	}

	private void showProgress()
	{
		dreamLayout.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
	}

	private void showRetry()
	{
		dreamLayout.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
	}

	private void updatePost()
	{
		showProgress();

		BaseSpiceRequest<GetPostResponse> requset = RequestFactory.getPost(getPostInfo().getId());
		getSpiceManager().execute(requset, new RequestListener<GetPostResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				showRetry();
			}

			@Override
			public void onRequestSuccess(GetPostResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					post = new Post(response.getPost());
					showCard();
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						showRetry();
					}
				}
			}
		});
	}
}
