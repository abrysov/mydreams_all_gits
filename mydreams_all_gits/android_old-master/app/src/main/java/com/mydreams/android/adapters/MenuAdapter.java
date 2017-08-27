package com.mydreams.android.adapters;

import android.content.Context;
import android.support.annotation.ColorRes;
import android.support.annotation.DrawableRes;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mikepenz.iconics.typeface.IIcon;
import com.mikepenz.iconics.view.IconicsImageView;
import com.mydreams.android.R;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

public class MenuAdapter extends android.widget.ArrayAdapter<MenuAdapter.MenuItem>
{
	public MenuAdapter(final Context context, final List<MenuItem> items)
	{
		super(context, 0, items);
	}

	@Override
	public long getItemId(final int position)
	{
		return getItem(position).id;
	}

	@Override
	public View getView(final int position, final View convertView, final ViewGroup parent)
	{
		View view = convertView;
		if (view == null)
		{
			view = LayoutInflater.from(getContext()).inflate(R.layout.drawer_item, parent, false);
			view.setTag(new ViewHolder(view));
		}

		ViewHolder viewHolder = (ViewHolder) view.getTag();
		viewHolder.setItem(getItem(position));

		return view;
	}

	@Override
	public boolean hasStableIds()
	{
		return true;
	}

	public static class ViewHolder
	{
		@Bind(R.id.iconContainer)
		View iconContainer;

		@Bind(R.id.material_drawer_icon)
		IconicsImageView icon;

		@Bind(R.id.material_drawer_name)
		TextView text;

		public ViewHolder(View view)
		{
			ButterKnife.bind(this, view);
		}

		@SuppressWarnings("deprecation")
		public void setItem(MenuItem item)
		{
			if (item.icon != null)
			{
				icon.setIcon(item.icon);
			}
			else
			{
				icon.setImageResource(item.iconRes);
			}

			iconContainer.setBackgroundColor(iconContainer.getResources().getColor(item.iconBackgroundColorRes));

			text.setText(item.textRes);
			text.setBackgroundResource(item.textBackgroundRes);
		}
	}

	public static class MenuItem
	{
		public final int id;
		@ColorRes
		public final int iconBackgroundColorRes;
		@StringRes
		public final int textRes;
		@DrawableRes
		public final int textBackgroundRes;
		@Nullable
		public IIcon icon;
		@DrawableRes
		private int iconRes;

		public MenuItem(final int id, @NonNull final IIcon icon, @ColorRes final int iconBackgroundColorRes, @StringRes final int textRes, @DrawableRes final int textBackgroundRes)
		{
			this.id = id;
			this.icon = icon;
			this.iconBackgroundColorRes = iconBackgroundColorRes;
			this.textRes = textRes;
			this.textBackgroundRes = textBackgroundRes;
		}

		public MenuItem(final int id, @DrawableRes final int iconRes, @ColorRes final int iconBackgroundColorRes, @StringRes final int textRes, @DrawableRes final int textBackgroundRes)
		{
			this.id = id;
			this.iconRes = iconRes;
			this.iconBackgroundColorRes = iconBackgroundColorRes;
			this.textRes = textRes;
			this.textBackgroundRes = textBackgroundRes;
		}
	}
}
