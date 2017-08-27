package com.mydreams.android.models;
import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;


/**
 * Created by mikhail on 13.04.16.
 */
public class AccessTokenModel extends RealmObject {

    @PrimaryKey
    private String accessToken;
    private long createdAt;
    private long expiresIn;

    public long getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(long createdAt) {
        this.createdAt = createdAt;
    }

    public long getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(long expiresIn) {
        this.expiresIn = expiresIn;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }
}
