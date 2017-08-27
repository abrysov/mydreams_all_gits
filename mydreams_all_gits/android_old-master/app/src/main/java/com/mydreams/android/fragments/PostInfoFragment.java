package com.mydreams.android.fragments;

import android.content.Context;
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
import com.mydreams.android.fragments.postinfo.PostCommentsFragment;
import com.mydreams.android.fragments.postinfo.PostDescFragment;
import com.mydreams.android.models.PostInfo;
import com.mydreams.android.utils.ActivityUtils;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.TabPageIndicator;

import org.parceler.Parcels;

import butterknife.Bind;
import butterknife.ButterKnife;

public class PostInfoFragment extends BaseFragment
{
	private static final String POST_INFO_EXTRA_NAME = "POST_INFO_EXTRA_NAME";
	private static final String SHOW_COMMENT_EXTRA_NAME = "SHOW_COMMENT_EXTRA_NAME";
	@Bind(R.id.tabPageIndicator)
	TabPageIndicator mTabPageIndicator;
	@Bind(R.id.viewPager)
	ViewPager mViewPager;
	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	private PagerAdapter mPagerAdapter;
	private PostInfo postInfo;

	public static Fragment getInstance(@NonNull PostInfo item, boolean showComment, @Nullable @StyleRes Integer theme)
	{
		Bundle args = new Bundle();
		args.putParcelable(POST_INFO_EXTRA_NAME, Parcels.wrap(item));
		args.putBoolean(SHOW_COMMENT_EXTRA_NAME, showComment);

		if(theme == null)
			theme = R.style.AppTheme;
		setThemeIdInArgs(args, theme);

		Fragment result = new PostInfoFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.post_info_menu, menu);
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
		toolbar.setTitle(getPostInfo().getTitle());
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		mPagerAdapter = new PagerAdapter(getActivity(), getChildFragmentManager(), getPostInfo(), getThemeIdFromArgs());
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

		return result;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case R.id.logout:
				getMainActivity().goToSignIn();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
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

	private PostInfo getPostInfo()
	{
		if (postInfo == null)
		{
			postInfo = Parcels.unwrap(getArguments().getParcelable(POST_INFO_EXTRA_NAME));
		}

		return postInfo;
	}

	private enum Tab
	{
		Desc,
		Comments
	}

	private static class PagerAdapter extends FragmentStatePagerAdapter
	{
		private Context context;
		private PostInfo postInfo;
		private int comments;
		@StyleRes
		private Integer mTheme;

		public PagerAdapter(@NonNull Context context, @NonNull FragmentManager fm, @NonNull PostInfo postInfo, @StyleRes final Integer theme)
		{
			super(fm);
			this.context = context;
			this.postInfo = postInfo;
			mTheme = theme;
			comments = postInfo.getCommentCount();
		}

		@Override
		public int getCount()
		{
			return Tab.values().length;
		}

		@Override
		public Fragment getItem(int position)
		{
			switch (Tab.values()[position])
			{
				case Desc:
					return PostDescFragment.getInstance(postInfo, mTheme);
				case Comments:
					return PostCommentsFragment.getInstance(postInfo, mTheme);
				default:
					throw new IndexOutOfBoundsException();
			}
		}

		@Override
		public CharSequence getPageTitle(int position)
		{
			switch (Tab.values()[position])
			{
				case Desc:
					return context.getString(R.string.desc_caps);
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
	}
}
