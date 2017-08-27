package com.mydreams.android.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.models.Country;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by mikhail on 04.04.16.
 */
public class CountryAdapter extends BaseAdapter {

    private List<Country> data;
    private Context context;
    private int countryItemId;

    public CountryAdapter(Context context, List<Country> countryList, int countryItemId) {
        this.context = context;
        data = countryList;
        this.countryItemId = countryItemId;
    }

    @Override
    public int getCount() {
        return data.size();
    }

    @Override
    public Object getItem(int position) {
        return data.get(position);
    }

    @Override
    public long getItemId(int position) {
        return data.get(position).getId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) convertView = createView(parent);

        bindView(position, convertView);
        return convertView;
    }

    private void bindView(int position, View view) {
        final Holder holder = (Holder) view.getTag();
        final Country country = data.get(position);

        if (country.getNameCountry() != null) {
            holder.name.setText(country.getNameCountry());
        }
    }

    private View createView(ViewGroup parent) {
        final View view = LayoutInflater.from(context).inflate(countryItemId, parent, false);

        final Holder holder = new Holder(view);

        view.setTag(holder);
        return view;
    }

    public class Holder {
        @Bind(R.id.txt_country) TextView name;

        public Holder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
