package com.mydreams.android.adapters;

import android.support.annotation.LayoutRes;
import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public abstract class BaseViewHolder extends RecyclerView.ViewHolder
{
	public BaseViewHolder(@LayoutRes int layoutId, @NonNull ViewGroup parent)
	{
		this(LayoutInflater.from(parent.getContext()).inflate(layoutId, parent, false));

		onFindWidgets();
	}

	protected BaseViewHolder(@NonNull View itemView)
	{
		super(itemView);

		onFindWidgets();
	}

	public void onFindWidgets()
	{
	}

	public abstract void setItem(@NonNull Object item);
}
