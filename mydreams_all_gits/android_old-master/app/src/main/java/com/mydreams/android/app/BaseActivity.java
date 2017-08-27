package com.mydreams.android.app;

import android.app.Activity;
import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.annotation.StringRes;
import android.support.annotation.StyleRes;
import android.support.v7.app.AppCompatActivity;
import android.view.ContextThemeWrapper;
import android.view.inputmethod.InputMethodManager;
import android.widget.Toast;

import com.afollestad.materialdialogs.MaterialDialog;
import com.mydreams.android.R;
import com.mydreams.android.service.MyDreamsSpiceService;
import com.octo.android.robospice.SpiceManager;

public class BaseActivity extends AppCompatActivity
{
	protected final String TAG = getClass().getSimpleName();
	private final SpiceManager spiceManager = new SpiceManager(MyDreamsSpiceService.class);

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

		spiceManager.start(this);
	}

	@Override
	public void onStop()
	{
		spiceManager.shouldStop();

		super.onStop();
	}

	public void hideSoftKeyboard()
	{
		InputMethodManager inputMethodManager = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
		inputMethodManager.hideSoftInputFromWindow(getWindow().getDecorView().getWindowToken(), 0);
	}

	protected SpiceManager getSpiceManager()
	{
		return spiceManager;
	}

	@NonNull
	protected MaterialDialog showProgressDialog(@StringRes int title, @StringRes int content, @StyleRes @Nullable Integer theme)
	{
		Context context = this;
		if (theme != null)
			context = new ContextThemeWrapper(this, theme);

		//noinspection deprecation
		return new MaterialDialog.Builder(context)
				.title(title)
				.titleColor(getResources().getColor(R.color.textColorPrimary))
				.content(content)
				.progress(true, 0)
				.cancelable(false)
				.show();
	}

	@NonNull
	protected MaterialDialog showProgressDialog(@StringRes int title, @StringRes int content)
	{
		return showProgressDialog(title, content, null);
	}

	protected void showToast(String message)
	{
		Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
	}

	protected void showToast(@StringRes int messageId)
	{
		Toast.makeText(this, messageId, Toast.LENGTH_SHORT).show();
	}
}
