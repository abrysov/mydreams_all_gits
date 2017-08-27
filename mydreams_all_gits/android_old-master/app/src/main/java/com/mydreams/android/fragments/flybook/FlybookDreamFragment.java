package com.mydreams.android.fragments.flybook;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.StyleRes;

import com.mydreams.android.R;
import com.mydreams.android.fragments.FlybookFragment;
import com.mydreams.android.models.UserInfo;
import com.mydreams.android.service.request.spice.BaseSpiceRequest;
import com.mydreams.android.service.request.spice.RequestFactory;

import org.parceler.Parcels;

public class FlybookDreamFragment extends BaseFlybookDreamFragment
{
	public static FlybookDreamFragment getInstance(UserInfo user, @Nullable @StyleRes Integer theme)
	{
		final Bundle args = new Bundle();
		if (user != null)
			args.putParcelable(USER_INFO_ARGS_NAME, Parcels.wrap(user));

		if(theme == null)
			theme = R.style.AppTheme;

		setThemeIdInArgs(args, theme);

		FlybookDreamFragment result = new FlybookDreamFragment();
		result.setArguments(args);
		return result;
	}

	@Override
	protected BaseSpiceRequest<RequestFactory.FlybookDreamsResponse> createRequest(final int userId, final int page, final int dreamPageSize)
	{
		return RequestFactory.getUserFlybookList(userId, page, dreamPageSize, page == 1, null);
	}

	@Override
	protected void handleDreamTotal(final int dreamTotal)
	{
		FlybookFragment fragment = (FlybookFragment) getParentFragment();
		fragment.setDreamCount(dreamTotal);
	}
}
