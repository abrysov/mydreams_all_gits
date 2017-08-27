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
import com.mydreams.android.models.Location;

public class LocationAdapter extends ArrayAdapter<Location, LocationAdapter.ViewHolder>
{
	@NonNull
	private final LayoutInflater mInflater;

	@Nullable
	private IOnItemClickListener<Location> mClickListener;

	public LocationAdapter(@NonNull Context context)
	{
		this.mInflater = LayoutInflater.from(context);
	}

	@Override
	public void onBindViewHolder(ViewHolder holder, int position)
	{
		Location item = getItem(position);
		holder.setItem(item);
	}

	@Override
	public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType)
	{
		View view = mInflater.inflate(R.layout.row_simple_list_item_2, parent, false);
		return new ViewHolder(view, this::performClick);
	}

	private void performClick(int position)
	{
		if (mClickListener != null)
		{
			mClickListener.OnClick(getItem(position), position);
		}
	}

	public void setOnItemListener(@Nullable IOnItemClickListener<Location> listener)
	{
		mClickListener = listener;
	}

	static class ViewHolder extends RecyclerView.ViewHolder
	{
		private final TextView mTitle;
		private final TextView mDescription;

		public ViewHolder(View itemView, @Nullable IClickListener clickListener)
		{
			super(itemView);

			if (clickListener != null)
			{
				itemView.setOnClickListener(v -> clickListener.OnClick(getLayoutPosition()));
			}

			mTitle = (TextView) itemView.findViewById(android.R.id.text1);
			mDescription = (TextView) itemView.findViewById(android.R.id.text2);
		}

		public void setItem(@NonNull Location item)
		{
			mTitle.setText(item.getName());
			mDescription.setText(item.getParent());
		}

		public interface IClickListener
		{
			void OnClick(int position);
		}
	}
}
