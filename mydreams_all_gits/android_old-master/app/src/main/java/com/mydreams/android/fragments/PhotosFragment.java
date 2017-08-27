package com.mydreams.android.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.Parcelable;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.util.Pair;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.afollestad.materialdialogs.MaterialDialog;
import com.annimon.stream.Collectors;
import com.annimon.stream.Stream;
import com.facebook.common.executors.CallerThreadExecutor;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.activities.PhotoViewActivity;
import com.mydreams.android.adapters.PhotoAdapter;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.imageutils.FrescoUtils;
import com.mydreams.android.models.Photo;
import com.mydreams.android.service.models.PhotoDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.UserDto;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.UserResponse;
import com.mydreams.android.utils.AccessStorageApi;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.FileUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.DialogFragment;
import com.rey.material.app.SimpleDialog;
import com.rey.material.app.ToolbarManager;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Parcels;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

public class PhotosFragment extends BaseFragment
{
	private static final String STATE_EXTRA_NAME = "STATE_EXTRA_NAME";
	private static final int GET_PHOTO_FROM_GALLERY_REQUEST_CODE = 1;
	private static final int GET_PHOTO_FROM_CAMERA_REQUEST_CODE = 2;
	@Bind(R.id.list)
	RecyclerView list;
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.progressBar)
	View progressBar;
	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	private PhotoAdapter mAdapter;
	private MenuItem saveMenuItem;
	@NonNull
	private State state = new State();
	private int maxPhotoCount;
	private MenuItem addMenuItem;
	private MenuItem editMenuItem;

	public static Fragment getInstance(@Nullable @StyleRes Integer theme)
	{
		final Bundle args = new Bundle();

		if (theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		Fragment result = new PhotosFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (requestCode == GET_PHOTO_FROM_GALLERY_REQUEST_CODE)
		{
			if (resultCode == Activity.RESULT_OK && data != null)
			{
				Uri selectedImageUri = data.getData();

				if (selectedImageUri != null)
				{
					String photoPath = AccessStorageApi.getPath(getActivity(), selectedImageUri);
					if (photoPath == null)
					{
						photoPath = selectedImageUri.getPath();
					}

					File photoFile = new File(photoPath);
					if (photoFile.exists())
					{
						state.choicePhotoPath = photoFile;
					}
				}
			}

			state.waitingCameraPhoto = null;
		}
		else if (requestCode == GET_PHOTO_FROM_CAMERA_REQUEST_CODE)
		{
			if (resultCode == Activity.RESULT_OK && state.waitingCameraPhoto != null)
			{
				if (state.waitingCameraPhoto.exists())
				{
					state.choicePhotoPath = state.waitingCameraPhoto;
				}
			}

			state.waitingCameraPhoto = null;
		}
		else
		{
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.photos_menu, menu);

		editMenuItem = menu.findItem(R.id.edit);
		editMenuItem.setVisible(false);

		addMenuItem = menu.findItem(R.id.add);
		addMenuItem.setVisible(false);

		saveMenuItem = menu.findItem(R.id.save);
		saveMenuItem.setVisible(false);

		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		maxPhotoCount = getResources().getInteger(R.integer.max_photo_count);

		if (savedInstanceState != null)
		{
			if (savedInstanceState.containsKey(STATE_EXTRA_NAME))
			{
				Parcelable savedState = savedInstanceState.getParcelable(STATE_EXTRA_NAME);
				if (savedState != null)
				{
					state = Parcels.unwrap(savedState);
				}
			}
		}

		mUserPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_photos, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.activity_photos_title);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		mAdapter = new PhotoAdapter(this::handlePhotoClick);

		list.setAdapter(mAdapter);
		//list.setItemAnimator(new FadeInAnimator());
		list.setHasFixedSize(true);
		list.setLayoutManager(new GridLayoutManager(getActivity(), 3));

		if (state.items != null && state.items.size() > 0)
		{
			mAdapter.addAll(state.items);
			showList();
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

			case R.id.edit:
				setEditMode(true);
				return true;

			case R.id.save:
				saveChanges();
				return true;

			case R.id.add:
				addPhoto();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		mToolbarManager.onPrepareMenu();
		setEditMode(state.editMode);
		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		if (state.items == null)
		{
			updateItems();
		}
		else
		{
			if (state.choicePhotoPath != null)
			{//была выбрана фотка, следует обработь её
				addNewPhoto(state.choicePhotoPath);
				state.choicePhotoPath = null;
			}
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);
		outState.putParcelable(STATE_EXTRA_NAME, Parcels.wrap(state));
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		updateItems();
	}

	private void addNewPhoto(File photoFile)
	{
		int mainPhotoSize = getResources().getInteger(R.integer.max_photo_size);

		File folderPath = new File(getActivity().getCacheDir(), "Photos");
		if (!folderPath.exists())
		{
			if (!folderPath.mkdirs())
				throw new RuntimeException("Не удалось создать папку \"" + folderPath.toString() + "\"");
		}

		MaterialDialog dialog = showProgressDialog(R.string.photo_processing_dialog_titile, R.string.please_wait);

		BaseSpiceRequest<File> request = new BaseSpiceRequest<>(File.class, service -> {
			File result = FileUtils.createTempFile(folderPath);

			FrescoUtils.processAndSave(photoFile, result, mainPhotoSize, mainPhotoSize, null, CallerThreadExecutor.getInstance());

			return result;
		});
		getSpiceManager().execute(request, new RequestListener<File>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				dialog.dismiss();

				showToast(R.string.photo_processing_failed);
			}

			@Override
			public void onRequestSuccess(File result)
			{
				dialog.dismiss();

				PhotoModel item = new PhotoModel();
				item.newPhotoUrl = result.toURI().toString();

				state.items.add(item);
				mAdapter.add(item);

				invalidateSaveMenuVisibility();
			}
		});
	}

	private void addPhoto()
	{
		if (state.items == null)
			return;

		if (state.items.size() < maxPhotoCount)
		{
			if (canTakeFromCamera())
			{
				Runnable[] actions = new Runnable[]{this::takeFromGallery, this::takeFromCamera};

				SimpleDialog.Builder builder = new SimpleDialog.Builder(R.style.SimpleDialog)
				{
					@Override
					public void onPositiveActionClicked(DialogFragment fragment)
					{
						int index = getSelectedIndex();
						if (index >= 0 && index < actions.length)
						{
							fragment.dismiss();
							actions[index].run();
						}
					}
				};
				builder.items(new String[]{getString(R.string.gallery), getString(R.string.camera)}, -1)
						.title(getString(R.string.choice_photo_dialog_title))
						.negativeAction(getString(R.string.cancel_caps))
						.positiveAction(getString(R.string.choose_caps));

				DialogFragment fragment = DialogFragment.newInstance(getContextByArgsTheme(), builder);
				fragment.show(getBaseActivity().getSupportFragmentManager(), null);
			}
			else
			{
				takeFromGallery();
			}
		}
		else
		{
			showToast(getString(R.string.max_photo_count_message_format, maxPhotoCount));
		}
	}

	private boolean canTakeFromCamera()
	{
		return getCameraIntent(null).resolveActivity(getActivity().getPackageManager()) != null;
	}

	@NonNull
	private File createOutFileForCamera() throws IOException
	{
		File storageDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
		return FileUtils.createTempFile(storageDir);
	}

	private Intent getCameraIntent(File outFile)
	{
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

		if (outFile != null)
			intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(outFile));

		return intent;
	}

	private Intent getGalleryIntent()
	{
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		return Intent.createChooser(intent, StringUtils.EMPTY);
	}

	private void goToPhotoView(final PhotoModel item, final int position)
	{
		final List<Uri> uris = Stream.of(mAdapter.getItems())
				.map(PhotoModel::getFullImageUrl)
				.map(Uri::parse)
				.collect(Collectors.toList());

		Intent intent = PhotoViewActivity.getLaunchIntent(getContext(), uris, position);
		startActivity(intent);
	}

	private void handlePhotoClick(final Integer position)
	{
		PhotoModel item = mAdapter.getItem(position);

		if (state.editMode)
		{
			item.setForDelete(!item.isForDelete());
			mAdapter.notifyItemChanged(position);
		}
		else
		{
			goToPhotoView(item, position);
		}
	}

	private void invalidateSaveMenuVisibility()
	{
		boolean anyForDelete = Stream.of(state.items).anyMatch(PhotoModel::isForDelete);
		boolean newPhotos = Stream.of(state.items).anyMatch(x -> x.getNewPhotoUrl() != null);

		saveMenuItem.setVisible(anyForDelete || newPhotos);
	}

	private void saveChanges()
	{
		List<PhotoModel> forDelete = Stream.of(mAdapter.getItems()).filter(PhotoModel::isForDelete).collect(Collectors.toList());
		List<PhotoModel> newPhotos = Stream.of(mAdapter.getItems()).filter(x -> !x.isForDelete() && x.getNewPhotoUrl() != null).collect(Collectors.toList());

		Stream.of(forDelete).filter(x -> x.getNewPhotoUrl() != null).forEach(mAdapter::remove);

		DialogInterface dialog = showProgressDialog(R.string.save_photos_dialog_title, R.string.please_wait);

		BaseSpiceRequest<RequestFactory.SavePhotosResponse> spiceRequest = RequestFactory.savePhotos(forDelete, newPhotos);
		getSpiceManager().execute(spiceRequest, new RequestListener<RequestFactory.SavePhotosResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				dialog.cancel();

				showToast(R.string.connection_error_message);
			}

			@Override
			public void onRequestSuccess(RequestFactory.SavePhotosResponse response)
			{
				dialog.cancel();

				if (response.failedDeletePhotos)
				{
					showToast(R.string.delete_photos_failed);
				}

				if (response.failedSavePhotos.size() != 0)
				{
					showToast(R.string.save_photos_failed);
				}

				setItems(Stream.of(state.items).filter(x -> response.failedDeletePhotos || !x.forDelete).map(x -> {
					Pair<PhotoDto, PhotoModel> model = Stream.of(response.savedPhotos).filter(y -> y.second == x).findFirst().orElse(null);
					if (model != null)
					{
						return new PhotoModel(model.first);
					}
					else
					{
						return x;
					}
				}).collect(Collectors.toList()));

				invalidateSaveMenuVisibility();
				setEditMode(response.failedDeletePhotos || response.failedSavePhotos.size() != 0);
			}
		});
	}

	private void setEditMode(boolean editMode)
	{
		state.editMode = editMode;

		if (editMode)
		{
			editMenuItem.setVisible(false);
			addMenuItem.setVisible(true);
			saveMenuItem.setVisible(true);
		}
		else
		{

			editMenuItem.setVisible(true);
			addMenuItem.setVisible(false);
			saveMenuItem.setVisible(false);
		}
	}

	private void setItems(List<PhotoModel> items)
	{
		state.items = items;
		mAdapter.clear();
		mAdapter.addAll(items);
	}

	private void showList()
	{
		list.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.GONE);
	}

	private void showProgress()
	{
		list.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
	}

	private void showRetry()
	{
		list.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.VISIBLE);
	}

	private void takeFromCamera()
	{
		if (!canTakeFromCamera())
			return;

		try
		{
			File cameraOutFile = createOutFileForCamera();
			Intent intent = getCameraIntent(cameraOutFile);
			startActivityForResult(intent, GET_PHOTO_FROM_CAMERA_REQUEST_CODE);

			state.waitingCameraPhoto = cameraOutFile;
		}
		catch (IOException ex)
		{
			Log.w(TAG, "takeFromCamera", ex);
			showToast(R.string.something_wrong);
		}
	}

	private void takeFromGallery()
	{
		startActivityForResult(getGalleryIntent(), GET_PHOTO_FROM_GALLERY_REQUEST_CODE);
	}

	private void updateItems()
	{
		state.items = null;
		showProgress();

		BaseSpiceRequest<UserResponse> request = RequestFactory.getMe();
		getSpiceManager().execute(request, new RequestListener<UserResponse>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				showRetry();
			}

			@Override
			public void onRequestSuccess(UserResponse response)
			{
				if (response.getCode() == ResponseStatus.Ok)
				{
					UserDto user = response.getUser();
					List<PhotoDto> dtos = user != null ? user.getPhotos() : new ArrayList<>();
					setItems(Stream.of(dtos).map(PhotoModel::new).collect(Collectors.toList()));
					showList();
				}
				else
				{
					if (response.getCode() == ResponseStatus.Unauthorized)
					{
						getMainActivity().goToSignIn();
					}
					else
					{
						showRetry();
					}
				}
			}
		});
	}

	@Parcel(Parcel.Serialization.BEAN)
	public static class PhotoModel
	{
		private int id;
		private boolean forDelete;
		private String newPhotoUrl;
		private String fullImageUrl;
		private String fullThumbUrl;

		public PhotoModel()
		{
		}

		public PhotoModel(PhotoDto dto)
		{
			Photo photo = new Photo(dto);
			fullImageUrl = photo.getFullImageUrl();
			fullThumbUrl = photo.getFullThumbUrl();
			id = photo.getId();
		}

		@Nullable
		public String getFullImageUrl()
		{
			return newPhotoUrl != null ? newPhotoUrl : fullImageUrl;
		}

		public void setFullImageUrl(String fullImageUrl)
		{
			this.fullImageUrl = fullImageUrl;
		}

		@Nullable
		public String getFullThumbUrl()
		{
			return newPhotoUrl != null ? newPhotoUrl : fullThumbUrl;
		}

		public void setFullThumbUrl(String fullThumbUrl)
		{
			this.fullThumbUrl = fullThumbUrl;
		}

		public int getId()
		{
			return id;
		}

		public void setId(int id)
		{
			this.id = id;
		}

		public String getNewPhotoUrl()
		{
			return newPhotoUrl;
		}

		public void setNewPhotoUrl(String newPhotoUrl)
		{
			this.newPhotoUrl = newPhotoUrl;
		}

		public boolean isForDelete()
		{
			return forDelete;
		}

		public void setForDelete(boolean forDelete)
		{
			this.forDelete = forDelete;
		}
	}

	@Parcel(Parcel.Serialization.BEAN)
	public static class State
	{
		/**
		 * Путь к файлу в который камера запишет фотографию
		 */
		@Nullable
		public File waitingCameraPhoto;
		/**
		 * Путь к фотографии которую следует установить в качестве выбраной
		 */
		@Nullable
		public File choicePhotoPath;

		public boolean editMode;

		public List<PhotoModel> items;
	}
}
