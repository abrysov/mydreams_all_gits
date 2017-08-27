package com.mydreams.android.fragments;

import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.dreaminfo.DreamCommentsFragment;
import com.mydreams.android.fragments.dreaminfo.DreamDescFragment;
import com.mydreams.android.fragments.dreaminfo.DreamLaunchFragment;
import com.mydreams.android.fragments.dreaminfo.DreamLikesFragment;
import com.mydreams.android.models.Dream;
import com.mydreams.android.models.DreamInfo;
import com.mydreams.android.models.User;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.TabPageIndicator;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import proguard.annotation.Keep;

public class DreamInfoFragment extends BaseFragment
{
	private static final String DREAM_INFO_EXTRA_NAME = "DREAM_INFO_EXTRA_NAME";
	private static final String SHOW_COMMENT_EXTRA_NAME = "SHOW_COMMENT_EXTRA_NAME";
	private static final String IS_MY_DREAM_EXTRA_NAME = "IS_MY_DREAM_EXTRA_NAME";
	private static final String WITHOUT_GIVE_MARK__EXTRA_NAME = "WITHOUT_GIVE_MARK__EXTRA_NAME";
	@Bind(R.id.tabPageIndicator)
	TabPageIndicator mTabPageIndicator;
	@Bind(R.id.viewPager)
	ViewPager mViewPager;
	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	private PagerAdapter mPagerAdapter;
	private DreamInfo dreamInfo;
	private Boolean hideTakeDreamMenu;
	private Dream dream;

	@Keep
	public static Fragment getInstance(@NonNull DreamInfo item, boolean showComment, @Nullable Boolean isMyDream, Boolean withoutGiveMark, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(DREAM_INFO_EXTRA_NAME, Parcels.wrap(item));
		args.putBoolean(SHOW_COMMENT_EXTRA_NAME, showComment);
		if (isMyDream != null)
			args.putBoolean(IS_MY_DREAM_EXTRA_NAME, isMyDream);
		args.putBoolean(WITHOUT_GIVE_MARK__EXTRA_NAME, withoutGiveMark);

		if (theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		Fragment result = new DreamInfoFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.dream_info_menu, menu);
		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		mUserPreference = new UserPreference(getActivity());

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_dream_info, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(getDreamInfo().getName());
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		boolean withoutGiveMark = getArguments().getBoolean(WITHOUT_GIVE_MARK__EXTRA_NAME);

		mPagerAdapter = new PagerAdapter(getActivity(), getChildFragmentManager(), getDreamInfo(), withoutGiveMark, getThemeIdFromArgs());
		mViewPager.setAdapter(mPagerAdapter);
		mViewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener()
		{
			@Override
			public void onPageScrollStateChanged(final int state)
			{
				getBaseActivity().hideSoftKeyboard();
			}

			@Override
			public void onPageScrolled(final int position, final float positionOffset, final int positionOffsetPixels)
			{

			}

			@Override
			public void onPageSelected(final int position)
			{

			}
		});
		mTabPageIndicator.setViewPager(mViewPager);

		if (getArguments().getBoolean(SHOW_COMMENT_EXTRA_NAME, false))
		{
			mViewPager.setCurrentItem(Tab.Comments.ordinal());
		}
		else
		{
			mViewPager.setCurrentItem(Tab.Desc.ordinal());
		}

		if (getArguments().containsKey(IS_MY_DREAM_EXTRA_NAME))
			hideTakeDreamMenu = getArguments().getBoolean(IS_MY_DREAM_EXTRA_NAME, false);

		return result;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		MainActivity mainActivity = (MainActivity) getActivity();

