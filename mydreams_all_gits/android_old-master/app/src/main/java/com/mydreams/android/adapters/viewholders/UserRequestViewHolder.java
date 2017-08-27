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
import com.mydreams.android.adapters.socialinfo.FriendRequestAdapter;
import com.mydreams.android.utils.Action1;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class UserRequestViewHolder extends BaseViewHolder
{
	private final Action1<UserRequestViewHolder> clickAccept;
	private final Action1<UserRequestViewHolder> clickDelete;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.lblLocation)
	TextView lblLocation;
	@Bind(R.id.imgAvatar)
	SimpleDraweeView imgAvatar;
	private int maxSize;

	public UserRequestViewHolder(Action1<UserRequestViewHolder> clickAccept, Action1<UserRequestViewHolder> clickRemove, @NonNull ViewGroup parent)
	{
		super(R.layout.row_friend_request, parent);

		this.clickAccept = clickAccept;
		this.clickDelete = clickRemove;
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
		setItem((FriendRequestAdapter.FriendRequestModel) item);
	}

	@OnClick(R.id.btnAccept)
	void onClickAccept()
	{
		clickAccept.invoke(this);
	}

	@OnClick(R.id.btnRemove)
	void onClickRemove()
	{
		clickDelete.invoke(this);
	}

	public void setItem(@NonNull FriendRequestAdapter.FriendRequestModel item)
	{
		lblName.setText(item.getFullName() + ", " + item.getAge());
		lblLocation.setText(item.getLocation());

		Uri avatarUrl = item.getAvatarUrl();
		if (avatarUrl != null)
		{
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(item.getAvatarUrl())
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
