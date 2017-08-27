package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.support.v7.widget.RecyclerView;

import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.annimon.stream.function.Predicate;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.ListIterator;

public abstract class ArrayAdapter<TItem, TViewHolder extends RecyclerView.ViewHolder> extends RecyclerView.Adapter<TViewHolder>
{
	@NonNull
	private final List<TItem> mItems = new ArrayList<>();

	protected ArrayAdapter()
	{
		setHasStableIds(false);
	}

	@Override
	public int getItemCount()
	{
		return mItems.size();
	}

	public void add(@NonNull TItem item)
	{
		mItems.add(item);
		notifyItemInserted(mItems.size() - 1);
	}

	public void addAll(@NonNull Collection<? extends TItem> items)
	{
		int oldSize = mItems.size();

		mItems.addAll(items);
		notifyItemRangeInserted(oldSize - 1, items.size());
	}

	public void clear()
	{
		int oldSize = mItems.size();

		mItems.clear();
		notifyDataSetChanged();
	}

	@NonNull
	public TItem getItem(int position)
	{
		return mItems.get(position);
	}

	public void insert(int position, @NonNull TItem item)
	{
		mItems.add(position, item);
		notifyItemInserted(position);
	}

	@NonNull
	public void remove(@NonNull Predicate<? super TItem> predicate)
	{
		int index = 0;
		ListIterator<TItem> iterator = mItems.listIterator();
		while (iterator.hasNext())
		{
			TItem item = iterator.next();
			if (predicate.test(item))
			{
				iterator.remove();
			}

			index++;
		}

		notifyDataSetChanged();
	}

	public void remove(@NonNull int position)
	{
		mItems.remove(position);
		notifyItemRemoved(position);
	}

	public void remove(@NonNull TItem item)
	{
		remove(x -> x == item);
	}

	public void replace(int position, @NonNull TItem item)
	{
		mItems.set(position, item);
		notifyItemChanged(position);
	}

	@NonNull
	public List<TItem> getItems()
	{
		return Stream.of(mItems).collect(Collectors.toList());
	}

	public boolean isEmpty()
	{
		return mItems.isEmpty();
	}
}
