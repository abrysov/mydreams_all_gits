package com.mydreams.android.activities;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.facebook.drawee.view.SimpleDraweeView;
import com.mikepenz.google_material_typeface_library.GoogleMaterial;
import com.mydreams.android.R;
import com.mydreams.android.adapters.MenuAdapter;
import com.mydreams.android.app.BaseActivity;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.fragments.AddDreamFragment;
import com.mydreams.android.fragments.DreamDoneFragment;
import com.mydreams.android.fragments.DreamTopFragment;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.fragments.SearchUserFragment;
import com.mydreams.android.fragments.SocialInfoFragment;
import com.mydreams.android.fragments.UserActivitiesFragment;
import com.mydreams.android.models.User;
import com.mydreams.android.utils.AppTourController;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import butterknife.Bind;
import butterknife.ButterKnife;
import jonathanfinerty.once.Once;

public class MainActivity extends BaseActivity
{
	static final String ONCE_SHOW_TOUR_TAG = "ONCE_SHOW_TOUR_TAG";
	private static final Tabs START_MENU_POSITION = Tabs.AddDream;
	private static final String SHOW_TOUR_EXTRA_NAME = "SHOW_TOUR_EXTRA_NAME";
	private final Map<UUID, Bundle> fragmentResults = new HashMap<>();
	@Bind(R.id.fragmentContainer)
	FrameLayout fragmentContainer;
	@Bind(R.id.drawerLayout)
	DrawerLayout mDrawerLayout;
	@Bind(R.id.drawerList)
	ListView mDrawerList;
	@Bind(R.id.tourContainer)
	FrameLayout tourContainer;
	private UserPreference mUserPreference;
	private MenuHeaderManager mHeaderManager;
	@Nullable
	private AppTourController mAppTourController;

	public static Intent getLaunchIntent(Context context, final boolean showTour)
	{
		Intent intent = new Intent(context, MainActivity.class);
		intent.putExtra(SHOW_TOUR_EXTRA_NAME, showTour);
		return intent;
	}

	@Override
	public void onBackPressed()
	{
		if (mAppTourController != null)
			mAppTourController.onBackPressed();

		if (mDrawerLayout.isDrawerOpen(GravityCompat.START))
		{
			mDrawerLayout.closeDrawer(GravityCompat.START);
		}
		else
		{
			if (getSupportFragmentManager().getBackStackEntryCount() <= 1)
			{
				finish();
			}
			else
			{
				super.onBackPressed();
			}
		}
	}

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		mUserPreference = new UserPreference(this);

		if (!mUserPreference.isLogined())
		{
			goToSignIn();
		}
		else
		{
			setContentView(R.layout.activity_main);
			ButterKnife.bind(this);

			mHeaderManager = new MenuHeaderManager(LayoutInflater.from(this).inflate(R.layout.menu_header, mDrawerList, false));

			final List<MenuAdapter.MenuItem> menuItems = Arrays.asList(
					new MenuAdapter.MenuItem(Tabs.AddDream.ordinal(), GoogleMaterial.Icon.gmd_photo_camera, R.color.green, R.string.drawer_item_add, R.drawable.menu_item_selector_green),
					new MenuAdapter.MenuItem(Tabs.Flybook.ordinal(), GoogleMaterial.Icon.gmd_account_box, isVip() ? R.color.purpure : R.color.light_blue, R.string.drawer_item_flybook, isVip() ? R.drawable.menu_item_selector_purpure : R.drawable.menu_item_selector_light_blue),
					new MenuAdapter.MenuItem(Tabs.SocialInfo.ordinal(), GoogleMaterial.Icon.gmd_group, R.color.blue, R.string.drawer_item_friends, R.drawable.menu_item_selector_blue),
					new MenuAdapter.MenuItem(Tabs.News.ordinal(), GoogleMaterial.Icon.gmd_subject, R.color.red, R.string.drawer_item_news, R.drawable.menu_item_selector_red),
					new MenuAdapter.MenuItem(Tabs.Top.ordinal(), GoogleMaterial.Icon.gmd_star, R.color.yellow, R.string.drawer_item_top100, R.drawable.menu_item_selector_yellow),
					new MenuAdapter.MenuItem(Tabs.SearchUser.ordinal(), R.drawable.ic_airballoon_white, R.color.light_green, R.string.drawer_item_search_user, R.drawable.menu_item_selector_light_green),
					new MenuAdapter.MenuItem(Tabs.DreamDone.ordinal(), R.drawable.ic_airballoon_white, R.color.light_blue, R.string.drawer_item_dreams_done, R.drawable.menu_item_selector_light_blue)
			);
			final MenuAdapter menuAdapter = new MenuAdapter(this, menuItems);
			mDrawerList.addHeaderView(mHeaderManager.getHeaderView(), null, false);
			mDrawerList.setAdapter(menuAdapter);
			mDrawerList.setOnItemClickListener((parent, view, position, id) -> {
				if (position > 0)
					showFragment(Tabs.values()[((int) id)]);
			});

			resetUserInMenu();

			if (savedInstanceState == null)
			{
				showFragment(START_MENU_POSITION);
			}
		}