		switch (item.getItemId())
		{
			case R.id.logout:
				getMainActivity().goToSignIn();
				return true;

			case R.id.take:
			{
				DialogInterface dialog = showProgressDialog(R.string.take_dream_dialog_title, R.string.please_wait);

				BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.takeDream(getDreamInfo().getId());
				getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
				{
					@Override
					public void onRequestFailure(SpiceException spiceException)
					{
						dialog.cancel();

						showToast(R.string.connection_error_message);
					}

					@Override
					public void onRequestSuccess(EmptyResponse response)
					{
						dialog.cancel();

						if (response.getCode() == ResponseStatus.Ok)
						{
							showToast(R.string.take_dream_successe_message);
							hideTakeDreamMenu = true;
							getActivity().invalidateOptionsMenu();
						}
						else
						{
							if (response.getCode() == ResponseStatus.Unauthorized)
							{
								getMainActivity().goToSignIn();
							}
							else
							{
								String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.take_dream_error_message);
								showToast(message);
							}
						}
					}
				});
				return true;
			}

			case R.id.propose:
				ProposeDreamFragment proposeDreamFragment = ProposeDreamFragment.getInstance(getDreamInfo());

				mainActivity.putFragmentWithBackStack(proposeDreamFragment);
				return true;

			case R.id.edit:
				if (dream != null)
				{
					Fragment addDreamFragment = AddDreamFragment.getInstance(dream, R.style.GreenTheme);
					mainActivity.putFragmentWithBackStack(addDreamFragment);
					return true;
				}
				else
				{
					getActivity().invalidateOptionsMenu();
				}

			case R.id.mark_done:
			{
				DialogInterface dialog = showProgressDialog(R.string.mark_dream_done_dialog_title, R.string.please_wait);

				BaseSpiceRequest<EmptyResponse> spiceRequest = RequestFactory.markDone(getDreamInfo().getId(), true);
				getSpiceManager().execute(spiceRequest, new RequestListener<EmptyResponse>()
				{
					@Override
					public void onRequestFailure(SpiceException spiceException)
					{
						dialog.cancel();

						showToast(R.string.connection_error_message);
					}

					@Override
					public void onRequestSuccess(EmptyResponse response)
					{
						dialog.cancel();

						if (response.getCode() == ResponseStatus.Ok)
						{
							showToast(R.string.mark_dream_done_successe_message);

							if (dream != null)
								dream.setIsDone(true);
							getActivity().invalidateOptionsMenu();
						}
						else
						{
							if (response.getCode() == ResponseStatus.Unauthorized)
							{
								getMainActivity().goToSignIn();
							}
							else
							{
								String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.mark_dream_done_error_message);
								showToast(message);
							}
						}
					}
				});
				return true;
			}
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		User user = mUserPreference.getUser();
		boolean isMyDream = dream != null && dream.getOwner() != null && user != null && dream.getOwner().getId() == user.getId();

		MenuItem editItem = menu.findItem(R.id.edit);
		editItem.setVisible(isMyDream);

		MenuItem takeItem = menu.findItem(R.id.take);
		if (hideTakeDreamMenu != null)
		{
			takeItem.setVisible(!hideTakeDreamMenu);
		}
		else if (dream != null)
		{
			takeItem.setVisible(!isMyDream);
		}

		MenuItem markDoneItem = menu.findItem(R.id.mark_done);
		markDoneItem.setVisible(isMyDream && dream != null && !dream.isDone());

		mToolbarManager.onPrepareMenu();
		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);
	}

	public void setComments(int comments)
	{
		mPagerAdapter.setComments(comments);
	}

	public void setDream(Dream dream)
	{
		this.dream = dream;

		if (dream != null)
		{
			User user = mUserPreference.getUser();
			hideTakeDreamMenu = user != null && (dream.getOwner() == null || dream.getOwner().getId() == user.getId());
			getActivity().invalidateOptionsMenu();
		}
		else
		{
			hideTakeDreamMenu = true;
		}

		getActivity().invalidateOptionsMenu();
	}

	public void setLaunches(int launches)
	{
		mPagerAdapter.setLaunches(launches);
	}

	public void setLikes(int likes)
	{
		mPagerAdapter.setLikes(likes);
	}

	private DreamInfo getDreamInfo()
	{
		if (dreamInfo == null)
		{
			dreamInfo = Parcels.unwrap(getArguments().getParcelable(DREAM_INFO_EXTRA_NAME));
		}

		return dreamInfo;
	}

	private enum Tab
	{
		Desc,
		Comments,
		Launches,
		Likes
	}

	private static class PagerAdapter extends FragmentStatePagerAdapter
	{
		private Context context;
		private DreamInfo dreamInfo;
		private int likes;
		private int launches;
		private int comments;
		private Tab[] tabs;
		private boolean mWithoutGiveMark;
		@StyleRes
		private Integer mTheme;


		public PagerAdapter(@NonNull Context context, @NonNull FragmentManager fm, @NonNull DreamInfo dreamInfo, final boolean withoutGiveMark, @StyleRes final Integer theme)
		{
			super(fm);
			this.context = context;
			this.dreamInfo = dreamInfo;
			mWithoutGiveMark = withoutGiveMark;
			mTheme = theme;
			likes = dreamInfo.getLikeCount();
			launches = dreamInfo.getLaunchesCount();
			comments = dreamInfo.getCommentCount();
			updateTabs();
		}

		@Override
		public int getCount()
		{
			int exclude = 0;
			if (likes == 0)
				exclude++;
			if (launches == 0)
				exclude++;

			return Tab.values().length - exclude;
		}

		@Override
		public Fragment getItem(int position)
		{
			switch (tabs[position])
			{
				case Desc:
					return DreamDescFragment.getInstance(dreamInfo, mWithoutGiveMark, mTheme);
				case Comments:
					return DreamCommentsFragment.getInstance(dreamInfo, mTheme);
				case Likes:
					return DreamLikesFragment.getInstance(dreamInfo, mTheme);
				case Launches:
					return DreamLaunchFragment.getInstance(dreamInfo, mTheme);
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		@Override
		public CharSequence getPageTitle(int position)
		{
			switch (tabs[position])
			{
				case Desc:
					return context.getString(R.string.desc_caps);
				case Likes:
					return getLikeTitle();
				case Launches:
					return getLaunchTitle();
				case Comments:
					return getCommentTitle();
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		public void setComments(int comments)
		{
			this.comments = comments;
			notifyDataSetChanged();
			updateTabs();
		}

		public void setLaunches(int launches)
		{
			this.launches = launches;
			notifyDataSetChanged();
			updateTabs();
		}

		public void setLikes(int likes)
		{
			this.likes = likes;
			notifyDataSetChanged();
			updateTabs();
		}

		@NonNull
		private String getCommentTitle()
		{
			if (comments == 0)
			{
				return context.getString(R.string.comment_caps);
			}
			else
			{
				switch (comments)
				{
					case 1:
						return context.getString(R.string.comment_count_format_caps_1, comments);

					case 2:
					case 3:
					case 4:
						return context.getString(R.string.comment_count_format_caps_2_4, comments);

					default:
						return context.getString(R.string.comment_count_format_caps_5, comments);
				}
			}
		}

		@NonNull
		private String getLaunchTitle()
		{
			switch (launches)
			{
				case 0:
					return context.getString(R.string.launches_count_format_caps_0, launches);

				case 1:
					return context.getString(R.string.launches_count_format_caps_1, launches);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.launches_count_format_caps_2_4, launches);

				default:
					return context.getString(R.string.launches_count_format_caps_5, launches);
			}
		}

		@NonNull
		private String getLikeTitle()
		{
			switch (likes)
			{
				case 0:
					return context.getString(R.string.likes_count_format_caps_0, likes);

				case 1:
					return context.getString(R.string.likes_count_format_caps_1, likes);

				case 2:
				case 3:
				case 4:
					return context.getString(R.string.likes_count_format_caps_2_4, likes);

				default:
					return context.getString(R.string.likes_count_format_caps_5, likes);
			}
		}

		private void updateTabs()
		{
			List<Tab> list = new ArrayList<>();
			list.add(Tab.Desc);
			list.add(Tab.Comments);
			if (launches != 0)
				list.add(Tab.Launches);
			if (likes != 0)
				list.add(Tab.Likes);

			tabs = new Tab[list.size()];
			list.toArray(tabs);
		}
	}
}
