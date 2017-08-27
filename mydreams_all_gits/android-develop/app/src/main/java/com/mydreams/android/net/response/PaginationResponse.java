package com.mydreams.android.net.response;

import com.mydreams.android.App;
import com.mydreams.android.database.PaginationHelper;
import com.mydreams.android.models.Field;
import com.mydreams.android.models.Pagination;

import org.json.JSONException;
import org.json.JSONObject;

import javax.inject.Inject;

/**
<<<<<<< ff66d7ced1b8575cbb717606f178ba93cdf10435
 * Created by mikhail on 6/10/16.
=======
 * Created by mikhail on 6/17/16.
>>>>>>> фильтрация списка мечтетелй
 */
public class PaginationResponse extends BaseResponse {

    @Inject
    PaginationHelper paginationHelper;

    public PaginationResponse() {
        App.getComponent().inject(this);
    }

    public boolean save(JSONObject meta) {
        Pagination pagination = getParsedPaginationData(meta);
        if (pagination != null) {
            return paginationHelper.save(pagination);
        }
        return false;
    }

    public Pagination getParsedPaginationData(JSONObject meta) {
        Pagination pagination = null;
        try {
            pagination = new Pagination();
            pagination.setTotalCount(meta.getLong(Field.TOTAL_COUNT));
            pagination.setPagesCount(meta.getLong(Field.PAGES_COUNT));
            pagination.setRemainingCount(meta.getLong(Field.REMAINING_COUNT));
            pagination.setPer(meta.getInt(Field.PER));
            pagination.setPage(meta.getInt(Field.PAGE));

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return pagination;
    }
}
