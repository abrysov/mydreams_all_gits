package com.mydreams.android.adapters.viewholders;

import android.support.annotation.NonNull;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.utils.Action1;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class DreamProposedViewHolder extends BaseViewHolder
{
	@NonNull
	private final Action1<DreamProposedViewHolder> clickAction;
	@NonNull
	private final Action1<DreamProposedViewHolder> clickClose;
	@Bind(R.id.lblProposed)
	TextView lblProposed;

	public DreamProposedViewHolder(@NonNull ViewGroup parent, @NonNull Action1<DreamProposedViewHolder> clickAction, @NonNull Action1<DreamProposedViewHolder> clickClose)
	{
		super(R.layout.row_dream_proposed, parent);
		this.clickAction = clickAction;
		this.clickClose = clickClose;
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
		setItem((Integer) item);
	}

	@OnClick(R.id.cardView)
	void onClickCardView()
	{
		clickAction.invoke(this);
	}

	@OnClick(R.id.btnClose)
	void onClickClose()
	{
		clickClose.invoke(this);
	}

	public void setItem(@NonNull Integer item)
	{
		lblProposed.setText(getDreamTitle(item));
	}

	private String getDreamTitle(int dreamCount)
	{
		switch (dreamCount)
		{
			case 0:
				return " " + itemView.getContext().getString(R.string.dream_count_format_caps_0, dreamCount);

			case 1:
				return " " + itemView.getContext().getString(R.string.dream_count_format_caps_1, dreamCount);

			case 2:
			case 3:
			case 4:
				return " " + itemView.getContext().getString(R.string.dream_count_format_caps_2_4, dreamCount);

			default:
				return " " + itemView.getContext().getString(R.string.dream_count_format_caps_5, dreamCount);
		}
	}
}
