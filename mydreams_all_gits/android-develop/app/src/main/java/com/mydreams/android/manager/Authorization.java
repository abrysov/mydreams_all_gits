package com.mydreams.android.manager;

import android.content.Intent;
import android.support.v4.app.FragmentActivity;

import com.mydreams.android.net.callers.Cancelable;

import java.util.Map;

/**
 * Created by mikhail on 01.04.16.
 */
public interface Authorization {
    Cancelable authorization(Map<String, String> credentials);
    void getFacebookToken(FragmentActivity activity);
    void getVKToken(FragmentActivity activity);
    void getInstagramToken(FragmentActivity activity);
    void getTwitterToken(FragmentActivity activity);
    void authSocial(String accessToken, String typeSocial);
    void onActivityResult(int requestCode, int resultCode, Intent data);
}
