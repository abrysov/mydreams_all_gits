package com.mydreams.android.components;

import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.ListView;
import android.widget.RelativeLayout;

/**
 * Created by mikhail on 18.03.16.
 */
public interface SelectionLocationTypeListener {

    void attachView(SelectionLocationType type, ArrayAdapter adapter, Button skipTop, ListView listItem, RelativeLayout layout, Button btnSkipBottom);
}
