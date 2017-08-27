package com.mydreams.android.models;

import io.realm.RealmObject;

/**
<<<<<<< ff66d7ced1b8575cbb717606f178ba93cdf10435
 * Created by mikhail on 08.06.16.
=======
 * Created by mikhail on 6/17/16.
>>>>>>> фильтрация списка мечтетелй
 */
public class Pagination extends RealmObject {

    private long totalCount;
    private long pagesCount;
    private long remainingCount;
    private int per;
    private int page;

    public long getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(long totalCount) {
        this.totalCount = totalCount;
    }

    public long getPagesCount() {
        return pagesCount;
    }

    public void setPagesCount(long pagesCount) {
        this.pagesCount = pagesCount;
    }

    public long getRemainingCount() {
        return remainingCount;
    }

    public void setRemainingCount(long remainingCount) {
        this.remainingCount = remainingCount;
    }

    public int getPer() {
        return per;
    }

    public void setPer(int per) {
        this.per = per;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }
}
