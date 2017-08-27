package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.models.PostInfo;
import com.mydreams.android.utils.Action1;

import java.text.SimpleDateFormat;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PostInfoViewHolder extends BaseViewHolder
{
	private final SimpleDateFormat dateFormat;
	private final int maxDreamPhoto;
	private final Action1<PostInfoViewHolder> clickCommentAction;
	private final Action1<PostInfoViewHolder> clickAction;
	@Bind(R.id.imgMainPhoto)
	SimpleDraweeView imgMainPhoto;
	@Bind(R.id.lblName)
	TextView lblName;
	@Bind(R.id.lblDate)
	TextView lblDate;
	@Bind(R.id.lblDesc)
	TextView lblDesc;
	@Bind(R.id.lblLikeCount)
	TextView lblLikeCount;
	@Bind(R.id.lblCommentCount)
	TextView lblCommentCount;

	public PostInfoViewHolder(@NonNull ViewGroup parent, @NonNull Action1<PostInfoViewHolder> clickAction, @NonNull Action1<PostInfoViewHolder> clickCommentAction)
	{
		super(R.layout.row_post_info, parent);
		this.clickAction = clickAction;
		this.clickCommentAction = clickCommentAction;
		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
		maxDreamPhoto = parent.getContext().getResources().getInteger(R.integer.max_dream_photo_size);
	}

	@Override
	public void onFindWidgets()
	{
		super.onFindWidgets();

		ButterKnife.bind(this, itemView);
	}

	@Override
	public void setItem(@NonNull Object item)
	{
		setItem((PostInfo) item);
	}

	@OnClick(R.id.cardView)
	void onClickCardView()
	{
		clickAction.invoke(this);
	}

	@OnClick(R.id.lblCommentCount)
	void onClickComment()
	{
		clickCommentAction.invoke(this);
	}

	public void setItem(@NonNull PostInfo item)
	{
		String avatarUrlStr = item.getFullImageUrl();
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

		lblName.setText(item.getTitle());
		lblDate.setText(dateFormat.format(item.getAddDate()));
		lblDesc.setText(item.getDescription());
		lblLikeCount.setText(String.format("%d", item.getLikeCount()));
		lblCommentCount.setText(String.format("%d", item.getCommentCount()));
	}
}
