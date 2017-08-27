package com.mydreams.android.adapters;

import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.PhotoViewHolder;
import com.mydreams.android.fragments.PhotosFragment;
import com.mydreams.android.utils.Action1;

public class PhotoAdapter extends ArrayAdapter<PhotosFragment.PhotoModel, PhotoViewHolder>
{
	private Action1<Integer> photoClick;

	public PhotoAdapter(Action1<Integer> photoClick)
	{
		this.photoClick = photoClick;
	}

	@Override
	public void onBindViewHolder(PhotoViewHolder holder, int position)
	{
		holder.setItem(getItem(position));
	}

	@Override
	public PhotoViewHolder onCreateViewHolder(ViewGroup parent, int viewType)
	{
		return new PhotoViewHolder(parent, photoClick::invoke);
	}
}
