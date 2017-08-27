package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 10.05.16.
 */
public class Dreamer extends RealmObject {

    @PrimaryKey
    private long id;
    private String fullName;
    private String gender;
    private boolean vip;
    private boolean celebrity;
    private City city;
    private Country country;
    private long visitsCount;
    private Avatar avatar;
    private String firstName;
    private String lastName;
    private String birthday;
    private String statusUser;
    private long viewCount;
    private long friendsCount;
    private long dreamsCount;
    private long fulFilledDreamsCount;
    private long launchesCount;
    private boolean isBlocked;
    private boolean isDeleted;
    private String url;
    private int ageDreamer;
    private boolean isOnline;
    private boolean isFriend;
    private boolean isFollower;

    public City getCity() {
        return city;
    }

    public void setCity(City city) {
        this.city = city;
    }

    public Country getCountry() {
        return country;
    }

    public void setCountry(Country country) {
        this.country = country;
    }

    public boolean isFriend() {
        return isFriend;
    }

    public void setFriend(boolean friend) {
        isFriend = friend;
    }

    public boolean isFollower() {
        return isFollower;
    }

    public boolean isOnline() {
        return isOnline;
    }

    public void setOnline(boolean online) {
        isOnline = online;
    }

    public void setFollower(boolean follower) {
        isFollower = follower;
    }
    
    public int getAgeDreamer() {
        return ageDreamer;
    }

    public void setAgeDreamer(int ageDreamer) {
        this.ageDreamer = ageDreamer;
    }

    public long getVisitsCount() {
        return visitsCount;
    }

    public void setVisitsCount(long visitsCount) {
        this.visitsCount = visitsCount;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getStatusUser() {
        return statusUser;
    }

    public void setStatusUser(String statusUser) {
        this.statusUser = statusUser;
    }

    public long getViewCount() {
        return viewCount;
    }

    public void setViewCount(long viewCount) {
        this.viewCount = viewCount;
    }

    public long getFriendsCount() {
        return friendsCount;
    }

    public void setFriendsCount(long friendsCount) {
        this.friendsCount = friendsCount;
    }

    public long getDreamsCount() {
        return dreamsCount;
    }

    public void setDreamsCount(long dreamsCount) {
        this.dreamsCount = dreamsCount;
    }

    public long getFulFilledDreamsCount() {
        return fulFilledDreamsCount;
    }

    public void setFulFilledDreamsCount(long fulFilledDreamsCount) {
        this.fulFilledDreamsCount = fulFilledDreamsCount;
    }

    public long getLaunchesCount() {
        return launchesCount;
    }

    public void setLaunchesCount(long launchesCount) {
        this.launchesCount = launchesCount;
    }

    public boolean isBlocked() {
        return isBlocked;
    }

    public void setBlocked(boolean blocked) {
        isBlocked = blocked;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public boolean isVip() {
        return vip;
    }

    public void setVip(boolean vip) {
        this.vip = vip;
    }

    public boolean isCelebrity() {
        return celebrity;
    }

    public void setCelebrity(boolean celebrity) {
        this.celebrity = celebrity;
    }

    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
