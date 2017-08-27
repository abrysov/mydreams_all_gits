package com.mydreams.android.fragments;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

import com.mydreams.android.MainActivity;

/**
 * Created by user on 26.02.16.
 */
public class BaseFragment extends Fragment {

    protected String className;
    protected int typeFragment;
    private InputMethodManager inputMethodManager;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        className = getClass().getSimpleName();
        super.onCreate(savedInstanceState);
        initInputManager();
    }

    private void initInputManager() {
        inputMethodManager = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
    }

    protected void showKeyboard(EditText editText) {
        inputMethodManager.showSoftInput(editText, 0);
    }

    protected void hideKeyboard() {
        inputMethodManager.hideSoftInputFromWindow(getView().getWindowToken(), 0);
    }

    protected void hideKeyboardPressedEnter(EditText editText) {
        editText.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode == KeyEvent.KEYCODE_ENTER) {
                    hideKeyboard();
                }
                return false;
            }
        });
    }

    protected void showNotificationError(String errMsg) {
        Toast.makeText(getActivity(), errMsg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onResume() {
        super.onResume();
        getParentActivity().setCurrentFragmentType(typeFragment);
    }

    protected void refreshView(int fragmentTag) {
        Fragment fragment = getActivity().getSupportFragmentManager().findFragmentByTag(String.valueOf(fragmentTag));
        final FragmentTransaction fragmentTransaction = getActivity().getSupportFragmentManager().beginTransaction();
        fragmentTransaction.detach(fragment);
        fragmentTransaction.attach(fragment);
        fragmentTransaction.commit();
    }

    protected boolean isOnline() {
        ConnectivityManager cm = (ConnectivityManager) getActivity().getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo != null && netInfo.isConnectedOrConnecting();
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    protected void needOpenFragment(int fragmentType, Bundle bundle) {
        getParentActivity().openFragment(fragmentType, bundle);
    }

    protected MainActivity getParentActivity() {
        return (MainActivity) getActivity();
    }
}
