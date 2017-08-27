package com.mydreams.android.database;
import com.mydreams.android.models.User;
import com.mydreams.android.models.UserStatus;

/**
 * Created by mikhail on 14.04.16.
 */
public class UserHelper extends BaseHelper {

    public boolean save(User user) {
        try {
            realm().beginTransaction();
            realm().copyToRealmOrUpdate(user);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveUserStatus(UserStatus userStatus) {
        try {
            realm().beginTransaction();
            realm().copyToRealmOrUpdate(userStatus);
            realm().commitTransaction();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public UserStatus getUserStatus() {
        return realm().where(UserStatus.class).findFirst();
    }

    public User getUser() {
        return realm().where(User.class).findFirst();
    }

    public boolean userIsBlocked() {
        User user = realm().where(User.class).findFirst();
        if (user.isBlocked()) {
            return true;
        }
        return false;
    }

    public boolean userIsDeleted() {
        User user = realm().where(User.class).findFirst();
        if (user.isDeleted()) {
            return true;
        }
        return false;
    }
}
