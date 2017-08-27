package com.mydreams.android.manager;
import com.mydreams.android.net.callers.BaseCaller;
import com.mydreams.android.net.callers.Cancelable;
import com.mydreams.android.net.callers.ChangeEmailCaller;
import com.mydreams.android.net.callers.ChangePasswordCaller;
import com.mydreams.android.net.callers.CreateAvatarCaller;
import com.mydreams.android.net.callers.ProfileStatusCaller;
import com.mydreams.android.net.callers.UpdateProfileCaller;
import com.mydreams.android.net.callers.UserCaller;

import java.util.Map;

/**
 * Created by mikhail on 14.04.16.
 */
public class UserManager extends BaseManager {

    private OnUserSaveListener saveListener;
    private OnCreateAvatarListener createAvatarListener;
    private OnUserSaveStatusListener saveStatusListener;
    private OnChangeCredentialsListener changeCredentialsListener;

    public Cancelable loadUserInfo() {
        return new UserCaller(this);
    }

    public Cancelable createAvatar(Map<String, Object> paramsRequest) {
        return new CreateAvatarCaller(paramsRequest, this);
    }

    public Cancelable loadProfileStatus() {
        return new ProfileStatusCaller(this);
    }

    public Cancelable changeEmail(Map<String, String> credentials) {
        return new ChangeEmailCaller(credentials, this);
    }

    public Cancelable changePassword(Map<String, Object> credentials) {
        return new ChangePasswordCaller(credentials, this);
    }

    public Cancelable updateProfile(Map<String, Object> credentials) {
        return new UpdateProfileCaller(credentials, this);
    }

    @Override
    public void onLoadComplete(BaseCaller caller) {
        if (caller instanceof UserCaller) {
            saveListener.complete();
        } else if (caller instanceof CreateAvatarCaller) {
            createAvatarListener.complete();
        } else if (caller instanceof ProfileStatusCaller) {
            saveStatusListener.complete();
        } else if (caller instanceof ChangePasswordCaller) {
            changeCredentialsListener.complete();
        } else if (caller instanceof UpdateProfileCaller) {
            changeCredentialsListener.complete();
        } else if (caller instanceof ChangeEmailCaller) {
            changeCredentialsListener.complete();
        }
    }

    @Override
    public void onLoadError(String errMsg, BaseCaller caller) {
        if (caller instanceof UserCaller) {
            saveListener.error(errMsg);
        } else if (caller instanceof CreateAvatarCaller) {
            createAvatarListener.error(errMsg);
        } else if (caller instanceof ProfileStatusCaller) {
            saveStatusListener.error(errMsg);
        } else if (caller instanceof ChangePasswordCaller) {
            changeCredentialsListener.error(errMsg);
        } else if (caller instanceof UpdateProfileCaller) {
            changeCredentialsListener.error(errMsg);
        } else if (caller instanceof ChangeEmailCaller) {
            changeCredentialsListener.error(errMsg);
        }
    }

    public void setChangeCredentialsListener(OnChangeCredentialsListener changeCredentialsListener) {
        this.changeCredentialsListener = changeCredentialsListener;
    }

    public void setUserSaveListener(OnUserSaveListener saveListener) {
        this.saveListener = saveListener;
    }

    public void setCreateAvatarListener(OnCreateAvatarListener createAvatarListener) {
        this.createAvatarListener = createAvatarListener;
    }

    public void setUserSaveStatusListener(OnUserSaveStatusListener saveStatusListener) {
        this.saveStatusListener = saveStatusListener;
    }

    public interface OnUserSaveListener {
        void complete();
        void error(String errMsg);
    }

    public interface OnCreateAvatarListener {
        void complete();
        void error(String errMsg);
    }

    public interface OnUserSaveStatusListener {
        void complete();
        void error(String errMsg);
    }

    public interface OnChangeCredentialsListener {
        void complete();
        void error(String errMsg);
    }
}
