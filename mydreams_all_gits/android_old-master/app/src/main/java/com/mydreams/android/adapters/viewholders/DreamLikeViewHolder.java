package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.widget.TextView;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.dreaminfo.DreamLikeAdapter;
import com.mydreams.android.models.Like;
import com.mydreams.android.utils.Action1;

import java.text.SimpleDateFormat;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamLikeViewHolder extends BaseViewHolder
{
	private final SimpleDateFormat dateFormat;
	@Bind(R.id.imgAvatar)
	SimpleDraweeView imgAvatar;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.lblDate)
	TextView lblDate;

	private Action1<DreamLikeViewHolder> clickAction;

	public DreamLikeViewHolder(@NonNull ViewGroup parent, @NonNull Action1<DreamLikeViewHolder> clickAction)
	{
		super(R.layout.row_dream_like, parent);
		this.clickAction = clickAction;
		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
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
		setItem(((DreamLikeAdapter.LikeModel) item).getLike());
	}

	@OnClick(R.id.cardView)
	void onClickCardView()
	{
		clickAction.invoke(this);
	}

	public void setItem(@NonNull Like item)
	{
		String avatarUrlStr = item.getUser().getFullAvatarUrl();
		if (avatarUrlStr != null)
		{
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(Uri.parse(avatarUrlStr))
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

		lblName.setText(item.getUser().getFullName() + ", " + item.getUser().getAge());
		lblDate.setText(dateFormat.format(item.getDate().getTime()));
	}
}
