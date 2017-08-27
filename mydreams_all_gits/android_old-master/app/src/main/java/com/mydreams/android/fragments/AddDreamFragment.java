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
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.afollestad.materialdialogs.MaterialDialog;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.controller.AbstractDraweeController;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.request.ImageRequest;
import com.facebook.imagepipeline.request.ImageRequestBuilder;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.imageutils.FrescoPostprocessor;
import com.mydreams.android.imageutils.PreprocessPhotoRequest;
import com.mydreams.android.imageutils.effects.GaussianBlurEffect;
import com.mydreams.android.imageutils.effects.GrayscaleEffect;
import com.mydreams.android.imageutils.effects.IEffect;
import com.mydreams.android.imageutils.effects.LookupEffect;
import com.mydreams.android.imageutils.effects.SepiaEffect;
import com.mydreams.android.models.Dream;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.EmptyResponse;
import com.mydreams.android.utils.AccessStorageApi;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.FileUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.DialogFragment;
import com.rey.material.app.SimpleDialog;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.CompoundButton;
import com.soundcloud.android.crop.Crop;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcels;

import java.io.File;
import java.io.IOException;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class AddDreamFragment extends BaseFragment
{
	private static final int GET_PHOTO_FROM_GALLERY_REQUEST_CODE = 1;
	private static final int GET_PHOTO_FROM_CAMERA_REQUEST_CODE = 2;
	private static final String STATE_EXTRA_NAME = "STATE_EXTRA_NAME";
	private static final String PHOTO_INFO_EXTRA_NAME = "PHOTO_INFO_EXTRA_NAME";
	private static final String EFFECT_INDEX_EXTRA_NAME = "EFFECT_INDEX_EXTRA_NAME";
	private static final String DREAM_ARGS_NAME = "DREAM_ARGS_NAME";

	@Bind(R.id.imgMainPhoto)
	SimpleDraweeView imgMainPhoto;

	@Bind(R.id.photoEffectContainer)
	View photoEffectContainer;

	@Bind(R.id.photoEffectContainer1)
	View photoEffectContainer1;

	@Bind(R.id.photoEffectContainer2)
	View photoEffectContainer2;

	@Bind(R.id.photoEffectContainer3)
	View photoEffectContainer3;

	@Bind(R.id.photoEffectContainer4)
	View photoEffectContainer4;

	@Bind(R.id.imgEffect1)
	SimpleDraweeView imgEffect1;

	@Bind(R.id.imgEffect2)
	SimpleDraweeView imgEffect2;

	@Bind(R.id.imgEffect3)
	SimpleDraweeView imgEffect3;

	@Bind(R.id.imgEffect4)
	SimpleDraweeView imgEffect4;

	@Bind(R.id.dreamNameWrapper)
	com.rey.material.widget.EditText dreamNameWrapper;

	@Bind(R.id.dreamDescWrapper)
	com.rey.material.widget.EditText dreamDescWrapper;

	@Bind(R.id.cbDreamDone)
	CompoundButton cbDreamDone;
	@Bind(R.id.btnAddToFlybook)
	Button btnAddToFlybook;
	private View[] photoEffectContainers;
	private PhotoChoreographer photoChoreographer;
	private boolean editMode;
	@NonNull
	private State state = new State();
	private UserPreference userPreference;
	private ToolbarManager mToolbarManager;

	public static Fragment getInstance(@Nullable final Dream dream, @StyleRes int theme)
	{
		final Bundle args = new Bundle();
		if (dream != null)
			args.putParcelable(DREAM_ARGS_NAME, Parcels.wrap(dream));

		setThemeIdInArgs(args, theme);

		Fragment result = new AddDreamFragment();
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
						try
						{
							int maxSize = getResources().getInteger(R.integer.max_dream_photo_size);

							Crop crop = Crop.of(Uri.fromFile(photoFile), Uri.fromFile(createOutFileForCamera()));
							crop.withMaxSize(maxSize, maxSize);
							crop.withAspect(1, 1);
							crop.start(getContext(), this);
						}
						catch (IOException ex)
						{
							Log.w(TAG, "takeFromGallery", ex);
							showToast(R.string.something_wrong);
						}
					}
				}
			}

			state.choicePhotoPath = null;
			state.waitingCameraPhoto = null;
		}
		else if (requestCode == GET_PHOTO_FROM_CAMERA_REQUEST_CODE)
		{
			if (resultCode == Activity.RESULT_OK && state.waitingCameraPhoto != null)
			{
				File photoFile = new File(state.waitingCameraPhoto);
				if (photoFile.exists())
				{
					try
					{
						int maxSize = getResources().getInteger(R.integer.max_avatar_photo_size);

						Crop crop = Crop.of(Uri.fromFile(photoFile), Uri.fromFile(createOutFileForCamera()));
						crop.withMaxSize(maxSize, maxSize);
						crop.withAspect(1, 1);
						crop.start(getContext(), this);
					}
					catch (IOException ex)
					{
						Log.w(TAG, "takeFromCamera", ex);
						showToast(R.string.something_wrong);
					}
				}
			}

			state.choicePhotoPath = null;
			state.waitingCameraPhoto = null;
		}
		else if (requestCode == Crop.REQUEST_CROP)
		{
			if (resultCode == Activity.RESULT_OK && data != null)
			{
				Uri output = Crop.getOutput(data);
				if (output != null)
				{
					state.choicePhotoPath = AccessStorageApi.getPath(getContext(), output);
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
		inflater.inflate(R.menu.add_dream_menu, menu);
		super.onCreateOptionsMenu(menu, inflater);
	}

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		userPreference = new UserPreference(getActivity());

		Dream editDream = getEditDream();
		editMode = userPreference.getUser() != null
				&& editDream != null
				&& editDream.getOwner() != null
				&& editDream.getOwner().getId() == userPreference.getUser().getId();

		PhotoInfo savedPhotoInfo = null;
		Integer savedEffectIndex = null;
		if (savedInstanceState != null)
		{
			if (savedInstanceState.containsKey(STATE_EXTRA_NAME))
			{
				Parcelable savedState = savedInstanceState.getParcelable(STATE_EXTRA_NAME);
				if (savedState != null)
				{
					state = Parcels.unwrap(savedState);
				}

				Parcelable savedPhotoInfoParcel = savedInstanceState.getParcelable(PHOTO_INFO_EXTRA_NAME);
				if (savedPhotoInfoParcel != null)
				{
					savedPhotoInfo = Parcels.unwrap(savedPhotoInfoParcel);
				}

				savedEffectIndex = (Integer) savedInstanceState.getSerializable(EFFECT_INDEX_EXTRA_NAME);
			}
		}

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_add_dream, container, false);
		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		mainActivity.setSupportActionBar(toolbar);

		mToolbarManager = createToolbarManager(result, toolbar);

		photoEffectContainers = new View[]{photoEffectContainer1, photoEffectContainer2, photoEffectContainer3, photoEffectContainer4};
		photoEffectContainer1.setTag(0);
		photoEffectContainer2.setTag(1);
		photoEffectContainer3.setTag(2);
		photoEffectContainer4.setTag(3);

		photoChoreographer = new PhotoChoreographer();
		photoChoreographer.setNewPhoto(savedPhotoInfo);
		photoChoreographer.setEffect(savedEffectIndex);

		if (editMode && editDream != null)
		{
			dreamNameWrapper.setText(editDream.getName());
			dreamDescWrapper.setText(editDream.getDescription());
			cbDreamDone.setChecked(editDream.isDone());
			imgMainPhoto.setImageURI(Uri.parse(editDream.getFullImageUrl()));
		}

		btnAddToFlybook.setText(editMode ? R.string.update_caps : R.string.add_to_flybook);

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

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.green_dark);

		if (state.choicePhotoPath != null)
		{//была выбрана фотка, следует обработь её
			try
			{
				setNewPhoto(state.choicePhotoPath);
				state.choicePhotoPath = null;
			}
			catch (IOException e)
			{
				Log.w(TAG, "onResume", e);
			}
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);
		outState.putParcelable(STATE_EXTRA_NAME, Parcels.wrap(state));
		outState.putParcelable(PHOTO_INFO_EXTRA_NAME, Parcels.wrap(photoChoreographer.getPhotoInfo()));
		outState.putSerializable(EFFECT_INDEX_EXTRA_NAME, photoChoreographer.getEffect());
	}

	@Override
	public void onStart()
	{
		super.onStart();

		Toolbar toolbar = (Toolbar) getActivity().findViewById(R.id.toolbar);
		toolbar.setTitle(StringUtils.EMPTY);
	}

	@OnClick(R.id.btnAddToFlybook)
	void onClickAddToFlybook()
	{
		Log.d(TAG, "onClickAddToFlybook");

		boolean error = false;

		String dreamNameError = getDreamNameFieldError();
		if (StringUtils.isNoneBlank(dreamNameError))
		{
			dreamNameWrapper.setError(dreamNameError);
			error = true;
		}

		String dreamDescError = getDreamDescFieldError();
		if (StringUtils.isNoneBlank(dreamDescError))
		{
			dreamDescWrapper.setError(dreamDescError);
			error = true;
		}

		String photoPath = getPhotoPath();
		if (photoPath == null)
		{
			if (!editMode)
			{
				showToast(R.string.should_choose_photo);
				error = true;
			}
		}

		if (!error)
		{
			DialogInterface dialog = showProgressDialog(editMode ? R.string.update_dream_dialog_title : R.string.add_dream_dialog_title, R.string.please_wait);

			File photoFile = photoPath != null ? new File(photoPath) : null;

			BaseSpiceRequest<EmptyResponse> spiceRequest;
			if (editMode && getEditDream() != null)
			{
				spiceRequest = RequestFactory.updateDream(getEditDream().getId(), getDreamName(), getDreamDesc(), photoFile, cbDreamDone.isChecked());
			}
			else
			{
				spiceRequest = RequestFactory.addDream(getDreamName(), getDreamDesc(), photoFile, cbDreamDone.isChecked());
			}
			getSpiceManager().execute(spiceRequest, new com.octo.android.robospice.request.listener.RequestListener<EmptyResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					Log.w(TAG, "AddDreamRequest", spiceException);

					dialog.cancel();

					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(EmptyResponse response)
				{
					dialog.cancel();

					if (response.getCode() == ResponseStatus.Ok)
					{
						MaterialDialog.ButtonCallback callback = new MaterialDialog.ButtonCallback()
						{
							@Override
							public void onNegative(MaterialDialog dialog)
							{
								MainActivity mainActivity = (MainActivity) getActivity();
								mainActivity.goToFlybook();
							}

							@Override
							public void onPositive(MaterialDialog dialog)
							{
								clear();
							}
						};

						if (editMode)
						{
							showToast(R.string.update_dream_success_dialog_title);
							getMainActivity().popFragment();
						}
						else
						{
							MaterialDialog.Builder builder = new MaterialDialog.Builder(getContextByArgsTheme());
							//noinspection deprecation
							builder.title(R.string.add_dream_success_dialog_title)
									.titleColor(getResources().getColor(R.color.textColorPrimary))
									.positiveText(R.string.add_more)
									.negativeText(R.string.go_to_flybook_caps)
									.callback(callback)
									.cancelable(false)
									.autoDismiss(true);

							builder.build().show();
						}
					}
					else
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							String message = StringUtils.isNotBlank(response.getMessage())
									? response.getMessage()
									: getString(editMode ? R.string.update_dream_error_message : R.string.add_dream_error_message);
							showToast(message);
						}
					}
				}
			});
		}
	}

	@OnClick(R.id.btnCancel)
	void onClickCancel()
	{
		clear();

		if (editMode)
		{
			getMainActivity().popFragment();
		}
		else
		{
			getActivity().finish();
		}
	}

	@OnClick(R.id.fabPhoto)
	void onClickChoicePhoto()
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

	@OnClick(R.id.lblDreamDone)
	void onClickLblDreamDone()
	{
		cbDreamDone.toggle();
	}

	@OnClick(value = {R.id.photoEffectContainer1, R.id.photoEffectContainer2, R.id.photoEffectContainer3, R.id.photoEffectContainer4})
	void onClickPhotoEffectContainer(View sender)
	{
		photoChoreographer.setEffect((Integer) sender.getTag());
	}

	@OnTextChanged(R.id.editDreamDesc)
	void onDreamDescTextChange()
	{
		dreamDescWrapper.clearError();
	}

	@OnTextChanged(R.id.editDreamName)
	void onDreamNameTextChange()
	{
		dreamNameWrapper.clearError();
	}

	private boolean canTakeFromCamera()
	{
		return getCameraIntent(null).resolveActivity(getActivity().getPackageManager()) != null;
	}

	private void clear()
	{
		dreamNameWrapper.setText("");
		dreamDescWrapper.setText("");

		photoChoreographer.setNewPhoto(null);
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

	private String getDreamDesc()
	{
		return dreamDescWrapper.getText().toString();
	}

	private String getDreamDescFieldError()
	{
		int min = getResources().getInteger(R.integer.min_dream_desc_length);
		int max = getResources().getInteger(R.integer.max_dream_desc_length);

		String dreamDesc = getDreamDesc();
		if (StringUtils.isBlank(dreamDesc))
		{
			return getString(R.string.enter_dream_desc_error_message);
		}
		else if (dreamDesc.length() < min || dreamDesc.length() > max)
		{
			return getString(R.string.length_dream_desc_error_message_format, min, max);
		}

		return null;
	}

	private String getDreamName()
	{
		return dreamNameWrapper.getText().toString();
	}

	private String getDreamNameFieldError()
	{
		int min = getResources().getInteger(R.integer.min_dream_name_length);
		int max = getResources().getInteger(R.integer.max_dream_name_length);

		String dreamName = getDreamName();
		if (StringUtils.isBlank(dreamName))
		{
			return getString(R.string.enter_dream_name_error_message);
		}
		else if (dreamName.length() < min || dreamName.length() > max)
		{
			return getString(R.string.length_dream_name_error_message_format, min, max);
		}

		return null;
	}

	@Nullable
	private Dream getEditDream()
	{
		if (getArguments() != null && getArguments().containsKey(DREAM_ARGS_NAME))
			return Parcels.unwrap(getArguments().getParcelable(DREAM_ARGS_NAME));

		return null;
	}

	private Intent getGalleryIntent()
	{
		Intent intent = new Intent();
		intent.setType("image/*");
		intent.setAction(Intent.ACTION_GET_CONTENT);
		return Intent.createChooser(intent, StringUtils.EMPTY);
	}

	/**
	 * путь к фотографии с применёным текущим эффектом
	 */
	@Nullable
	private String getPhotoPath()
	{
		Uri uri = photoChoreographer.getPhotoUri();
		return uri != null ? uri.getPath() : null;
	}

	private void removeFile(Uri uri)
	{
		String path = AccessStorageApi.getPath(getActivity(), uri);
		if (path != null)
		{
			File file = new File(path);
			if (file.exists())
			{//noinspection ResultOfMethodCallIgnored
				file.delete();
			}
		}
	}

	@SuppressWarnings("ResultOfMethodCallIgnored")
	private void removeFiles(PhotoInfo info)
	{
		removeFile(info.originalPhotoUri);
		removeFile(info.thumbPhotoUri);

		for (Uri it : info.originalPhotoWithEffectUris)
		{
			removeFile(it);
		}

		for (Uri it : info.thumpPhotoWithEffectUris)
		{
			removeFile(it);
		}
	}

	private void setNewPhoto(String photoPath) throws IOException
	{
		int mainPhotoSize = getResources().getInteger(R.integer.max_dream_photo_size);
		int thumbSize = getResources().getDimensionPixelSize(R.dimen.add_dream_effect_container_size);

		File folderPath = new File(getActivity().getCacheDir(), "PhotoChoreographer");
		if (!folderPath.exists())
		{
			if (!folderPath.mkdirs())
				throw new RuntimeException("Не удалось создать папку \"" + folderPath.toString() + "\"");
		}

		MaterialDialog dialog = showProgressDialog(R.string.photo_processing_dialog_titile, R.string.please_wait);

		PreprocessPhotoRequest request = new PreprocessPhotoRequest(photoPath, folderPath.toString(), mainPhotoSize, thumbSize, photoChoreographer.effects);
		getSpiceManager().execute(request, new RequestListener<PreprocessPhotoRequest.PreprocessResult>()
		{
			@Override
			public void onRequestFailure(SpiceException spiceException)
			{
				dialog.dismiss();

				showToast(R.string.photo_processing_failed);
			}

			@Override
			public void onRequestSuccess(PreprocessPhotoRequest.PreprocessResult result)
			{
				dialog.dismiss();

				PhotoInfo info = new PhotoInfo(result);
				photoChoreographer.setNewPhoto(info);
			}
		});
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

			state.waitingCameraPhoto = cameraOutFile.toString();
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

	@org.parceler.Parcel
	public static class State
	{
		/**
		 * Путь к файлу в который камера запишет фотографию
		 */
		@Nullable
		public String waitingCameraPhoto;
		/**
		 * Путь к фотографии которую следует установить в качестве выбраной
		 */
		@Nullable
		public String choicePhotoPath;
	}

	@org.parceler.Parcel
	public static class PhotoInfo
	{
		public Uri originalPhotoUri;
		public Uri thumbPhotoUri;

		public Uri[] originalPhotoWithEffectUris;
		public Uri[] thumpPhotoWithEffectUris;

		@SuppressWarnings("unused")
		public PhotoInfo()
		{
		}

		public PhotoInfo(PreprocessPhotoRequest.PreprocessResult preprocessResult)
		{
			this.originalPhotoUri = Uri.fromFile(new File(preprocessResult.getOriginalPhotoPath()));
			this.thumbPhotoUri = Uri.fromFile(new File(preprocessResult.getThumbPhotoPath()));

			File[] effects = preprocessResult.getOriginalWithEffectPaths();
			originalPhotoWithEffectUris = new Uri[effects.length];
			for (int i = 0; i < effects.length; i++)
			{
				originalPhotoWithEffectUris[i] = Uri.fromFile(effects[i]);
			}

			effects = preprocessResult.getThumbWithEffectPaths();
			thumpPhotoWithEffectUris = new Uri[effects.length];
			for (int i = 0; i < effects.length; i++)
			{
				thumpPhotoWithEffectUris[i] = Uri.fromFile(effects[i]);
			}
		}
	}

	private class PhotoChoreographer
	{
		private IEffect grayscaleEffect;
		private IEffect sepiaEffect;
		private IEffect gaussianBlurEffect;
		private IEffect lookupEffect;

		private IEffect[] effects;
		@Nullable
		private Integer effectIndex;
		@Nullable
		private PhotoInfo photoInfo;

		public PhotoChoreographer()
		{
			grayscaleEffect = new GrayscaleEffect(getActivity());
			sepiaEffect = new SepiaEffect(getActivity());
			gaussianBlurEffect = new GaussianBlurEffect(getActivity());
			lookupEffect = new LookupEffect(getActivity());

			effects = new IEffect[]{grayscaleEffect, sepiaEffect, gaussianBlurEffect, lookupEffect};

			setNewPhoto(null);
		}

		@Nullable
		public Integer getEffect()
		{
			return effectIndex;
		}

		@SuppressWarnings("NumberEquality")
		public void setEffect(@Nullable Integer index)
		{
			if (photoInfo == null)
				return;

			effectIndex = index == null || index == effectIndex || index < 0 || index >= effects.length ? null : index;

			if (effectIndex != null)
			{
				setImage(photoInfo.originalPhotoWithEffectUris[effectIndex], imgMainPhoto);

				for (View v : photoEffectContainers)
				{
					Integer tag = (Integer) v.getTag();
					v.setSelected(tag == effectIndex);
				}
			}
			else
			{
				setImage(photoInfo.originalPhotoUri, imgMainPhoto);

				for (View v : photoEffectContainers)
				{
					v.setSelected(false);
				}
			}
		}

		@Nullable
		public PhotoInfo getPhotoInfo()
		{
			return photoInfo;
		}

		@Nullable
		public Uri getPhotoUri()
		{
			return photoInfo != null
					? effectIndex != null
					? photoInfo.originalPhotoWithEffectUris[effectIndex]
					: photoInfo.originalPhotoUri
					: null;
		}

		public void setNewPhoto(@Nullable PhotoInfo photoInfo)
		{
			if (this.photoInfo != null)
			{
				removeFiles(this.photoInfo);
				this.photoInfo = null;
			}

			if (photoInfo != null)
			{
				this.photoInfo = photoInfo;

				setImage(this.photoInfo.originalPhotoUri, imgMainPhoto);

				setEffect(null);
				photoEffectContainer.setVisibility(View.VISIBLE);

				setImage(photoInfo.thumpPhotoWithEffectUris[0], imgEffect1);
				setImage(photoInfo.thumpPhotoWithEffectUris[1], imgEffect2);
				setImage(photoInfo.thumpPhotoWithEffectUris[2], imgEffect3);
				setImage(photoInfo.thumpPhotoWithEffectUris[3], imgEffect4);
			}
			else
			{
				imgMainPhoto.setImageURI(null);
				photoEffectContainer.setVisibility(View.GONE);
			}
		}

		@NonNull
		private ImageRequest makeImageRequest(Uri imageUri, @Nullable IEffect effect)
		{
			FrescoPostprocessor postprocessor = null;

			if (effect != null)
				postprocessor = new FrescoPostprocessor(effect);

			return ImageRequestBuilder.newBuilderWithSource(imageUri)
					.setPostprocessor(postprocessor)
					.setAutoRotateEnabled(true)
					.build();
		}

		private void setImage(Uri imageUri, SimpleDraweeView imageView)
		{
			ImageRequest request = makeImageRequest(imageUri, null);

			AbstractDraweeController controller = Fresco.newDraweeControllerBuilder()
					.setImageRequest(request)
					.setOldController(imageView.getController())
					.build();

			imageView.setController(controller);
		}
	}
}