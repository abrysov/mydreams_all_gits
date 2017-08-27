package com.mydreams.android.components;

import android.content.Context;

import org.json.JSONObject;
import org.json.JSONTokener;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by mikhail on 04.04.16.
 */
public class InstagramApp {

    private InstagramSession mSession;
    private InstagramDialog mDialog;
    private String mAuthUrl;
    private String mTokenUrl;
    private String mAccessToken;
    private OAuthAuthenticationListener mListener;

    private String mClientId;
    private String mClientSecret;

    public String mCallbackUrl;
    private static final String AUTH_URL = "https://api.instagram.com/oauth/authorize/";
    private static final String TOKEN_URL = "https://api.instagram.com/oauth/access_token";
    private static final String API_URL = "https://api.instagram.com/v1";

    public InstagramApp(Context context, String clientId, String clientSecret, String callbackUrl) {

        mClientId = clientId;
        mClientSecret = clientSecret;
        mSession = new InstagramSession(context);
        mAccessToken = mSession.getAccessToken();
        mCallbackUrl = callbackUrl;
        mTokenUrl = TOKEN_URL + "?client_id=" + clientId + "&client_secret="
                + clientSecret + "&redirect_uri=" + mCallbackUrl + "&grant_type=authorization_code";
        mAuthUrl = AUTH_URL + "?client_id=" + clientId + "&redirect_uri="
                + mCallbackUrl + "&response_type=code&display=touch&scope=likes+comments+relationships";

        InstagramDialog.InstagramDialogListener listener = new InstagramDialog.InstagramDialogListener() {

            @Override
            public void onSuccess(String code) {
                getAccessToken(code);
            }

            @Override
            public void onCancel() {

            }

            @Override
            public void onError(String error) {

            }
        };

        mDialog = new InstagramDialog(context, mAuthUrl, mCallbackUrl, listener);
    }

    public void getAccessToken(final String code) {

        new Thread() {
            @Override
            public void run() {
                try {
                    URL url = new URL(TOKEN_URL);
                    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                    urlConnection.setRequestMethod("POST");
                    urlConnection.setDoInput(true);
                    urlConnection.setDoOutput(true);
                    OutputStreamWriter writer = new OutputStreamWriter(urlConnection.getOutputStream());
                    writer.write("client_id="+mClientId+
                            "&client_secret="+mClientSecret+
                            "&grant_type=authorization_code" +
                            "&redirect_uri="+mCallbackUrl+
                            "&code=" + code);
                    writer.flush();
                    String response = streamToString(urlConnection.getInputStream());
                    JSONObject jsonObj = (JSONObject) new JSONTokener(response).nextValue();

                    mAccessToken = jsonObj.getString("access_token");

                    String id = jsonObj.getJSONObject("user").getString("id");
                    String user = jsonObj.getJSONObject("user").getString("username");
                    String name = jsonObj.getJSONObject("user").getString("full_name");

                    mSession.storeAccessToken(mAccessToken, id, user, name);

                    mListener.onSuccess(mAccessToken);

                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }
        }.start();
    }

    public void setListener(OAuthAuthenticationListener listener) {
        mListener = listener;
    }

    public boolean hasAccessToken() {
        return (mAccessToken == null) ? false : true;
    }

    public String getUserName() {
        return mSession.getUsername();
    }

    public String getId() {
        return mSession.getId();
    }

    public String getName() {
        return mSession.getName();
    }

    public void authorize() {
        mDialog.show();
    }

    private String streamToString(InputStream is) throws IOException {
        String str = "";

        if (is != null) {
            StringBuilder sb = new StringBuilder();
            String line;

            try {
                BufferedReader reader = new BufferedReader(
                        new InputStreamReader(is));

                while ((line = reader.readLine()) != null) {
                    sb.append(line);
                }

                reader.close();
            } finally {
                is.close();
            }

            str = sb.toString();
        }

        return str;
    }

    public void resetAccessToken() {
        if (mAccessToken != null) {
            mSession.resetAccessToken();
            mAccessToken = null;
        }
    }

    public interface OAuthAuthenticationListener {
        void onSuccess(String accessToken);
        void onFail(String error);
    }
}
