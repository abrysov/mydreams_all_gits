package com.mydreams.android.utils;

import android.animation.ObjectAnimator;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.DrawableRes;
import android.support.annotation.StringRes;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.mydreams.android.R;

import butterknife.Bind;
import butterknife.ButterKnife;

public class AppTourController
{
	static final int NUM_PAGES = 4;
	private final FragmentActivity mFragmentActivity;
	private final Runnable mEndTour;
	@Bind(R.id.viewPager)
	ViewPager viewPager;
	@Bind(R.id.lblOne)
	TextView lblOne;
	@Bind(R.id.lblTwo)
	TextView lblTwo;
	@Bind(R.id.lblThree)
	TextView lblThree;
	PagerAdapter pagerAdapter;
	boolean isOpaque = true;
	private View mView;

	public AppTourController(FragmentActivity fragmentActivity, View view, Runnable endTour)
	{
		mFragmentActivity = fragmentActivity;
		mView = view;
		mEndTour = endTour;
		ButterKnife.bind(this, view);

		pagerAdapter = new ScreenSlidePagerAdapter(fragmentActivity.getSupportFragmentManager());
		viewPager.setAdapter(pagerAdapter);
		viewPager.setPageTransformer(true, new CrossfadePageTransformer());
		viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener()
		{
			@Override
			public void onPageScrollStateChanged(int state)
			{

			}

			@Override
			public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels)
			{
				if (position == NUM_PAGES - 2 && positionOffset > 0)
				{
					if (isOpaque)
					{
						mView.setBackgroundColor(Color.TRANSPARENT);
						isOpaque = false;
					}
				}
				else
				{
					if (!isOpaque)
					{
						mView.setBackgroundColor(fragmentActivity.getResources().getColor(R.color.primary_material_light));
						isOpaque = true;
					}
				}
			}

			@Override
			public void onPageSelected(int position)
			{
				setIndicator(position);

				if (position == NUM_PAGES - 1)
				{
					endTutorial();
				}
			}
		});

		setIndicator(0);
	}

	public void onBackPressed()
	{
		if (viewPager.getCurrentItem() == 0)
		{
			endTutorial();
		}
		else
		{
			viewPager.setCurrentItem(viewPager.getCurrentItem() - 1);
		}
	}

	public void onDestroy()
	{
		if (viewPager != null)
		{
			viewPager.clearOnPageChangeListeners();
		}
	}

	private void endTutorial()
	{
		mEndTour.run();
	}

	@SuppressWarnings("deprecation")
	private void setIndicator(int index)
	{
		if (index > 2)
			return;

		TextView[] texts = {lblOne, lblTwo, lblThree};
		int[] colors = {mFragmentActivity.getResources().getColor(R.color.green),
				mFragmentActivity.getResources().getColor(R.color.light_blue),
				mFragmentActivity.getResources().getColor(R.color.purpure)};

		for (int i = 0; i < texts.length; i++)
		{
			float alphaStart = i == index ? 0.5f : 1;
			float alphaEnd = i == index ? 1 : 0.5f;
			if (texts[i].getAlpha() != alphaEnd)
			{
				ObjectAnimator anim = ObjectAnimator.ofFloat(texts[i], "alpha", alphaStart, alphaEnd);
				anim.setDuration(200);
				anim.start();
			}
		}

		for (final TextView text : texts)
		{
			text.setTextColor(colors[index]);
		}

		switch (index)
		{
			case 0:
				ActivityUtils.setStatusBarColorRes(mFragmentActivity, R.color.green);
				break;

			case 1:
				ActivityUtils.setStatusBarColorRes(mFragmentActivity, R.color.light_blue);
				break;

			case 2:
				ActivityUtils.setStatusBarColorRes(mFragmentActivity, R.color.purpure);
				break;
		}
	}

	public static class AppTourFragment extends Fragment
	{
		final static String IMAGE_RES_ARG_NAME = "IMAGE_RES_ARG_NAME";
		final static String TITLE_RES_ARG_NAME = "TITLE_RES_ARG_NAME";
		final static String DESC_RES_ARG_NAME = "DESC_RES_ARG_NAME";

		@Bind(R.id.imgTour)
		ImageView imgTour;

		@Bind(R.id.lblTitle)
		TextView lblTitle;

		@Bind(R.id.lblDesc)
		TextView lblDesc;

		public static AppTourFragment newInstance(@DrawableRes int imageRes, @StringRes int titleRes, @StringRes int descRes)
		{
			Bundle args = new Bundle();
			args.putInt(IMAGE_RES_ARG_NAME, imageRes);
			args.putInt(TITLE_RES_ARG_NAME, titleRes);
			args.putInt(DESC_RES_ARG_NAME, descRes);

			AppTourFragment pane = new AppTourFragment();
			pane.setArguments(args);
			return pane;
		}

		@Override
		public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
		{
			View view = inflater.inflate(R.layout.fragment_app_tour, container, false);

			ButterKnife.bind(this, view);

			imgTour.setImageResource(getArguments().getInt(IMAGE_RES_ARG_NAME));
			lblTitle.setText(getArguments().getInt(TITLE_RES_ARG_NAME));
			lblDesc.setText(getArguments().getInt(DESC_RES_ARG_NAME));

			return view;
		}
	}

	private class ScreenSlidePagerAdapter extends FragmentStatePagerAdapter
	{
		public ScreenSlidePagerAdapter(FragmentManager fm)
		{
			super(fm);
		}

		@Override
		public int getCount()
		{
			return NUM_PAGES;
		}

		@Override
		public Fragment getItem(int position)
		{
			Fragment tp = null;
			switch (position)
			{
				case 0:
					tp = AppTourFragment.newInstance(R.drawable.img_tour_1, R.string.tour_title_1, R.string.tour_desc_1);
					break;
				case 1:
					tp = AppTourFragment.newInstance(R.drawable.img_tour_2, R.string.tour_title_2, R.string.tour_desc_2);
					break;
				case 2:
					tp = AppTourFragment.newInstance(R.drawable.img_tour_3, R.string.tour_title_3, R.string.tour_desc_3);
					break;
				case 3:
					tp = new Fragment();
					break;
			}

			return tp;
		}
	}

	public class CrossfadePageTransformer implements ViewPager.PageTransformer
	{
		@Override
		public void transformPage(View page, float position)
		{
			int pageWidth = page.getWidth();

			View rootContainer = page.findViewById(R.id.rootContainer);
			View lblTitle = page.findViewById(R.id.lblTitle);
			View lblDesc = page.findViewById(R.id.lblDesc);
			View imgTour = page.findViewById(R.id.imgTour);

			if (0 <= position && position < 1)
			{
				com.nineoldandroids.view.ViewHelper.setTranslationX(page, pageWidth * -position);
			}
			if (-1 < position && position < 0)
			{
				com.nineoldandroids.view.ViewHelper.setTranslationX(page, pageWidth * -position);
			}

			if (position > -1.0f || position < 1.0f || position != 0.0f)
			{
				if (rootContainer != null)
				{
					com.nineoldandroids.view.ViewHelper.setAlpha(rootContainer, 1.0f - Math.abs(position));
				}

				if (lblTitle != null)
				{
					com.nineoldandroids.view.ViewHelper.setTranslationX(lblTitle, pageWidth * position);
					com.nineoldandroids.view.ViewHelper.setAlpha(lblTitle, 1.0f - Math.abs(position));
				}

				if (lblDesc != null)
				{
					com.nineoldandroids.view.ViewHelper.setTranslationX(lblDesc, pageWidth * position);
					com.nineoldandroids.view.ViewHelper.setAlpha(lblDesc, 1.0f - Math.abs(position));
				}

				if (imgTour != null)
				{
					com.nineoldandroids.view.ViewHelper.setTranslationX(imgTour, pageWidth / 2 * position);
					com.nineoldandroids.view.ViewHelper.setAlpha(imgTour, 1.0f - Math.abs(position));
				}
			}
		}
	}
}
