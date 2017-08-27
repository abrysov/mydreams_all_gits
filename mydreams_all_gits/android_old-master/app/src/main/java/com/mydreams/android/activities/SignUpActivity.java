package com.mydreams.android.activities;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender;
import android.location.Address;
import android.location.Geocoder;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ScrollView;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationListener;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationServices;
import com.mydreams.android.R;
import com.mydreams.android.app.BaseActivity;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.Location;
import com.mydreams.android.models.User;
import com.mydreams.android.service.models.LocationDto;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.models.SexType;
import com.mydreams.android.service.request.bodys.RegisterRequestBody;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.AuthorizeUserResponse;
import com.mydreams.android.service.response.LocationsResponse;
import com.mydreams.android.utils.Func0;
import com.mydreams.android.utils.GoogleClientErrorDialog;
import com.mydreams.android.utils.StringValidator;
import com.octo.android.robospice.persistence.exception.SpiceException;
import com.octo.android.robospice.request.listener.RequestListener;
import com.rey.material.app.DatePickerDialog;
import com.rey.material.app.DialogFragment;
import com.rey.material.app.ToolbarManager;
import com.rey.material.widget.CompoundButton;
import com.rey.material.widget.EditText;

import org.apache.commons.lang3.StringUtils;
import org.parceler.Parcel;
import org.parceler.Parcels;

import java.text.DateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnCheckedChanged;
import butterknife.OnClick;
import butterknife.OnTextChanged;
import jonathanfinerty.once.Once;

public class SignUpActivity extends BaseActivity implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener
{
	private static final int SEARCH_LOCATION_REQUEST_CODE = 1;
	private static final int GOOGLE_CLIENT_RESOLVE_ERROR_REQUEST_CODE = 2;
	private static final String STATE_PARCEL_NAME = "STATE_PARCEL_NAME";

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
	@Bind(R.id.rbMale)
	CompoundButton rbMale;
	@Bind(R.id.rbFemale)
	CompoundButton rbFemale;
	@Bind(R.id.birthWrapper)
	com.rey.material.widget.EditText mBirthWrapper;
	@Bind(R.id.locationWrapper)
	com.rey.material.widget.EditText mLocationWrapper;
	@Bind(R.id.cbAgreeConditions)
	CompoundButton mCbAgreeConditions;
	@Bind(R.id.mainScroll)
	ScrollView mMainScroll;
	@Bind(R.id.birthView)
	View birthView;
	@Bind(R.id.locationView)
	View locationView;
	@Nullable
	private Calendar mBirthDate;
	@Nullable
	private Location mLocation;
	@Nullable
	private android.location.Location mLastLocation;
	private boolean mGoogleClientResolvingError;
	private DateFormat mBirthDateFormat;
	@Nullable
	private LocationListener mLocationListener;
	private UserPreference mUserPreference;
	private ToolbarManager mToolbarManager;
	private GoogleApiClient mGoogleApiClient;

	public static Intent getLaunchIntent(Context context)
	{
		return new Intent(context, SignUpActivity.class);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		if (requestCode == SEARCH_LOCATION_REQUEST_CODE)
		{
			if (resultCode == RESULT_OK)
			{
				setLocation(SearchLocationActivity.extractResult(data));
			}
		}
		else if (requestCode == GOOGLE_CLIENT_RESOLVE_ERROR_REQUEST_CODE)
		{
			mGoogleClientResolvingError = false;
			if (resultCode == RESULT_OK)
			{
				// Make sure the app is not already connected or attempting to connect
				if (!mGoogleApiClient.isConnecting() && !mGoogleApiClient.isConnected())
				{
					mGoogleApiClient.connect();
				}
			}
		}
		else
		{
			super.onActivityResult(requestCode, resultCode, data);
		}
	}

