package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 31.03.16.
 */
public class Avatar extends RealmObject {

    private int id;
    private Photo photo;
    private User user;
    private CropMeta cropMeta;
    @PrimaryKey
    private String smallUrl;
    private String preMediumUrl;
    private String mediumUrl;
    private String largeUrl;

    public CropMeta getCropMeta() {
        return cropMeta;
    }

    public void setCropMeta(CropMeta cropMeta) {
        this.cropMeta = cropMeta;
    }

    public Photo getPhoto() {
        return photo;
    }

    public void setPhoto(Photo photo) {
        this.photo = photo;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSmallUrl() {
        return smallUrl;
    }

    public void setSmallUrl(String smallUrl) {
        this.smallUrl = smallUrl;
    }

    public String getPreMediumUrl() {
        return preMediumUrl;
    }

    public void setPreMediumUrl(String preMediumUrl) {
        this.preMediumUrl = preMediumUrl;
    }

    public String getMediumUrl() {
        return mediumUrl;
    }

    public void setMediumUrl(String mediumUrl) {
        this.mediumUrl = mediumUrl;
    }

    public String getLargeUrl() {
        return largeUrl;
    }

    public void setLargeUrl(String largeUrl) {
        this.largeUrl = largeUrl;
    }
}
