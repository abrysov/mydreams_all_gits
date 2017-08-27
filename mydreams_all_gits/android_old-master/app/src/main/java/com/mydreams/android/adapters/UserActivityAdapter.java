package com.mydreams.android.adapters;

import android.support.annotation.NonNull;
import android.view.ViewGroup;

import com.mydreams.android.adapters.viewholders.DreamActivityViewHolder;
import com.mydreams.android.adapters.viewholders.PhotoActivityViewHolder;
import com.mydreams.android.adapters.viewholders.SimpleActivityViewHolder;
import com.mydreams.android.models.UserActivity;
import com.mydreams.android.utils.Action1;

public class UserActivityAdapter extends DifferentViewAdapter<UserActivityAdapter.ViewType>
{
	private final Action1<UserActivity> mClickUser;
	private final Action1<UserActivity> mClickDreamActivity;
	private final Action1<UserActivity> mClickPhotoActivity;

	public UserActivityAdapter(@NonNull Action1<UserActivity> clickUser, Action1<UserActivity> clickDreamActivity, Action1<UserActivity> clickPhotoActivity)
	{
		mClickUser = clickUser;
		mClickDreamActivity = clickDreamActivity;
		mClickPhotoActivity = clickPhotoActivity;

		addBinder(new SimpleActivityBinder(this::handleClickUser));
		addBinder(new PhotoActivityBinder(this::handleClickUser, this::handleClickPhotoActivity));
		addBinder(new DreamActivityBinder(this::handleClickUser, this::handleClickDreamActivity));
	}

	private void handleClickDreamActivity(int position)
	{
		mClickDreamActivity.invoke((UserActivity) getItem(position));
	}

	private void handleClickPhotoActivity(int position)
	{
		mClickPhotoActivity.invoke((UserActivity) getItem(position));
	}

	private void handleClickUser(int position)
	{
		mClickUser.invoke((UserActivity) getItem(position));
	}

	enum ViewType
	{
		SimpleActivity, PhotoActivity, DreamActivity
	}

	public static class SimpleActivityBinder extends Binder<UserActivityAdapter.ViewType>
	{
		private Action1<Integer> mClickUser;

		public SimpleActivityBinder(Action1<Integer> clickUser)
		{
			super(ViewType.SimpleActivity);
			mClickUser = clickUser;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			if (item instanceof UserActivity)
			{
				UserActivity activity = (UserActivity) item;
				return activity.isSimpleActivity();
			}

			return false;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new SimpleActivityViewHolder(parent, mClickUser);
		}
	}

	public static class PhotoActivityBinder extends Binder<UserActivityAdapter.ViewType>
	{
		private final Action1<Integer> mClickPhotoActivity;
		private Action1<Integer> mClickUser;

		public PhotoActivityBinder(Action1<Integer> clickUser, Action1<Integer> clickPhotoActivity)
		{
			super(ViewType.PhotoActivity);
			mClickUser = clickUser;
			mClickPhotoActivity = clickPhotoActivity;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			if (item instanceof UserActivity)
			{
				UserActivity activity = (UserActivity) item;
				return activity.isPhotoActivity();
			}

			return false;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new PhotoActivityViewHolder(parent, mClickUser, mClickPhotoActivity);
		}
	}

	public static class DreamActivityBinder extends Binder<UserActivityAdapter.ViewType>
	{
		private final Action1<Integer> mClickDreamActivity;
		private Action1<Integer> mClickUser;

		public DreamActivityBinder(Action1<Integer> clickUser, Action1<Integer> clickDreamActivity)
		{
			super(ViewType.DreamActivity);
			mClickUser = clickUser;
			mClickDreamActivity = clickDreamActivity;
		}

		@Override
		public boolean canHandle(@NonNull Object item)
		{
			if (item instanceof UserActivity)
			{
				UserActivity activity = (UserActivity) item;
				return activity.isDreamActivity();
			}

			return false;
		}

		@NonNull
		@Override
		public BaseViewHolder createViewHolder(@NonNull ViewGroup parent)
		{
			return new DreamActivityViewHolder(parent, mClickUser, mClickDreamActivity);
		}
	}
}
