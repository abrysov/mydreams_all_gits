package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

public class EndlessScrollListener extends RecyclerView.OnScrollListener
{
	@NonNull
	private final IEndlessListener endlessListener;

	public EndlessScrollListener(@NonNull IEndlessListener endlessListener)
	{
		this.endlessListener = endlessListener;
	}

	@Override
	public void onScrolled(RecyclerView recyclerView, int dx, int dy)
	{
		super.onScrolled(recyclerView, dx, dy);

		RecyclerView.LayoutManager layoutManager = recyclerView.getLayoutManager();

		int visibleItemCount = 0;
		int totalItemCount = 0;
		int lastVisibleItemPosition;
		int firstVisibleItem;

		if (layoutManager instanceof LinearLayoutManager)
		{
			lastVisibleItemPosition = ((LinearLayoutManager) layoutManager).findLastVisibleItemPosition();
			firstVisibleItem = ((LinearLayoutManager) layoutManager).findFirstVisibleItemPosition();

			if (!(layoutManager instanceof GridLayoutManager))
			{
				visibleItemCount = layoutManager.getChildCount();
				totalItemCount = layoutManager.getItemCount();
			}
		}
		else
		{
			throw new RuntimeException("Unsupported LayoutManager used. Valid ones are LinearLayoutManager, GridLayoutManager and StaggeredGridLayoutManager");
		}

		if ((totalItemCount - visibleItemCount) <= firstVisibleItem)
		{
			endlessListener.OnEnd(lastVisibleItemPosition);
		}
	}

	public interface IEndlessListener
	{
		void OnEnd(int maxLastVisiblePosition);
	}
}
