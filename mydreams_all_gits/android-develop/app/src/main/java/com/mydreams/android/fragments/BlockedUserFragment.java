package com.mydreams.android.fragments;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.LinearLayout;

import com.mydreams.android.R;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 10.03.16.
 */
public class BlockedUserFragment extends BaseFragment {

    @Bind(R.id.btn_back) ImageButton btnBack;
    @Bind(R.id.support_mail_click) LinearLayout supportEmail;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.blocked_user_layout, null);

        ButterKnife.bind(this, view);

        return view;
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        getActivity().onBackPressed();
    }

    @OnClick(R.id.support_mail_click)
    public void OnClickOpenEmailApp() {
        Intent sendMessage = new Intent(Intent.ACTION_SEND);
        sendMessage.setType("message/rfc822");
        sendMessage.putExtra(Intent.EXTRA_EMAIL, new String[] {getResources().getString(R.string.blocked_user_support_mail)});
        startActivity(sendMessage);
    }

    @Override
    public void onDestroy() {
        ButterKnife.unbind(this);
        super.onDestroy();
    }
}
