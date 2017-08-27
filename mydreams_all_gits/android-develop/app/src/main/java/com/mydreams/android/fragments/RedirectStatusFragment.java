package com.mydreams.android.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.mydreams.android.Config;
import com.mydreams.android.R;

/**
 * Created by mikhail on 04.03.16.
 */
public class RedirectStatusFragment extends BaseFragment implements View.OnClickListener {

    private View view;
    private Button btnEntry;
    private Button btnAgain;
    private TextView userMail;
    private Bundle mBundle;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.redirect_status, null);

        setRetainInstance(true);

        if (savedInstanceState == null)
            mBundle = (Bundle) getArguments().clone();
        else
            mBundle = (Bundle) savedInstanceState.clone();

        initElementView();

        return view;
    }

    private void initElementView() {
        btnEntry = (Button) view.findViewById(R.id.btn_entry);
        btnEntry.setOnClickListener(this);
        btnAgain = (Button) view.findViewById(R.id.btn_again);
        btnAgain.setOnClickListener(this);
        userMail = (TextView) view.findViewById(R.id.user_mail);
        userMail.setText(mBundle.getString(Config.BUNDLE_USER_MAIL));
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();

        switch (id) {
            case R.id.btn_entry:
                needOpenFragment(Config.FTYPE_AUTHORIZATION, null);
                break;
            case R.id.btn_again:

                break;
        }
    }

    @Override
    public void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putAll(mBundle);
    }
}
