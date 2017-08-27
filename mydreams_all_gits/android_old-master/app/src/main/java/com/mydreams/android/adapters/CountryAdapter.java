package com.mydreams.android.adapters;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.models.Country;
import com.mydreams.android.utils.Action1;

public class CountryAdapter extends ArrayAdapter<Country, CountryAdapter.ViewHolder>
{
	@NonNull
	private final LayoutInflater mInflater;

	@Nullable
	private Action1<Country> mClickListener;

	public CountryAdapter(@NonNull Context context, @Nullable Action1<Country> listener)
	{
		mClickListener = listener;
		this.mInflater = LayoutInflater.from(context);
	}

	@Override
	public void onBindViewHolder(ViewHolder holder, int position)
	{
		Country item = getItem(position);
		holder.setItem(item);
	}

	@Override
	public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType)
	{
		View view = mInflater.inflate(R.layout.row_simple_list_item_1, parent, false);
		return new ViewHolder(view, this::performClick);
	}

	private void performClick(int position)
	{
		if (mClickListener != null)
		{
			mClickListener.invoke(getItem(position));
		}
	}

	static class ViewHolder extends RecyclerView.ViewHolder
	{
		private final TextView mTitle;

		public ViewHolder(View itemView, @Nullable IClickListener clickListener)
		{
			super(itemView);

			if (clickListener != null)
			{
				itemView.setOnClickListener(v -> clickListener.OnClick(getLayoutPosition()));
			}

			mTitle = (TextView) itemView.findViewById(android.R.id.text1);
		}

		public void setItem(@NonNull Country item)
		{
			mTitle.setText(item.getName());
		}

		public interface IClickListener
		{
			void OnClick(int position);
		}
	}
}
