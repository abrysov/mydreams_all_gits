package com.mydreams.android.components;

/**
 * Created by mikhail on 24.03.16.
 */
public enum SelectionSex {
    MALE("MALE"), FEMALE("FEMALE");

    private final String userSex;

    SelectionSex(String userSex) {
        this.userSex = userSex;
    }

    public String toString() {
        return this.userSex;
    }
}
