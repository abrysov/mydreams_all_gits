package com.mydreams.android.adapters.viewholders;

import android.net.Uri;
import android.support.annotation.NonNull;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.utils.Action1;

import org.apache.commons.lang3.StringUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class SearchUserViewHolder extends BaseViewHolder
{
	@Bind(R.id.lblName)
	TextView lblName;
	@Bind(R.id.lblLocation)
	TextView lblLocation;
	@Bind(R.id.imgAvatar)
	com.facebook.drawee.view.SimpleDraweeView imgAvatar;
	@Bind(R.id.lblVIP)
	View lblVIP;

	private Action1<SearchUserViewHolder> clickAction;

	public SearchUserViewHolder(Action1<SearchUserViewHolder> clickAction, @NonNull ViewGroup parent)
	{
		super(R.layout.row_search_user, parent);
		this.clickAction = clickAction;
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
		setItem((UserInfo) item);
	}

	@OnClick(R.id.mainContainer)
	void onClick()
	{
		clickAction.invoke(this);
	}

	private void setItem(@NonNull UserInfo item)
	{
		lblName.setText(String.format("%s, %s", item.getFullName(), item.getAge()));
		lblLocation.setText(StringUtils.defaultString(item.getLocation()));
		lblVIP.setVisibility(item.isVip() ? View.VISIBLE : View.GONE);

		if (item.getFullAvatarUrl() != null)
		{
			imgAvatar.setImageURI(Uri.parse(item.getFullAvatarUrl()));
		}
		else
		{
			imgAvatar.setImageURI(null);
		}
	}
}
