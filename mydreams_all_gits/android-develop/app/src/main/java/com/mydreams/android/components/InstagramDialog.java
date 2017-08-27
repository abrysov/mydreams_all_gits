package com.mydreams.android.components;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.ViewGroup;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

/**
 * Created by mikhail on 04.04.16.
 */
public class InstagramDialog extends Dialog {

    private ProgressDialog mSpinner;
    private WebView mWebView;
    private LinearLayout mContent;
    private TextView mTitle;

    private String mAuthUrl;
    private String mRedirectUri;

    private InstagramDialogListener mListener;

    static final FrameLayout.LayoutParams FILL = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT,
            ViewGroup.LayoutParams.WRAP_CONTENT);

    static final int MARGIN = 8;
    static final int PADDING = 2;

    public InstagramDialog(Context context, String authUrl, String redirectUri, InstagramDialogListener listener) {
        super(context);

        mAuthUrl		= authUrl;
        mListener		= listener;
        mRedirectUri	= redirectUri;
    }

    @SuppressWarnings("deprecation")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSpinner = new ProgressDialog(getContext());

        mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
        mSpinner.setMessage("Loading...");

        mContent = new LinearLayout(getContext());
        mContent.setOrientation(LinearLayout.VERTICAL);

        setUpTitle();
        setUpWebView();
    }

    private void setUpTitle() {
        requestWindowFeature(Window.FEATURE_NO_TITLE);

        mTitle = new TextView(getContext());

        mTitle.setText("Instagram");
        mTitle.setTextColor(Color.WHITE);
        mTitle.setTypeface(Typeface.DEFAULT_BOLD);
        mTitle.setBackgroundColor(0xFF163753);
        mTitle.setPadding(MARGIN + PADDING, MARGIN, MARGIN, MARGIN);
        mTitle.setCompoundDrawablePadding(MARGIN + PADDING);

        mContent.addView(mTitle);
    }

    private void setUpWebView() {
        mWebView = new WebView(getContext());

        mWebView.setVerticalScrollBarEnabled(false);
        mWebView.setHorizontalScrollBarEnabled(false);
        mWebView.setWebViewClient(new InstagramWebViewClient());
        mWebView.getSettings().setJavaScriptEnabled(true);
        mWebView.loadUrl(mAuthUrl);
        mWebView.setLayoutParams(FILL);

        WebSettings webSettings = mWebView.getSettings();

        webSettings.setSavePassword(false);
        webSettings.setSaveFormData(false);

        mContent.addView(mWebView);

        addContentView(mContent, new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        mListener.onCancel();

    }
    private class InstagramWebViewClient extends WebViewClient {

        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {

            if (url.startsWith(mRedirectUri)) {
                if (url.contains("code")) {
                    String temp[] = url.split("=");

                    mListener.onSuccess(temp[1]);
                } else if (url.contains("onLoadError")) {
                    String temp[] = url.split("=");

                    mListener.onError(temp[temp.length-1]);
                }

                InstagramDialog.this.dismiss();

                return true;
            }

            return false;
        }

        @Override
        public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
            super.onReceivedError(view, errorCode, description, failingUrl);
            mListener.onError(description);
            InstagramDialog.this.dismiss();
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);
            mSpinner.show();
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);

            String title = mWebView.getTitle();

            if (title != null && title.length() > 0) {
                mTitle.setText(title);
            }

            mSpinner.dismiss();
        }
    }

    public interface InstagramDialogListener {
        void onSuccess(String code);
        void onCancel();
        void onError(String error);
    }
}