		Once.initialise(this);
		boolean done = Once.beenDone(Once.THIS_APP_INSTALL, ONCE_SHOW_TOUR_TAG);
		if (getIntent().getBooleanExtra(SHOW_TOUR_EXTRA_NAME, false) && !done)
		{
			tourContainer.setVisibility(View.VISIBLE);
			mAppTourController = new AppTourController(this, tourContainer, () -> {

				Once.markDone(ONCE_SHOW_TOUR_TAG);

				if (mAppTourController != null)
					mAppTourController.onDestroy();

				mAppTourController = null;

				tourContainer.setVisibility(View.GONE);
			});
		}
		else
		{
			tourContainer.setVisibility(View.GONE);
		}
	}

	@Override
	public void onDestroy()
	{
		if (mAppTourController != null)
			mAppTourController.onDestroy();

		super.onDestroy();
	}

	@Override
	protected void onPause()
	{
		super.onPause();

		hideSoftKeyboard();
	}

	@Nullable
	public Bundle getFragmentResult(@NonNull final UUID requestUUID)
	{
		if (fragmentResults.containsKey(requestUUID))
		{
			Bundle result = fragmentResults.get(requestUUID);
			fragmentResults.remove(requestUUID);
			return result;
		}

		return null;
	}

	public DrawerLayout getNavigationDrawer()
	{
		return mDrawerLayout;
	}

	public void goToFlybook()
	{
		showFragment(Tabs.Flybook);
	}

	public void goToSignIn()
	{
		Once.clearDone(ONCE_SHOW_TOUR_TAG);
		mUserPreference.logout();

		Intent intent = SignInActivity.getLaunchIntent(this);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);

		finish();
	}

	public void popFragment()
	{
		onBackPressed();
	}

	public void putFragmentWithBackStack(@NonNull Fragment fragment, boolean withAnimation)
	{
		getSupportFragmentManager()
				.beginTransaction()
				.replace(R.id.fragmentContainer, fragment)
				.addToBackStack(null)
				.setTransition(withAnimation ? FragmentTransaction.TRANSIT_FRAGMENT_OPEN : FragmentTransaction.TRANSIT_NONE)
				.commit();
	}

	public void putFragmentWithBackStack(@NonNull Fragment fragment)
	{
		putFragmentWithBackStack(fragment, true);
	}

	public void resetUserInMenu()
	{
		User user = mUserPreference.getUser();
		assert user != null;

		mHeaderManager.setUserInfo(user);
	}

	public void setFragmentResult(@NonNull final UUID requestUUID, @NonNull final Bundle result)
	{
		if (fragmentResults.containsKey(requestUUID))
			fragmentResults.remove(requestUUID);

		fragmentResults.put(requestUUID, result);
	}

	private boolean isVip()
	{
		return mUserPreference.getUser() != null && mUserPreference.getUser().isVip();
	}

	private void showFragment(Tabs tab)
	{
		mDrawerList.setItemChecked(tab.ordinal() + 1, true);
		mDrawerLayout.closeDrawer(GravityCompat.START);

		Fragment fragment = null;
		switch (tab)
		{
			case AddDream:
				fragment = AddDreamFragment.getInstance(null, R.style.GreenTheme);
				break;

			case Flybook:
				fragment = FlybookFragment.getInstance(null);
				break;

			case SocialInfo:
				fragment = SocialInfoFragment.getInstance(R.style.BlueTheme);
				break;

			case News:
				fragment = UserActivitiesFragment.getInstance();
				break;

			case Top:
				fragment = DreamTopFragment.getInstance();
				break;

			case SearchUser:
				fragment = SearchUserFragment.getInstance();
				break;

			case DreamDone:
				fragment = DreamDoneFragment.getInstance();
				break;
		}

		if (fragment != null)
			showFragment(fragment);
	}

	private void showFragment(@NonNull Fragment fragment)
	{
		getSupportFragmentManager().popBackStack(null, FragmentManager.POP_BACK_STACK_INCLUSIVE);
		getSupportFragmentManager().beginTransaction().replace(R.id.fragmentContainer, fragment).addToBackStack(null).commit();
	}

	enum Tabs
	{
		AddDream, Flybook, SocialInfo, News, Top, SearchUser, DreamDone
	}

	public static class MenuHeaderManager
	{
		@Bind(R.id.imgBackground)
		ImageView imgBackground;
		@Bind((R.id.imgAvatar))
		SimpleDraweeView imgAvatar;
		@Bind(R.id.lblName)
		TextView lblName;
		@Bind((R.id.lblEmail))
		TextView lblEmail;
		private View mHeaderView;

		public MenuHeaderManager(final View headerView)
		{
			mHeaderView = headerView;
			ButterKnife.bind(this, headerView);
		}

		public View getHeaderView()
		{
			return mHeaderView;
		}

		public void setUserInfo(User user)
		{
			if (user.getFullAvatarUrl() != null)
			{
				imgAvatar.setImageURI(Uri.parse(user.getFullAvatarUrl()));
			}
			else
			{
				imgAvatar.setImageURI(null);
			}

			lblName.setText(user.getFullName());
			lblEmail.setText(user.getEmail());

			imgBackground.setImageResource(user.isVip() ? R.drawable.menu_header_background_purpure : R.drawable.menu_header_background_lightblue);
		}
	}
}
