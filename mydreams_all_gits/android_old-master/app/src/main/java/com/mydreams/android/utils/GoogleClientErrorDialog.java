package com.mydreams.android.utils;


import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.app.DialogFragment;

import com.google.android.gms.common.GoogleApiAvailability;

public class GoogleClientErrorDialog extends DialogFragment
{
	private static final String ERROR_CODE_ARGUMENT_NAME = "ERROR_CODE_ARGUMENT_NAME";
	private int mResolveRequestCode;
	private Runnable mOnDialogDismissed;

	public GoogleClientErrorDialog()
	{
	}

	public static GoogleClientErrorDialog create(Runnable onDialogDismissed, int errorCode, int resolveRequestCode)
	{
		Bundle args = new Bundle();
		args.putInt(ERROR_CODE_ARGUMENT_NAME, errorCode);

		GoogleClientErrorDialog result = new GoogleClientErrorDialog();
		result.setArguments(args);
		result.mOnDialogDismissed = onDialogDismissed;
		result.mResolveRequestCode = resolveRequestCode;

		return result;
	}

	@NonNull
	@Override
	public Dialog onCreateDialog(Bundle savedInstanceState)
	{
		int errorCode = this.getArguments().getInt(ERROR_CODE_ARGUMENT_NAME);
		return GoogleApiAvailability.getInstance().getErrorDialog(this.getActivity(), errorCode, mResolveRequestCode);
	}

	@Override
	public void onDismiss(DialogInterface dialog)
	{
		mOnDialogDismissed.run();

		super.onDismiss(dialog);
	}
}
