package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.models.Photo;
import com.mydreams.android.models.UserActivity;
import com.mydreams.android.utils.Action1;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PhotoActivityViewHolder extends BaseViewHolder
{
	private final Action1<Integer> mClickUser;
	private final Action1<Integer> mClickPhotoActivity;
	private final SimpleDateFormat dateFormat;
	@Bind(R.id.imgAvatar)
	SimpleDraweeView imgAvatar;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.lblDate)
	TextView lblDate;

	@Bind(R.id.lblText)
	TextView lblText;

	@Bind(R.id.imgPhoto1)
	SimpleDraweeView imgPhoto1;
	@Bind(R.id.imgPhoto2)
	SimpleDraweeView imgPhoto2;
	@Bind(R.id.imgPhoto3)
	SimpleDraweeView imgPhoto3;
	@Bind(R.id.imgPhoto4)
	SimpleDraweeView imgPhoto4;

	public PhotoActivityViewHolder(final ViewGroup parent, final Action1<Integer> clickUser, final Action1<Integer> clickPhotoActivity)
	{
		super(R.layout.row_photo_activity, parent);
		mClickUser = clickUser;
		mClickPhotoActivity = clickPhotoActivity;
		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
	}

	private static void setUrl(@NonNull final SimpleDraweeView imgView, @Nullable final String url)
	{
		if (url != null)
		{
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.parse(url))
					.setAutoRotateEnabled(true)
					.build();

			AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
					.setImageRequest(request)
					.setOldController(imgView.getController())
					.build();

			imgView.setController(controller);
			imgView.setVisibility(View.VISIBLE);
		}
		else
		{
			imgView.setImageURI(null);
			imgView.setVisibility(View.GONE);
		}
	}

	@Override
	public void onFindWidgets()
	{
		super.onFindWidgets();
		ButterKnife.bind(this, itemView);
	}

	@Override
	public void setItem(@NonNull final Object item)
	{
		setItem((UserActivity) item);
	}

	@OnClick(R.id.photoContainer)
	void clickPhotoContainer()
	{
		mClickPhotoActivity.invoke(getAdapterPosition());
	}

	@OnClick(R.id.userContainer)
	void clickUserContainer()
	{
		mClickUser.invoke(getAdapterPosition());
	}

	private void setItem(@NonNull final UserActivity item)
	{
		setUrl(imgAvatar, item.getUser().getFullAvatarUrl());

		setUrl(imgPhoto1, null);
		setUrl(imgPhoto2, null);
		setUrl(imgPhoto3, null);
		setUrl(imgPhoto4, null);

		List<Photo> photos = item.getPhotos();
		if (photos != null && !photos.isEmpty())
		{
			int size = photos.size();
			switch (size)
			{
				default:
				case 4:
					setUrl(imgPhoto4, photos.get(3).getFullThumbUrl());
				case 3:
					setUrl(imgPhoto3, photos.get(2).getFullThumbUrl());
				case 2:
					setUrl(imgPhoto2, photos.get(1).getFullThumbUrl());
				case 1:
					setUrl(imgPhoto1, photos.get(0).getFullThumbUrl());
					break;
			}
		}

		lblName.setText(String.format("%s, %s", item.getUser().getFullName(), item.getUser().getAge()));
		lblDate.setText(dateFormat.format(item.getDate().getTime()));
		lblText.setText(item.getText());
	}
}
