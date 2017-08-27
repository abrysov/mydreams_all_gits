package com.mydreams.android.adapters.viewholders;

import android.support.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.imagepipeline.common.ResizeOptions;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.socialinfo.SimpleSocialUserInfoAdapter;
import com.mydreams.android.utils.Action1;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SocialUserInfoViewHolder extends BaseViewHolder
{
	@Bind(R.id.lblCapitalLetter)
	TextView lblCapitalLetter;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.imgAvatar)
	com.facebook.drawee.view.SimpleDraweeView imgAvatar;

	private Action1<SocialUserInfoViewHolder> clickAction;
	private int maxSize;

	public SocialUserInfoViewHolder(Action1<SocialUserInfoViewHolder> clickAction, @NonNull ViewGroup parent)
	{
		super(R.layout.row_social_user_info, parent);
		this.clickAction = clickAction;
	}

	@Override
	public void onFindWidgets()
	{
		super.onFindWidgets();

		ButterKnife.bind(this, itemView);

		maxSize = itemView.getContext().getResources().getDimensionPixelSize(R.dimen.max_menu_image_size);
	}

	@Override
	public void setItem(@NonNull Object item)
	{
		setItem((SimpleSocialUserInfoAdapter.UserInfoModel) item);
	}

	@OnClick(R.id.mainContainer)
	void onClick()
	{
		clickAction.invoke(this);
	}

	private void setItem(@NonNull SimpleSocialUserInfoAdapter.UserInfoModel item)
	{
		lblCapitalLetter.setVisibility(item.showCapitalLetter ? View.VISIBLE : View.INVISIBLE);
		lblCapitalLetter.setText(item.capitalLetter);

		lblName.setText(item.name);

		if (item.avatar != null)
		{
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(item.avatar)
					.setResizeOptions(new ResizeOptions(maxSize, maxSize))
					.setAutoRotateEnabled(true)
					.build();

			AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
					.setImageRequest(request)
					.setOldController(imgAvatar.getController())
					.build();

			imgAvatar.setController(controller);
		}
		else
		{
			imgAvatar.setImageURI(null);
		}
	}
}
