package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 15.06.16.
 */
public class UserStatus extends RealmObject {

    @PrimaryKey
    private int id;
    private int coinsCount;
    private int messagesCount;
    private int notificationsCount;
    private int friendRequestsCount;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCoinsCount() {
        return coinsCount;
    }

    public void setCoinsCount(int coinsCount) {
        this.coinsCount = coinsCount;
    }

    public int getMessagesCount() {
        return messagesCount;
    }

    public void setMessagesCount(int messagesCount) {
        this.messagesCount = messagesCount;
    }

    public int getNotificationsCount() {
        return notificationsCount;
    }

    public void setNotificationsCount(int notificationsCount) {
        this.notificationsCount = notificationsCount;
    }

    public int getFriendRequestsCount() {
        return friendRequestsCount;
    }

    public void setFriendRequestsCount(int friendRequestsCount) {
        this.friendRequestsCount = friendRequestsCount;
    }
}
