package com.mydreams.android.models;

import io.realm.RealmObject;
import io.realm.annotations.PrimaryKey;

/**
 * Created by mikhail on 03.03.16.
 */
public class User extends RealmObject {

    @PrimaryKey
    private int userId;
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
    private long launches_count;
    private boolean isBlocked;
    private boolean isDeleted;
    private boolean isOnline;
    private int followeesCount;
    private int unreadedMessagesCount;
    private String email;

    public int getFolloweesCount() {
        return followeesCount;
    }

    public void setFolloweesCount(int followeesCount) {
        this.followeesCount = followeesCount;
    }

    public int getUnreadedMessagesCount() {
        return unreadedMessagesCount;
    }

    public void setUnreadedMessagesCount(int unreadedMessagesCount) {
        this.unreadedMessagesCount = unreadedMessagesCount;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

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

    public void setBlocked(boolean blocked) {
        isBlocked = blocked;
    }

    public void setDeleted(boolean deleted) {
        isDeleted = deleted;
    }

    public void setOnline(boolean online) {
        isOnline = online;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
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

    public Avatar getAvatar() {
        return avatar;
    }

    public void setAvatar(Avatar avatar) {
        this.avatar = avatar;
    }

    public long getFulFilledDreamsCount() {
        return fulFilledDreamsCount;
    }

    public void setFulFilledDreamsCount(long fulFilledDreamsCount) {
        this.fulFilledDreamsCount = fulFilledDreamsCount;
    }

    public long getLaunches_count() {
        return launches_count;
    }

    public void setLaunches_count(long launches_count) {
        this.launches_count = launches_count;
    }

    public boolean isBlocked() {
        return isBlocked;
    }

    public void setIsBlocked(boolean isBlocked) {
        this.isBlocked = isBlocked;
    }

    public boolean isDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean isDeleted) {
        this.isDeleted = isDeleted;
    }

    public boolean isOnline() {
        return isOnline;
    }

    public void setIsOnline(boolean isOnline) {
        this.isOnline = isOnline;
    }
}
