package com.mydreams.android.activities;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

import com.mydreams.android.BuildConfig;
import com.mydreams.android.R;
import com.mydreams.android.app.BaseActivity;
import com.mydreams.android.app.UserPreference;
import com.mydreams.android.models.User;
import com.mydreams.android.service.models.ResponseStatus;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;
import com.mydreams.android.service.response.AuthorizeUserResponse;
import com.mydreams.android.utils.ActivityUtils;
import com.octo.android.robospice.persistence.exception.SpiceException;

import org.apache.commons.lang3.StringUtils;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.OnTextChanged;

public class SignInActivity extends BaseActivity
{
	@Bind(R.id.loginWrapper)
	com.rey.material.widget.EditText mLoginWrapper;

	@Bind(R.id.editLogin)
	EditText mEditLogin;

	@Bind(R.id.passwordWrapper)
	com.rey.material.widget.EditText mPasswordWrapper;

	@Bind(R.id.editPassword)
	EditText mEditPassword;

	@Bind(R.id.btnSignIn)
	View mBtnSingIn;

	private UserPreference mUserPreference;

	public static Intent getLaunchIntent(Context context)
	{
		return new Intent(context, SignInActivity.class);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);
		ActivityUtils.setStatusBarColorRes(this, R.color.purpure_dark);

		mUserPreference = new UserPreference(this);

		setContentView(R.layout.activity_sign_in);
		ButterKnife.bind(this);

		if (mUserPreference.isLogined())
		{
			signInComplete();
		}

		if (BuildConfig.DEBUG)
		{
			mEditLogin.setText("ggg@ggg.ru");
			mEditPassword.setText("qwerty");
		}
	}

	@Override
	protected void onPause()
	{
		super.onPause();

		hideSoftKeyboard();
	}

	@OnClick(R.id.btnSignIn)
	void onClickSignIn()
	{
		boolean error = false;

		String loginError = getLoginFieldError();
		if (StringUtils.isNoneBlank(loginError))
		{
			mLoginWrapper.setError(loginError);
			error = true;
		}

		String passwordError = getPasswordFieldError();
		if (StringUtils.isNoneBlank(passwordError))
		{
			mPasswordWrapper.setError(passwordError);
			error = true;
		}

		if (!error)
		{
			DialogInterface dialog = showProgressDialog(R.string.sign_in_dialog_title, R.string.please_wait);

			String login = getLogin();
			String password = getPassword();
			BaseSpiceRequest<AuthorizeUserResponse> spiceRequest = RequestFactory.login(login, password);
			getSpiceManager().execute(spiceRequest, new com.octo.android.robospice.request.listener.RequestListener<AuthorizeUserResponse>()
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
						Log.d(TAG, "Login token: " + token);

						mUserPreference.login(response.getToken(), new User(response.getUser()));

						signInComplete();
					}
					else
					{
						String message = StringUtils.isNotBlank(response.getMessage()) ? response.getMessage() : getString(R.string.sign_in_error_message);
						showToast(message);
					}
				}
			});
		}
	}

	@OnClick(R.id.btnSignUp)
	void onClickSignUp()
	{
		startActivity(SignUpActivity.getLaunchIntent(this));
	}

	@OnTextChanged(R.id.editLogin)
	void onLoginTextChange()
	{
		mLoginWrapper.clearError();
	}

	@OnTextChanged(R.id.editPassword)
	void onPasswordTextChange()
	{
		mPasswordWrapper.clearError();
	}

	@NonNull
	private String getLogin()
	{
		return mEditLogin.getText().toString();
	}

	@Nullable
	private String getLoginFieldError()
	{
		String login = getLogin();
		if (StringUtils.isBlank(login))
			return getString(R.string.enter_login_error_message);

		return null;
	}

	@NonNull
	private String getPassword()
	{
		return mEditPassword.getText().toString();
	}

	@Nullable
	private String getPasswordFieldError()
	{
		String password = getPassword();
		if (StringUtils.isBlank(password))
			return getString(R.string.enter_password_error_message);

		return null;
	}

	private void signInComplete()
	{
		Intent intent = MainActivity.getLaunchIntent(this, false);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
		startActivity(intent);
	}
}
