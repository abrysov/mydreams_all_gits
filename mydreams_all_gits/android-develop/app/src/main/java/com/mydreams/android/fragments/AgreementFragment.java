package com.mydreams.android.fragments;

import android.os.Bundle;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import com.mydreams.android.App;
import com.mydreams.android.R;
import com.mydreams.android.database.AgreementHelper;
import com.mydreams.android.manager.AgreementManager;
import com.mydreams.android.models.Agreement;

import javax.inject.Inject;

import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mikhail on 20.04.16.
 */
public class AgreementFragment extends BaseFragment {

    @Bind(R.id.user_agreement)       TextView userTextAgreement;
    @Bind(R.id.title_user_agreement) TextView titleUserAgreement;
    @Bind(R.id.btn_back)             ImageButton btnBack;

    @Inject
    AgreementManager agreementManager;
    @Inject
    AgreementHelper agreementHelper;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.agreement_layout, null);

        App.getComponent().inject(this);
        ButterKnife.bind(this, view);

        loadAgreement();

        return view;
    }

    @OnClick(R.id.btn_back)
    public void onBackPressed() {
        getActivity().onBackPressed();
    }

    private void loadAgreement() {
        agreementManager.loadAgreement();
        agreementManager.setOnAgreementSaveListener(agreementSaveListener);
    }

    private AgreementManager.OnAgreementSaveListener agreementSaveListener = new AgreementManager.OnAgreementSaveListener() {
        @Override
        public void complete() {
            setTextAgreement();
        }

        @Override
        public void error(String errMsg) {
            showNotificationError(errMsg);
        }
    };

    private void setTextAgreement() {
        Agreement agreement = agreementHelper.getAgreement();
        String userAgreement = agreement.getUserAgreement();
        userTextAgreement.setText(Html.fromHtml(userAgreement.replace("\n", "<br>")));
        titleUserAgreement.setText(agreement.getTitleUserAgreement());
    }

    @Override
    public void onDestroy() {
        ButterKnife.unbind(this);
        super.onDestroy();
    }
}
