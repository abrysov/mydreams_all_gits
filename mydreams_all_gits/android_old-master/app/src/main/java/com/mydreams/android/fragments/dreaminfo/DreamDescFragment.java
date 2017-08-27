package com.mydreams.android.fragments.dreaminfo;

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
import com.mydreams.android.fragments.DreamInfoFragment;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.service.response.GetDreamResponse;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.text.SimpleDateFormat;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamDescFragment extends BaseFragment
{
	private static final String DREAM_INFO_EXTRA_NAME = "DREAM_INFO_EXTRA_NAME";
	private static final String WITHOUT_GIVE_MARK_EXTRA_NAME = "WITHOUT_GIVE_MARK_EXTRA_NAME";
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
	@Bind(R.id.btnGiveMark)
	View btnGiveMark;
	@Nullable
	private Dream dream;
	private UserPreference userPreferneces;
	private int maxDreamPhoto;
	private SimpleDateFormat dateFormat;

	public static Fragment getInstance(@NonNull DreamInfo item, boolean withoutGiveMark, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(DREAM_INFO_EXTRA_NAME, Parcels.wrap(item));
		args.putBoolean(WITHOUT_GIVE_MARK_EXTRA_NAME, withoutGiveMark);

		if (theme == null)
			theme = R.style.AppTheme;
		setThemeIdInArgs(args, theme);

		Fragment result = new DreamDescFragment();
		result.setArguments(args);
		return result;
	}

	@Nullable
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		userPreferneces = new UserPreference(getActivity());

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_dream_desc, container, false);
		ButterKnife.bind(this, result);

		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
		maxDreamPhoto = getContext().getResources().getInteger(R.integer.max_dream_photo_size);

		boolean withoutGiveMark = getArguments().getBoolean(WITHOUT_GIVE_MARK_EXTRA_NAME);
		btnGiveMark.setVisibility(withoutGiveMark ? View.GONE : View.VISIBLE);

		return result;
	}

	@Override
	public void onResume()
	{
		super.onResume();

		updateDream();
		/*if (dream == null)
		{
			updateDream();
		}
		else
		{
			showCard();
		}*/
	}

	@OnClick(R.id.btnGiveMark)
	void onClickGiveMark()
	{
		showToast("Скоро, совсем скоро...");
	}

	@OnClick(R.id.fabLike)
	void onClickLike()
	{
		if (dream != null && !dream.isLiked())
		{
			DialogInterface dialog = showProgressDialog(R.string.like_dream_dialog_title, R.string.please_wait);

			BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.likeDream(getDreamInfo().getId());
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
						showToast(R.string.like_dream_success);
						fabLike.setVisibility(View.INVISIBLE);
						dream.setIsLiked(true);
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.like_dream_error_message);
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
		updateDream();
	}

	private DreamInfo getDreamInfo()
	{
		return Parcels.unwrap(getArguments().getParcelable(DREAM_INFO_EXTRA_NAME));
	}

	private void showCard()
	{
		dreamLayout.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);

		if (dream != null)
		{
			boolean showLike = dream.getOwner() == null
					|| userPreferneces.getUser() == null
					|| (dream.getOwner().getId() != userPreferneces.getUser().getId() && !dream.isLiked());
			fabLike.setVisibility(showLike ? View.VISIBLE : View.INVISIBLE);

			String avatarUrlStr = dream.getFullImageUrl();
			if (avatarUrlStr != null)
			{
				ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.parse(avatarUrlStr))
						.setResizeOptions(new ResizeOptions(maxDreamPhoto, maxDreamPhoto))
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

			lblName.setText(dream.getName());
			lblDate.setText(dateFormat.format(dream.getAddDate()));
			lblDesc.setText(dream.getDescription());
		}
		else
		{
			fabLike.setVisibility(View.INVISIBLE);
			updateDream();
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

	private void updateDream()
	{
		showProgress();

		BaseSpiceRequest<GetDreamResponse> requset = RequestFactory.getDream(getDreamInfo().getId());
		getSpiceManager().execute(requset, new RequestListener<GetDreamResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				showRetry();
			}

			@Override
			public void onRequestSuccess(GetDreamResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					dream = new Dream(response.getDream());

					Fragment fragment = getParentFragment();
					if (fragment != null && fragment instanceof DreamInfoFragment)
					{
						DreamInfoFragment dreamInfoFragment = (DreamInfoFragment) fragment;
						dreamInfoFragment.setDream(dream);
					}

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