	@Override
	public void onConnected(Bundle connectionHint)
	{
		if (mLocation == null)
		{
			android.location.Location location = LocationServices.FusedLocationApi.getLastLocation(mGoogleApiClient);
			if (location != null)
			{
				handleGpsLocation(location);
			}
			else
			{
				LocationRequest locationRequest = new LocationRequest();
				locationRequest.setNumUpdates(1);

				mLocationListener = loc ->
				{
					if (loc != null)
						handleGpsLocation(loc);

					LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, mLocationListener);
					mLocationListener = null;
				};
				LocationServices.FusedLocationApi.requestLocationUpdates(mGoogleApiClient, locationRequest, mLocationListener);
			}
		}
	}

	@Override
	public void onConnectionFailed(ConnectionResult result)
	{
		if (!mGoogleClientResolvingError)
		{
			if (result.hasResolution())
			{
				try
				{
					mGoogleClientResolvingError = true;
					result.startResolutionForResult(this, GOOGLE_CLIENT_RESOLVE_ERROR_REQUEST_CODE);
				}
				catch (IntentSender.SendIntentException e)
				{
					// There was an error with the resolution intent. Try again.
					mGoogleApiClient.connect();
				}
			}
			else
			{
				// Show dialog using GoogleApiAvailability.getErrorDialog()
				showErrorDialog(result.getErrorCode());
				mGoogleClientResolvingError = true;
			}
		}
	}

	@Override
	public void onConnectionSuspended(int cause)
	{
		// The connection has been interrupted.
		// Disable any UI components that depend on Google APIs
		// until onConnected() is called.
	}

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		mBirthDateFormat = android.text.format.DateFormat.getDateFormat(this);

		if (savedInstanceState != null)
		{
			State state = Parcels.unwrap(savedInstanceState.getParcelable(STATE_PARCEL_NAME));
			state.apply(this);
		}

		mUserPreference = new UserPreference(this);

		setContentView(R.layout.activity_sign_up);
		ButterKnife.bind(this);

		Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
		setSupportActionBar(toolbar);

		ActionBar actionBar = getSupportActionBar();
		if (actionBar != null)
		{
			actionBar.setHomeButtonEnabled(true);
			actionBar.setDisplayHomeAsUpEnabled(true);
			actionBar.setTitle(R.string.sign_up);
		}

		mToolbarManager = new ToolbarManager(getDelegate(), toolbar, R.id.menu_group_main, R.style.ToolbarRippleStyle, R.anim.abc_fade_in, R.anim.abc_fade_out);

		mBirthWrapper.setEnabled(false);
		mLocationWrapper.setEnabled(false);

		int minPassword = getResources().getInteger(R.integer.min_password_length);
		int maxPassword = getResources().getInteger(R.integer.max_password_length);
		mPasswordWrapper.setHelper(getString(R.string.edit_password_helper_format, minPassword, maxPassword));

		buildGoogleApiClient();
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
	protected void onPause()
	{
		super.onPause();

		hideSoftKeyboard();
	}

	@Override
	public boolean onPrepareOptionsMenu(Menu menu)
	{
		mToolbarManager.onPrepareMenu();
		return super.onPrepareOptionsMenu(menu);
	}

	@Override
	protected void onSaveInstanceState(Bundle outState)
	{
		super.onSaveInstanceState(outState);
		outState.putParcelable(STATE_PARCEL_NAME, Parcels.wrap(new State(this)));
	}

	@Override
	public void onStart()
	{
		super.onStart();

		if (!mGoogleClientResolvingError)
		{
			mGoogleApiClient.connect();
		}
	}

	@Override
	public void onStop()
	{
		if (mLocationListener != null)
		{
			if (mGoogleApiClient.isConnected())
				LocationServices.FusedLocationApi.removeLocationUpdates(mGoogleApiClient, mLocationListener);

			mLocationListener = null;
		}

		mGoogleApiClient.disconnect();

		super.onStop();
	}

	@OnClick(R.id.labelAgreements)
	void onClickAgreements()
	{
		startActivity(AgreementsActivity.getLaunchIntent(this));
	}

	@OnClick(R.id.birthView)
	void onClickBirth()
	{
		birthView.requestFocusFromTouch();

		mBirthWrapper.clearError();

		DatePickerDialog.Builder builder = new DatePickerDialog.Builder(R.style.Material_App_Dialog_DatePicker_Light)
		{
			@Override
			public void onNegativeActionClicked(DialogFragment fragment)
			{
				fragment.getDialog().dismiss();

				super.onNegativeActionClicked(fragment);
			}

			@Override
			public void onPositiveActionClicked(DialogFragment fragment)
			{
				DatePickerDialog dialog = (DatePickerDialog) fragment.getDialog();
				setBirthDate(dialog.getDate());
				dialog.dismiss();

				super.onPositiveActionClicked(fragment);
			}
		};

		Calendar showDate = mBirthDate != null ? mBirthDate : Calendar.getInstance();

		Calendar minDate = Calendar.getInstance();
		minDate.add(Calendar.YEAR, -100);

		Calendar maxDate = Calendar.getInstance();

		builder.dateRange(minDate.getTimeInMillis(), maxDate.getTimeInMillis())
				.date(showDate.getTimeInMillis())
				.positiveAction(getString(R.string.ok))
				.negativeAction(getString(R.string.cancel_caps));

		DialogFragment fragment = DialogFragment.newInstance(builder);
		fragment.show(getSupportFragmentManager(), null);
	}

	@OnClick(R.id.locationView)
	void onClickLocation()
	{
		locationView.requestFocusFromTouch();

		mLocationWrapper.clearError();
		startActivityForResult(SearchLocationActivity.getLaunchIntent(this, null), SEARCH_LOCATION_REQUEST_CODE);
	}

	@OnClick(R.id.btnSignUp)
	void onClickSignUp()
	{
		boolean valid = validateForm();
		if (valid)
		{
			DialogInterface dialog = showProgressDialog(R.string.sign_up_dialog_title, R.string.please_wait);

			RegisterRequestBody requsetBody = makeRegisterRequestBody();
			BaseSpiceRequest<AuthorizeUserResponse> request = RequestFactory.register(requsetBody);
			getSpiceManager().execute(request, new RequestListener<AuthorizeUserResponse>()
			{
				@Override
				public void onRequestFailure(SpiceException spiceException)
				{
					dialog.cancel();

					showToast(R.string.connection_error_message);
				}

				@Override
				public void onRequestSuccess(AuthorizeUserResponse response)
				{
					dialog.cancel();

					if (response.getCode() == ResponseStatus.Ok)
					{
						String token = response.getToken();
						Log.d(TAG, "Sign up token: " + token);

						mUserPreference.login(response.getToken(), new User(response.getUser()));

						signUpComplete();
					}
					else
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.sign_up_error_message);
						showToast(message);
					}
				}
			});
		}
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

	@OnTextChanged(R.id.editPassword)
	void onPasswordTextChange()
	{
		mPasswordWrapper.clearError();

		if (StringUtils.isNotBlank(mConfirmPasswordWrapper.getText()))
			onConfirmPasswordTextChange();
	}

	@OnTextChanged(R.id.editPhone)
	void onPhoneTextChange()
	{
		mPhoneWrapper.clearError();
	}

	@OnCheckedChanged({R.id.rbMale, R.id.rbFemale})
	void onSexChange(android.widget.CompoundButton sender, boolean checked)
	{
		if (sender == rbMale)
			rbFemale.setChecked(!checked);

		if (sender == rbFemale)
			rbMale.setChecked(!checked);
	}

	private void autoFindLocation(double latitude, double longitude)
	{
		Geocoder geocoder = new Geocoder(this);
		BaseSpiceRequest<Location> request = new BaseSpiceRequest<>(Location.class, service ->
		{
			List<Address> addresses = geocoder.getFromLocation(latitude, longitude, 1);
			if (addresses != null && addresses.size() > 0)
			{
				Address address = addresses.get(0);
				String locality = address.getLocality();
				if (locality != null)
				{
					LocationsResponse searchResult = service.locations(locality, latitude, longitude, null);
					if (searchResult.getCode() == ResponseStatus.Ok)
					{
						List<LocationDto> locations = searchResult.getLocations();
						if (locations != null && locations.size() == 1)
						{
							LocationDto location = locations.get(0);
							return Location.fromDto(location);
						}
					}
				}
			}

			return null;
		});

		getSpiceManager().execute(request, new RequestListener<Location>()
				{
					@Override
					public void onRequestFailure(SpiceException spiceException)
					{
					}

					@Override
					public void onRequestSuccess(Location location)
					{
						if (mLocation == null && location != null)
						{
							setLocation(location);
						}
					}
				}
		);
	}

	protected synchronized void buildGoogleApiClient()
	{
		mGoogleApiClient = new GoogleApiClient.Builder(this)
				.addApi(LocationServices.API)
				.addConnectionCallbacks(this)
				.addOnConnectionFailedListener(this)
				.build();
	}

	private boolean checkAgreeConditions()
	{
		return mCbAgreeConditions.isChecked();
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
	private String getAgreeConditionsError()
	{
		return checkAgreeConditions() ? null : getString(R.string.agree_conditions_error_message);
	}

	@Nullable
	private String getBirthFieldError()
	{
		return mBirthDate == null ? getString(R.string.enter_birth_error_message) : null;
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
		return StringValidator.EmailValidator.validate(this, getEmail());
	}

	@NonNull
	private String getFirstName()
	{
		return mFirstNameWrapper.getText().toString();
	}

	@Nullable
	private String getFirstNameFieldError()
	{
		return StringValidator.FirstNameValidator.validate(this, getFirstName());
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
		return StringUtils.isEmpty(value) ? null : StringValidator.LastNameValidator.validate(this, value);
	}

	@Nullable
	private String getLocationFieldError()
	{
		return mLocation == null ? getString(R.string.enter_location_error_message) : null;
	}

	@NonNull
	private String getPassword()
	{
		return mPasswordWrapper.getText().toString();
	}

	@Nullable
	private String getPasswordFieldError()
	{
		return StringValidator.PasswordValidator.validate(this, getPassword());
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
		return StringUtils.isEmpty(value) ? null : StringValidator.PhoneValidator.validate(this, value);
	}

	private SexType getSex()
	{
		return rbMale.isChecked() ? SexType.Male : SexType.Female;
	}

	private void handleGpsLocation(@NonNull android.location.Location location)
	{
		mLastLocation = location;
		autoFindLocation(mLastLocation.getLatitude(), mLastLocation.getLongitude());
	}

	private RegisterRequestBody makeRegisterRequestBody()
	{
		RegisterRequestBody result = new RegisterRequestBody();

		result.setFirstName(getFirstName());
		result.setLastName(getLastName());
		result.setEmail(getEmail());
		result.setPhone(getPhone());
		result.setPassword(getPassword());
		result.setSex(getSex());
		result.setBirthday(mBirthDate);

		if (mLocation != null)
			result.setLocation(mLocation.getId());

		return result;
	}

	private void setBirthDate(long date)
	{
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date(date));
		setBirthDate(calendar);
	}

	private void setBirthDate(@NonNull Calendar calendar)
	{
		mBirthDate = calendar;
		mBirthWrapper.setText(mBirthDateFormat.format(calendar.getTime()));
	}

	private void setLocation(@NonNull Location location)
	{
		mLocation = location;
		mLocationWrapper.setText(location.getName());
	}

	/* Creates a dialog for an error message */
	private void showErrorDialog(int errorCode)
	{
		GoogleClientErrorDialog dialogFragment = GoogleClientErrorDialog.create(() -> mGoogleClientResolvingError = false, errorCode, GOOGLE_CLIENT_RESOLVE_ERROR_REQUEST_CODE);
		dialogFragment.show(getSupportFragmentManager(), "GoogleClientErrorDialog");
	}

	private void signUpComplete()
	{
		Once.initialise(this);
		Once.clearDone(MainActivity.ONCE_SHOW_TOUR_TAG);

		Intent intent = MainActivity.getLaunchIntent(this, true);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}

	private boolean validateForm()
	{
		boolean hasError = checkHasError(this::getFirstNameFieldError, mFirstNameWrapper, true);
		hasError |= checkHasError(this::getLastNameFieldError, mLastNameWrapper, !hasError);
		hasError |= checkHasError(this::getEmailFieldError, mEmailWrapper, !hasError);
		hasError |= checkHasError(this::getPhoneFieldError, mPhoneWrapper, !hasError);
		hasError |= checkHasError(this::getPasswordFieldError, mPasswordWrapper, !hasError);
		hasError |= checkHasError(this::getConfirmPasswordFieldError, mConfirmPasswordWrapper, !hasError);
		hasError |= checkHasError(this::getBirthFieldError, mBirthWrapper, false);
		hasError |= checkHasError(this::getLocationFieldError, mLocationWrapper, false);

		String error = getAgreeConditionsError();
		if (error != null)
		{
			showToast(error);
			hasError = true;
		}

		return !hasError;
	}

	@SuppressWarnings("unused")
	@Parcel(Parcel.Serialization.BEAN)
	public static class State
	{
		private boolean mGoogleClientResolvingError;
		@Nullable
		private android.location.Location mLastLocation;
		@Nullable
		private Location mLocation;
		@Nullable
		private Calendar mBirthDate;

		public State()
		{

		}

		public State(@NonNull SignUpActivity activity)
		{
			mGoogleClientResolvingError = activity.mGoogleClientResolvingError;
			mLastLocation = activity.mLastLocation;
			mLocation = activity.mLocation;
			mBirthDate = activity.mBirthDate;
		}

		public void apply(@NonNull SignUpActivity activity)
		{
			activity.mGoogleClientResolvingError = mGoogleClientResolvingError;
			activity.mLastLocation = mLastLocation;
			activity.mLocation = mLocation;
			activity.mBirthDate = mBirthDate;
		}

		@Nullable
		public Calendar getBirthDate()
		{
			return mBirthDate;
		}

		public void setBirthDate(@Nullable Calendar mBirthDate)
		{
			this.mBirthDate = mBirthDate;
		}

		@Nullable
		public android.location.Location getLastLocation()
		{
			return mLastLocation;
		}

		public void setLastLocation(@Nullable android.location.Location mLastLocation)
		{
			this.mLastLocation = mLastLocation;
		}

		@Nullable
		public Location getLocation()
		{
			return mLocation;
		}

		public void setLocation(@Nullable Location mLocation)
		{
			this.mLocation = mLocation;
		}

		public boolean isGoogleClientResolvingError()
		{
			return mGoogleClientResolvingError;
		}

		public void setGoogleClientResolvingError(boolean mGoogleClientResolvingError)
		{
			this.mGoogleClientResolvingError = mGoogleClientResolvingError;
		}
	}
}
