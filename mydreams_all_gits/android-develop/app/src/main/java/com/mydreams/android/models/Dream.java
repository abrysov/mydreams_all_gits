package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 10.05.16.
 */
public class Dream extends RealmObject {

    @PrimaryKey
    private long id;
    private String title;
    private String description;
    private Photo photo;
    private String cerificateType;
    private boolean fulfilled;
    private long likesCount;
    private long commentsCount;
    private long launchesCount;
    private String createdAt;
    private String restrictionLevel;
    private Dreamer dreamer;

    public String getRestrictionLevel() {
        return restrictionLevel;
    }

    public void setRestrictionLevel(String restrictionLevel) {
        this.restrictionLevel = restrictionLevel;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Photo getPhoto() {
        return photo;
    }

    public void setPhoto(Photo photo) {
        this.photo = photo;
    }

    public String getCerificateType() {
        return cerificateType;
    }

    public void setCerificateType(String cerificateType) {
        this.cerificateType = cerificateType;
    }

    public boolean isFulfilled() {
        return fulfilled;
    }

    public void setFulfilled(boolean fulfilled) {
        this.fulfilled = fulfilled;
    }

    public long getLikesCount() {
        return likesCount;
    }

    public void setLikesCount(long likesCount) {
        this.likesCount = likesCount;
    }

    public long getCommentsCount() {
        return commentsCount;
    }

    public void setCommentsCount(long commentsCount) {
        this.commentsCount = commentsCount;
    }

    public long getLaunchesCount() {
        return launchesCount;
    }

    public void setLaunchesCount(long launchesCount) {
        this.launchesCount = launchesCount;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public Dreamer getDreamer() {
        return dreamer;
    }

    public void setDreamer(Dreamer dreamer) {
        this.dreamer = dreamer;
    }
}
