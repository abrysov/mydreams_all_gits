package com.mydreams.android.adapters.dreaminfo;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.BaseViewHolder;
import com.mydreams.android.adapters.DifferentViewAdapter;
import com.mydreams.android.adapters.viewholders.DreamLaunchViewHolder;
import com.mydreams.android.models.Launch;
import com.mydreams.android.utils.Action1;

public class DreamLaunchAdapter extends DifferentViewAdapter<DreamLaunchAdapter.ViewType>
{
	private Action1<Integer> clickAction;

	public DreamLaunchAdapter(Action1<Integer> clickAction)
	{
		this.clickAction = clickAction;
		addBinder(new DreamLaunchBinder(this::handleClick));
	}

	private void handleClick(int position)
	{
		clickAction.invoke(position);
	}

	enum ViewType
	{
		Launch
	}

	public static class LaunchModel
	{
		private Launch launch;

		public LaunchModel(Launch launch)
		{
			this.launch = launch;
		}

		public Launch getLaunch()
		{
			return launch;
		}
	}

	public static class DreamLaunchBinder extends Binder<DreamLaunchAdapter.ViewType>
	{
		private Action1<Integer> clickAction;

		public DreamLaunchBinder(Action1<Integer> clickAction)
		{
			super(ViewType.Launch);
			this.clickAction = clickAction;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			return item instanceof LaunchModel;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamLaunchViewHolder(parent, this::handleClick);
		}

		private void handleClick(DreamLaunchViewHolder viewHolder)
		{
			clickAction.invoke(viewHolder.getAdapterPosition());
		}
	}
}
