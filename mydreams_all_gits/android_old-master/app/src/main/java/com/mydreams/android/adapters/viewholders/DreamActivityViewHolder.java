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
import com.mydreams.android.models.UserActivity;
import com.mydreams.android.utils.Action1;

import java.text.SimpleDateFormat;
import java.util.Locale;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamActivityViewHolder extends BaseViewHolder
{
	private final SimpleDateFormat dateFormat;
	private final Action1<Integer> mClickUser;
	private final Action1<Integer> mClickDreamActivity;
	@Bind(R.id.imgAvatar)
	SimpleDraweeView imgAvatar;

	@Bind(R.id.lblName)
	TextView lblName;

	@Bind(R.id.lblDate)
	TextView lblDate;

	@Bind(R.id.lblText)
	TextView lblText;

	public DreamActivityViewHolder(final ViewGroup parent, final Action1<Integer> clickUser, final Action1<Integer> clickDreamActivity)
	{
		super(R.layout.row_dream_activity, parent);
		mClickUser = clickUser;
		mClickDreamActivity = clickDreamActivity;
		dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm", Locale.getDefault());
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

	@OnClick(R.id.lblText)
	void clickDreamContainer()
	{
		mClickDreamActivity.invoke(getAdapterPosition());
	}

	@OnClick(R.id.userContainer)
	void clickUserContainer()
	{
		mClickUser.invoke(getAdapterPosition());
	}

	private void setItem(@NonNull final UserActivity item)
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

		lblName.setText(String.format("%s, %s", item.getUser().getFullName(), item.getUser().getAge()));
		lblDate.setText(dateFormat.format(item.getDate().getTime()));
		lblText.setText(item.getText());
	}
}
