package com.mydreams.android.activities;

import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.drawable.ScalingUtils;
import com.facebook.drawee.generic.GenericDraweeHierarchy;
import com.facebook.drawee.generic.GenericDraweeHierarchyBuilder;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.R;
import com.mydreams.android.app.BaseActivity;
import com.mydreams.android.imageutils.zoomable.ZoomableDraweeView;
import com.mydreams.android.utils.Action1;
import com.mydreams.android.utils.FixSizeDrawable;
import com.mydreams.android.utils.LockedViewPager;
import com.rey.material.app.ToolbarManager;
import com.rey.material.drawable.CircularProgressDrawable;

import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

public class PhotoViewActivity extends BaseActivity
{
	private static final String PHOTO_URIS_EXTRA_NAME = "PHOTO_URIS_EXTRA_NAME";
	private static final String START_POSITION_EXTRA_NAME = "START_POSITION_EXTRA_NAME";

	@Bind(R.id.viewPager)
	LockedViewPager viewPager;

	private ToolbarManager mToolbarManager;

	public static Intent getLaunchIntent(Context context, List<Uri> photoUris, final int startPosition)
	{
		Intent intent = new Intent(context, PhotoViewActivity.class);
		intent.putParcelableArrayListExtra(PHOTO_URIS_EXTRA_NAME, new ArrayList<>(photoUris));
		intent.putExtra(START_POSITION_EXTRA_NAME, startPosition);
		return intent;
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_photo_view);

		ButterKnife.bind(this);

		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		mToolbarManager = new ToolbarManager(getDelegate(), toolbar, R.id.menu_group_main, R.style.ToolbarRippleStyle, R.anim.abc_fade_in, R.anim.abc_fade_out);

		ActionBar actionBar = getSupportActionBar();
		if (actionBar != null)
		{
			actionBar.setHomeButtonEnabled(true);
			actionBar.setDisplayHomeAsUpEnabled(true);
			actionBar.setDisplayShowTitleEnabled(false);
		}

		viewPager.setAdapter(new PhotoViewAdapter(getPhotoUris(), this::imageZoomChange));
		viewPager.setScrollEnabled(true);
		viewPager.setCurrentItem(getStartPosition());

		if (BuildConfig.DEBUG)
		{
			Fresco.getImagePipelineFactory().getMainDiskStorageCache().clearAll();
			Fresco.getImagePipelineFactory().getSmallImageDiskStorageCache().clearAll();
			Fresco.getImagePipelineFactory().getBitmapMemoryCache().removeAll(cacheKey -> true);
			Fresco.getImagePipelineFactory().getEncodedMemoryCache().removeAll(cacheKey -> true);
			Fresco.getImagePipelineFactory().getBitmapCountingMemoryCache().clear();
			Fresco.getImagePipelineFactory().getEncodedCountingMemoryCache().clear();
		}
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item)
	{
		switch (item.getItemId())
		{
			case android.R.id.home:
				onBackPressed();
				return true;
			default:
				return super.onOptionsItemSelected(item);
		}
	}

	@Override
	public boolean onPrepareOptionsMenu(Menu menu)
	{
		mToolbarManager.onPrepareMenu();
		return super.onPrepareOptionsMenu(menu);
	}

	private List<Uri> getPhotoUris()
	{
		return getIntent().getParcelableArrayListExtra(PHOTO_URIS_EXTRA_NAME);
	}

	private int getStartPosition()
	{
		return getIntent().getIntExtra(START_POSITION_EXTRA_NAME, 0);
	}

	private void imageZoomChange(final Float zoom)
	{
		if (zoom < 1.1)
		{
			viewPager.setScrollEnabled(true);
		}
		else
		{
			viewPager.setScrollEnabled(false);
		}
	}

	public static class PhotoViewAdapter extends PagerAdapter
	{
		private final List<Uri> mItems;
		private final Action1<Float> mImageZoomChangeAction;

		public PhotoViewAdapter(@NonNull List<Uri> items, @NonNull Action1<Float> imageZoomChangeAction)
		{
			mImageZoomChangeAction = imageZoomChangeAction;
			this.mItems = new ArrayList<>(items);
		}

		@Override
		public void destroyItem(ViewGroup container, int position, Object view)
		{
			container.removeView((View) view);
		}

		@Override
		public int getCount()
		{
			return mItems.size();
		}

		@Override
		public Object instantiateItem(ViewGroup container, int position)
		{
			ViewPager pager = (ViewPager) container;
			View view = getView(position, pager);

			pager.addView(view);

			return view;
		}

		@Override
		public boolean isViewFromObject(View view, Object object)
		{
			return view == object;
		}

		private View getView(final int position, final ViewPager pager)
		{
			View view = LayoutInflater.from(pager.getContext()).inflate(R.layout.row_photo_view, pager, false);

			CircularProgressDrawable circularProgressDrawable = new CircularProgressDrawable.Builder(pager.getContext(), R.style.CircularProgressDrawable).build();
			int size = pager.getResources().getDimensionPixelSize(R.dimen.image_progress_bar_size);
			Drawable progressDrawable = new FixSizeDrawable(circularProgressDrawable, size, size);

			ZoomableDraweeView imgPhoto = (ZoomableDraweeView) view.findViewById(R.id.imgPhoto);
			ImageRequest request = ImageRequestBuilder.newBuilderWithSource(mItems.get(position))
					.setAutoRotateEnabled(true)
					.build();

			AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
					.setImageRequest(request)
					.setOldController(imgPhoto.getController())
					.setAutoPlayAnimations(true)
					.build();

			GenericDraweeHierarchy hierarchy = new GenericDraweeHierarchyBuilder(pager.getResources())
					.setActualImageScaleType(ScalingUtils.ScaleType.FIT_CENTER)
					.setProgressBarImage(progressDrawable, ScalingUtils.ScaleType.CENTER)
					.build();

			imgPhoto.setHierarchy(hierarchy);
			imgPhoto.setController(controller);
			imgPhoto.setZoomChangeListener(transform -> mImageZoomChangeAction.invoke(imgPhoto.getScaleFactor()));

			return view;
		}
	}
}
