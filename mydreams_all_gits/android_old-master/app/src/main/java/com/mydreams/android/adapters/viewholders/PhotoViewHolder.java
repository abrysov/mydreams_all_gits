package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.fragments.PhotosFragment;
import com.mydreams.android.utils.Action1;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PhotoViewHolder extends RecyclerView.ViewHolder
{
	private final int maxPhotoSize;
	@Bind(R.id.imgPhoto)
	SimpleDraweeView imgPhoto;

	@Bind(R.id.deleteLayout)
	View deleteLayout;

	private Action1<Integer> photoClick;

	public PhotoViewHolder(ViewGroup parent, Action1<Integer> photoClick)
	{
		super(LayoutInflater.from(parent.getContext()).inflate(R.layout.row_photo, parent, false));
		this.photoClick = photoClick;

		ButterKnife.bind(this, itemView);

		maxPhotoSize = parent.getContext().getResources().getDimensionPixelSize(R.dimen.thumb_photo_size);
	}

	@OnClick(R.id.mainLayout)
	void onClickMainLayout()
	{
		photoClick.invoke(getAdapterPosition());
	}

	public void setItem(PhotosFragment.PhotoModel item)
	{
		String url = item.getFullThumbUrl();
		if (url != null)
		{
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.parse(url))
					.setResizeOptions(new ResizeOptions(maxPhotoSize, maxPhotoSize))
					.setAutoRotateEnabled(true)
					.build();

			AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
					.setImageRequest(request)
					.setOldController(imgPhoto.getController())
					.build();

			imgPhoto.setController(controller);
		}
		else
		{
			imgPhoto.setImageURI(null);
		}

		deleteLayout.setVisibility(item.isForDelete() ? View.VISIBLE : View.GONE);
	}
}
