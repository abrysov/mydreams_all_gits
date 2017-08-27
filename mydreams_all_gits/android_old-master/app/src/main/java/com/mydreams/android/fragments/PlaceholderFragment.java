package com.mydreams.android.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.app.BaseFragment;

import butterknife.Bind;
import butterknife.ButterKnife;

public class PlaceholderFragment extends BaseFragment
{
	@Bind(R.id.lblPlaceholder)
	TextView lblPlaceholder;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		setHasOptionsMenu(true);
		setMenuVisibility(true);

		View result = inflater.inflate(R.layout.fragment_placeholder, container, false);

		ButterKnife.bind(this, result);
		lblPlaceholder.setText("Placeholder fragment - " + hashCode());

		return result;
	}
}
