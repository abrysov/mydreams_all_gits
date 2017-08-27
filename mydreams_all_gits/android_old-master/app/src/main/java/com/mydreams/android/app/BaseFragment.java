package com.mydreams.android.app;

import android.content.Context;
import android.content.res.Resources;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v4.view.GravityCompat;
import android.support.v7.widget.Toolbar;
import android.util.Pair;
import android.util.TypedValue;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;

import com.afollestad.materialdialogs.MaterialDialog;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.mydreams.android.BuildConfig;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.service.MyDreamsSpiceService;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.ObjectUtils;
import com.octo.android.robospice.SpiceManager;
import com.rey.material.app.ToolbarManager;

import java.lang.ref.WeakReference;

public class BaseFragment extends Fragment
{
	private static final String THEME_ID_ARG_NAME = "THEME_ID_ARG_NAME";
	protected final String TAG = getClass().getSimpleName();
	private final SpiceManager spiceManager = new SpiceManager(MyDreamsSpiceService.class);
	@Nullable
	private Pair<Integer, WeakReference<Context>> cachedContextThemeWrapper;

	protected static void setThemeIdInArgs(@NonNull Bundle args, @StyleRes int themeId)
	{
		if (args.containsKey(THEME_ID_ARG_NAME))
			args.remove(THEME_ID_ARG_NAME);

		args.putInt(THEME_ID_ARG_NAME, themeId);
	}

	@Override
	public void onCreate(@Nullable final Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

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
	public void onDestroy()
	{
		super.onDestroy();
		MyDreamsApplication.getRefWatcher().watch(this);
	}

	@Override
	public void onStart()
	{
		super.onStart();

		spiceManager.start(getActivity());
	}

	@Override
	public void onStop()
	{
		getBaseActivity().hideSoftKeyboard();

		// Please review https://github.com/octo-online/robospice/issues/96 for the reason of that ugly if statement.
		if (spiceManager.isStarted())
		{
			spiceManager.shouldStop();
		}

		super.onStop();
	}

	protected ToolbarManager createToolbarManager(final View view, final Toolbar toolbar)
	{
		final MainActivity mainActivity = getMainActivity();
		ToolbarManager result = new ToolbarManager(getBaseActivity().getDelegate(), toolbar, R.id.menu_group_main, R.style.ToolbarRippleStyle, R.anim.abc_fade_in, R.anim.abc_fade_out);
		result.setNavigationManager(new ToolbarManager.ThemableNavigationManager(R.array.navigation_drawer, mainActivity.getSupportFragmentManager(), toolbar, mainActivity.getNavigationDrawer())
		{
			@Override
			public boolean isBackState()
			{
				return mFragmentManager.getBackStackEntryCount() > 1;
			}

			@Override
			protected void onDrawerSlide(final View drawerView, final float slideOffset)
			{
				super.onDrawerSlide(drawerView, slideOffset);

				float moveFactor = (mDrawerLayout.findViewById(R.id.drawerList).getWidth() * slideOffset);
				if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
				{
					view.setTranslationX(moveFactor);
				}
			}

			@Override
			public void onNavigationClick()
			{
				if (result.isNavigationBackState())
				{
					getFragmentManager().popBackStack();
				}
				else
				{
					mDrawerLayout.openDrawer(GravityCompat.START);
				}
			}
		});

		return result;
	}

	protected BaseActivity getBaseActivity()
	{
		return (BaseActivity) getActivity();
	}

	@NonNull
	protected Context getContextByArgsTheme()
	{
		Integer theme = getThemeIdFromArgs();
		if (theme != null)
		{
			if (cachedContextThemeWrapper != null && ObjectUtils.equals(cachedContextThemeWrapper.first, theme))
			{
				Context context = cachedContextThemeWrapper.second.get();
				if (context != null)
					return context;
			}

			Context context = new ContextThemeWrapper(getContext(), theme);
			cachedContextThemeWrapper = new Pair<>(theme, new WeakReference<>(context));
			return context;
		}

		return getContext();
	}

	@NonNull
	protected MainActivity getMainActivity()
	{
		return (MainActivity) getActivity();
	}

	protected SpiceManager getSpiceManager()
	{
		return spiceManager;
	}

	@Nullable
	@StyleRes
	protected Integer getThemeIdFromArgs()
	{
		if (getArguments() != null && getArguments().containsKey(THEME_ID_ARG_NAME))
			return getArguments().getInt(THEME_ID_ARG_NAME);

		return null;
	}

	protected void setStatusBarColorFromTheme()
	{
		Context context = getContext();

		Integer themeId = getThemeIdFromArgs();
		if (themeId != null)
		{
			context = new ContextThemeWrapper(getContext(), themeId);
		}

		Resources.Theme theme = context.getTheme();

		TypedValue typedValue = new TypedValue();
		theme.resolveAttribute(R.attr.colorPrimaryDark, typedValue, true);
		ActivityUtils.setStatusBarColor(getBaseActivity(), typedValue.data);
	}

	@NonNull
	protected MaterialDialog showProgressDialog(@StringRes int title, @StringRes int content)
	{
		return showProgressDialog(title, content, getThemeIdFromArgs());
	}

	@NonNull
	protected MaterialDialog showProgressDialog(@StringRes int title, @StringRes int content, @StyleRes @Nullable Integer theme)
	{
		return getBaseActivity().showProgressDialog(title, content, theme);
	}


	protected void showToast(@StringRes int messageId)
	{
		getBaseActivity().showToast(messageId);
	}

	protected void showToast(@StringRes String message)
	{
		getBaseActivity().showToast(message);
	}

	@NonNull
	protected LayoutInflater updateLayoutInflaterByArgsTheme(@NonNull LayoutInflater inflater)
	{
		Integer theme = getThemeIdFromArgs();
		if (theme != null)
			return inflater.cloneInContext(new ContextThemeWrapper(getContext(), theme));

		return inflater;
	}
}
