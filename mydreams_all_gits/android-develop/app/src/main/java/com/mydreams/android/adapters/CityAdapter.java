package com.mydreams.android.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.mydreams.android.R;
import com.mydreams.android.models.City;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by mikhail on 20.04.16.
 */
public class CityAdapter extends BaseAdapter {

    private List<City> data;
    private Context context;
    private int cityItemId;

    public CityAdapter(Context context, List<City> cityList, int cityItemId) {
        this.context = context;
        data = cityList;
        this.cityItemId = cityItemId;
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
        return data.get(position).getCityId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) convertView = createView(parent);

        bindView(position, convertView);
        return convertView;
    }

    private void bindView(int position, View view) {
        final Holder holder = (Holder) view.getTag();
        final City city = data.get(position);

        if (city.getCityName() != null) {
            holder.cityName.setText(city.getCityName());
        }

        if (city.getCityMeta() != null) {
            holder.regionName.setVisibility(View.VISIBLE);
            holder.regionName.setText(city.getCityMeta());
        }
    }

    private View createView(ViewGroup parent) {
        final View view = LayoutInflater.from(context).inflate(cityItemId, parent, false);

        final Holder holder = new Holder(view);

        view.setTag(holder);
        return view;
    }

    public class Holder {
        @Bind(R.id.city_name)
        TextView cityName;
        @Bind(R.id.region_name)
        TextView regionName;

        public Holder(View view) {
            ButterKnife.bind(this, view);
        }
    }
}
