package com.mydreams.android.fragments;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
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

import com.facebook.drawee.view.SimpleDraweeView;
import com.mydreams.android.R;
import com.mydreams.android.activities.MainActivity;
import com.mydreams.android.activities.SearchLocationActivity;
import com.mydreams.android.app.BaseFragment;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.Location;
import com.mydreams.android.models.User;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.UpdateProfileResponse;
import com.mydreams.android.service.response.UserResponse;
import com.mydreams.android.utils.AccessStorageApi;
import com.mydreams.android.utils.ActivityUtils;
import com.mydreams.android.utils.FileUtils;
import com.mydreams.android.utils.Func0;
import com.mydreams.android.utils.ObjectUtils;
import com.mydreams.android.utils.StringValidator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.DialogFragment;
import com.rey.material.app.SimpleDialog;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.EditText;
import com.soundcloud.android.crop.Crop;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Parcels;

import java.io.File;
import java.io.IOException;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class EditUserFragment extends BaseFragment
{
	private static final int SEARCH_LOCATION_REQUEST_CODE = 1;
	private static final int GET_PHOTO_FROM_GALLERY_REQUEST_CODE = 3;
	private static final int GET_PHOTO_FROM_CAMERA_REQUEST_CODE = 4;
	private static final String EDIT_MODEL_EXTRA_NAME = "EDIT_MODEL_EXTRA_NAME";
	private static final String USER_EXTRA_NAME = "USER_EXTRA_NAME";
	private static final String AVATAR_STATE_EXTRA_NAME = "AVATAR_STATE_EXTRA_NAME";
	@Bind(R.id.layoutRetry)
	View layoutRetry;
	@Bind(R.id.progressBar)
	com.rey.material.widget.ProgressView progressBar;
	@Bind(R.id.userInfoView)
	View userInfoView;
	@Bind(R.id.scroll)
	View scroll;
	private UserPreference userPreference;
	private ToolbarManager toolbarManager;
	private UserEditView userEditView;
	private User user;
	private AvatarState avatarState = new AvatarState();

	public static Fragment getInstance(@Nullable @StyleRes Integer theme)
	{
		final Bundle args = new Bundle();

		if(theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		Fragment result = new EditUserFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (requestCode == SEARCH_LOCATION_REQUEST_CODE)
		{
			if (resultCode == Activity.RESULT_OK)
			{
				if (userEditView != null)
					userEditView.setLocation(SearchLocationActivity.extractResult(data));
			}
		}
		else if (requestCode == GET_PHOTO_FROM_GALLERY_REQUEST_CODE)
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
							int maxSize = getResources().getInteger(R.integer.max_avatar_photo_size);

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

			avatarState.waitingCameraPhoto = null;
		}
		else if (requestCode == GET_PHOTO_FROM_CAMERA_REQUEST_CODE)
		{
			if (resultCode == Activity.RESULT_OK && avatarState.waitingCameraPhoto != null)
			{
				File photoFile = new File(avatarState.waitingCameraPhoto);
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

			avatarState.waitingCameraPhoto = null;
		}
		else if (requestCode == Crop.REQUEST_CROP)
		{
			if (resultCode == Activity.RESULT_OK && data != null)
			{
				Uri output = Crop.getOutput(data);
				if (output != null)
				{
					avatarState.choicePhotoPath = output;
				}
			}

			avatarState.waitingCameraPhoto = null;
		}
		else
		{
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	@Override
	public void onCreateOptionsMenu(Menu menu, MenuInflater inflater)
	{
		inflater.inflate(R.menu.edit_user_menu, menu);

		MenuItem saveItem = menu.findItem(R.id.save);

		super.onCreateOptionsMenu(menu, inflater);
	}

	@Nullable
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		userPreference = new UserPreference(getActivity());

		setHasOptionsMenu(true);
		setMenuVisibility(true);

		setStatusBarColorFromTheme();

		inflater = updateLayoutInflaterByArgsTheme(inflater);
		View result = inflater.inflate(R.layout.fragment_edit_user, container, false);

		ButterKnife.bind(this, result);

		MainActivity mainActivity = (MainActivity) getActivity();

		Toolbar toolbar = (Toolbar) result.findViewById(R.id.toolbar);
		toolbar.setTitle(R.string.edit_user_title);
		mainActivity.setSupportActionBar(toolbar);

		toolbarManager = createToolbarManager(result, toolbar);

		userEditView = new UserEditView(userInfoView);

		if (savedInstanceState != null)
		{
			user = Parcels.unwrap(savedInstanceState.getParcelable(USER_EXTRA_NAME));
			EditModel editModel = Parcels.unwrap(savedInstanceState.getParcelable(EDIT_MODEL_EXTRA_NAME));
			if (editModel != null)
				userEditView.setUser(editModel);

			if (savedInstanceState.containsKey(AVATAR_STATE_EXTRA_NAME))
			{
				avatarState = Parcels.unwrap(savedInstanceState.getParcelable(AVATAR_STATE_EXTRA_NAME));
			}
		}

		showUser();

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

			case R.id.save:
				saveUser();
				return true;
		}

		return super.onOptionsItemSelected(item);
	}

	@Override
	public void onPrepareOptionsMenu(Menu menu)
	{
		toolbarManager.onPrepareMenu();
		super.onPrepareOptionsMenu(menu);
	}

	@Override
	public void onResume()
	{
		super.onResume();

		ActivityUtils.setStatusBarColorRes(getBaseActivity(), R.color.blue_dark);

		if (user == null)
		{
			updateUser();
		}

		if (avatarState.choicePhotoPath != null)
		{
			userEditView.setAvatar(avatarState.choicePhotoPath);
			avatarState.choicePhotoPath = null;
		}
	}

	@Override
	public void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);

		outState.putParcelable(USER_EXTRA_NAME, Parcels.wrap(user));
		outState.putParcelable(EDIT_MODEL_EXTRA_NAME, Parcels.wrap(userEditView.getEditModelAlways()));

		if (avatarState != null)
		{
			outState.putParcelable(AVATAR_STATE_EXTRA_NAME, Parcels.wrap(avatarState));
		}
	}

	@OnClick(R.id.btnRetry)
	void onClickRetry()
	{
		updateUser();
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

	private void saveUser()
	{
		EditModel model = userEditView.getEditModel();
		if (model != null)
		{
			DialogInterface dialog = showProgressDialog(R.string.update_user_dialog_title, R.string.please_wait);

			BaseSpiceRequest<UpdateProfileResponse> request = RequestFactory.updateUser(model);
			getSpiceManager().execute(request, new RequestListener<UpdateProfileResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					dialog.dismiss();

					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(UpdateProfileResponse response)
				{
					dialog.cancel();

					User user = userPreference.getUser();

					if (response.getCode() != ResponseStatus.Ok)
					{
						if (response.getCode() == ResponseStatus.Unauthorized)
						{
							getMainActivity().goToSignIn();
						}
						else
						{
							if (StringUtils.isNotBlank(response.getMessage()))
							{
								showToast(response.getMessage());
							}
							else
							{
								String message = "";
								if (!response.saveInfoSuccesses)
									message += getString(R.string.update_user_error_message);

								if (!response.saveAvatarSuccesses)
								{
									if (StringUtils.isNotBlank(message))
										message += "\r\n";
									message += getString(R.string.update_avatar_error_message);
								}

								showToast(message);
							}
						}
					}

					if (user != null)
					{
						if (response.saveInfoSuccesses)
						{
							if (model.firstName != null)
								user.setFirstName(model.firstName);

							if (model.lastName != null)
								user.setLastName(model.lastName);

							if (model.email != null)
								user.setEmail(model.email);

							if (model.phone != null)
								user.setPhone(model.phone);

							if (model.locationId != null)
							{
								user.setLocationId(model.locationId);
								user.setLocation(model.location);
							}
						}

						if (response.saveAvatarSuccesses)
						{
							String avatarUrl = response.getBody().getAvatarUrl();
							if (avatarUrl != null)
							{
								user.setAvatarUrl(avatarUrl);
							}
						}

						userPreference.updateUser(user);

						MainActivity mainActivity = (MainActivity) getActivity();
						mainActivity.resetUserInMenu();
						mainActivity.goToFlybook();
					}
				}
			});
		}
	}

	private void setUser(User user)
	{
		this.user = user;
		userEditView.setUser(new EditModel(user));
	}

	private void showProgress()
	{
		scroll.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.VISIBLE);
	}

	private void showRetry()
	{
		scroll.setVisibility(View.GONE);
		layoutRetry.setVisibility(View.VISIBLE);
		progressBar.setVisibility(View.GONE);
	}

	private void showUser()
	{
		scroll.setVisibility(View.VISIBLE);
		layoutRetry.setVisibility(View.GONE);
		progressBar.setVisibility(View.GONE);
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

			avatarState.waitingCameraPhoto = cameraOutFile.toString();
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

	private void updateUser()
	{
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
			public void onRequestSuccess(UserResponse userResponse)
			{
				if (userResponse.getCode() == ResponseStatus.Ok)
				{
					setUser(new User(userResponse.getUser()));
					showUser();
					userEditView.clearPasswords();
				}
				else
				{
					if (userResponse.getCode() == ResponseStatus.Unauthorized)
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

	@Parcel
	public static class AvatarState
	{
		@Nullable
		public String waitingCameraPhoto;
		@Nullable
		public Uri choicePhotoPath;
	}

	@Parcel
	public static class EditModel
	{
		public String firstName;
		public String lastName;
		public String email;
		public String phone;
		public Integer locationId;
		public String location;
		public String newPassword;
		public String oldPassword;
		public Uri avatar;
		public String quote;

		public EditModel()
		{
		}

		public EditModel(User user)
		{
			firstName = user.getFirstName();
			lastName = user.getLastName();
			email = user.getEmail();
			phone = user.getPhone();
			locationId = user.getLocationId();
			location = user.getLocation();
			quote = user.getQuote();

			if (user.getFullAvatarUrl() != null)
			{
				avatar = Uri.parse(user.getFullAvatarUrl());
			}
		}
	}

	class UserEditView
	{
		@Bind(R.id.imgAvatar)
		SimpleDraweeView imgAvatar;
		@Bind(R.id.firstNameWrapper)
		com.rey.material.widget.EditText mFirstNameWrapper;
		@Bind(R.id.lastNameWrapper)
		com.rey.material.widget.EditText mLastNameWrapper;
		@Bind(R.id.emailWrapper)
		com.rey.material.widget.EditText mEmailWrapper;
		@Bind(R.id.phoneWrapper)
		com.rey.material.widget.EditText mPhoneWrapper;
		@Bind(R.id.passwordWrapper)
		com.rey.material.widget.EditText mPasswordWrapper;
		@Bind(R.id.confirmPasswordWrapper)
		com.rey.material.widget.EditText mConfirmPasswordWrapper;
		@Bind(R.id.oldPasswordWrapper)
		com.rey.material.widget.EditText mOldPasswordWrapper;
		@Bind(R.id.locationWrapper)
		com.rey.material.widget.EditText mLocationWrapper;
		@Bind(R.id.statusWrapper)
		com.rey.material.widget.EditText statusWrapper;
		@Nullable
		private Location location;
		private Uri newAvatar;
		@Nullable
		private EditModel originalEditModel;

		public UserEditView(View view)
		{
			ButterKnife.bind(this, view);

			int minPassword = getResources().getInteger(R.integer.min_password_length);
			int maxPassword = getResources().getInteger(R.integer.max_password_length);
			mPasswordWrapper.setHelper(getString(R.string.edit_password_helper_format, minPassword, maxPassword));
		}

		@OnClick(R.id.fab)
		void onClickChangeAvatar()
		{
			if (canTakeFromCamera())
			{
				Runnable[] actions = new Runnable[]{EditUserFragment.this::takeFromGallery, EditUserFragment.this::takeFromCamera};

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

		@OnClick(R.id.locationView)
		void onClickLocation()
		{
			startActivityForResult(SearchLocationActivity.getLaunchIntent(getActivity(), null), SEARCH_LOCATION_REQUEST_CODE);
		}

		@OnTextChanged(R.id.editConfirmPassword)
		void onConfirmPasswordTextChange()
		{
			String error = getConfirmPasswordFieldError();
			if (StringUtils.isBlank(error))
			{
				mConfirmPasswordWrapper.clearError();
			}
			else
			{
				mConfirmPasswordWrapper.setError(error);
			}
		}

		@OnTextChanged(R.id.editEmail)
		void onEmailTextChange()
		{
			mEmailWrapper.clearError();
		}

		@OnTextChanged(R.id.editFirstName)
		void onFirstNameTextChange()
		{
			mFirstNameWrapper.clearError();
		}

		@OnTextChanged(R.id.editLastName)
		void onLastNameTextChange()
		{
			mLastNameWrapper.clearError();
		}

		@OnTextChanged(R.id.editOldPassword)
		void onOldPasswordTextChange()
		{
			mOldPasswordWrapper.clearError();
		}

		@OnTextChanged(R.id.editPassword)
		void onPasswordTextChange()
		{
			mPasswordWrapper.clearError();

			if (StringUtils.isNotBlank(mConfirmPasswordWrapper.getText()))
				onConfirmPasswordTextChange();

			if (StringUtils.isBlank(getPassword()))
			{
				mConfirmPasswordWrapper.clearError();
				mOldPasswordWrapper.clearError();
			}
		}

		@OnTextChanged(R.id.editPhone)
		void onPhoneTextChange()
		{
			mPhoneWrapper.clearError();
		}

		public void clearPasswords()
		{
			mPasswordWrapper.setText("");
			mConfirmPasswordWrapper.setText("");
			mOldPasswordWrapper.setText("");
		}

		@Nullable
		public EditModel getEditModel()
		{
			if (validateForm())
			{
				return getEditModelAlways();
			}

			return null;
		}

		@NonNull
		public EditModel getEditModelAlways()
		{
			EditModel result = new EditModel();

			result.firstName = getFirstName();
			result.lastName = getLastName();
			result.email = getEmail();
			result.phone = getPhone();
			result.locationId = location != null ? location.getId() : null;
			result.location = location != null ? location.getName() : null;
			result.newPassword = getPassword();
			result.oldPassword = mOldPasswordWrapper.getText().toString();
			result.avatar = newAvatar;
			result.quote = statusWrapper.getText().toString();

			if (StringUtils.isBlank(result.newPassword))
			{
				result.newPassword = null;
				result.oldPassword = null;
			}

			if (originalEditModel != null)
			{
				if (ObjectUtils.equals(result.firstName, originalEditModel.firstName))
					result.firstName = null;

				if (ObjectUtils.equals(result.lastName, originalEditModel.lastName))
					result.lastName = null;

				if (ObjectUtils.equals(result.email, originalEditModel.email))
					result.email = null;

				if (ObjectUtils.equals(result.phone, originalEditModel.phone))
					result.phone = null;
			}

			return result;
		}

		public void setAvatar(Uri avatar)
		{
			newAvatar = avatar;
			imgAvatar.setImageURI(avatar);
		}

		public void setLocation(@NonNull Location location)
		{
			this.location = location;
			mLocationWrapper.setText(location.getName());
		}

		public void setUser(EditModel model)
		{
			originalEditModel = model;

			mFirstNameWrapper.setText(model.firstName);
			mLastNameWrapper.setText(model.lastName);
			mEmailWrapper.setText(model.email);
			mPhoneWrapper.setText(model.phone);
			mPasswordWrapper.setText("");
			mConfirmPasswordWrapper.setText("");
			mOldPasswordWrapper.setText("");
			statusWrapper.setText(model.quote);
			if (model.locationId != null)
			{
				setLocation(new Location(model.locationId, model.location, ""));
			}

			if (model.avatar != null)
			{
				imgAvatar.setImageURI(model.avatar);
			}
		}

		private boolean checkConfirmPassword()
		{
			return mConfirmPasswordWrapper.getText().toString().equals(getPassword());
		}

		private boolean checkHasError(Func0<String> function, EditText wrapper, boolean scrollTo)
		{
			String error = function.invoke();
			if (error != null)
			{
				wrapper.setError(error);

				if (scrollTo)
				{
					wrapper.clearFocus();
					wrapper.requestFocusFromTouch();
				}

				return true;
			}

			return false;
		}

		@Nullable
		private String getConfirmPasswordFieldError()
		{
			return checkConfirmPassword() ? null : getString(R.string.confirm_password_error_message);
		}

		@NonNull
		private String getEmail()
		{
			return mEmailWrapper.getText().toString();
		}

		@Nullable
		private String getEmailFieldError()
		{
			return StringValidator.EmailValidator.validate(getContext(), getEmail());
		}

		@NonNull
		private String getFirstName()
		{
			return mFirstNameWrapper.getText().toString();
		}

		@Nullable
		private String getFirstNameFieldError()
		{
			return StringValidator.FirstNameValidator.validate(getContext(), getFirstName());
		}

		@NonNull
		private String getLastName()
		{
			return mLastNameWrapper.getText().toString();
		}

		@Nullable
		private String getLastNameFieldError()
		{
			String value = getLastName();
			return StringUtils.isEmpty(value) ? null : StringValidator.LastNameValidator.validate(getContext(), value);
		}

		@NonNull
		private String getPassword()
		{
			return mPasswordWrapper.getText().toString();
		}

		@Nullable
		private String getPasswordFieldError()
		{
			return StringValidator.PasswordValidator.validate(getContext(), getPassword());
		}

		@NonNull
		private String getPhone()
		{
			return mPhoneWrapper.getText().toString();
		}

		@Nullable
		private String getPhoneFieldError()
		{
			String value = getPhone();
			return StringUtils.isEmpty(value) ? null : StringValidator.PhoneValidator.validate(getContext(), value);
		}

		private boolean validateForm()
		{
			boolean hasError = checkHasError(this::getFirstNameFieldError, mFirstNameWrapper, true);
			hasError |= checkHasError(this::getLastNameFieldError, mLastNameWrapper, !hasError);
			hasError |= checkHasError(this::getEmailFieldError, mEmailWrapper, !hasError);
			hasError |= checkHasError(this::getPhoneFieldError, mPhoneWrapper, !hasError);

			if (StringUtils.isNotBlank(mPasswordWrapper.getText()))
			{
				hasError |= checkHasError(this::getPasswordFieldError, mPasswordWrapper, !hasError);
				hasError |= checkHasError(this::getConfirmPasswordFieldError, mConfirmPasswordWrapper, !hasError);

				if (StringUtils.isBlank(mOldPasswordWrapper.getText()))
				{
					hasError = true;
					mOldPasswordWrapper.setError(getString(R.string.enter_old_password));
				}
			}

			return !hasError;
		}
	}
}
