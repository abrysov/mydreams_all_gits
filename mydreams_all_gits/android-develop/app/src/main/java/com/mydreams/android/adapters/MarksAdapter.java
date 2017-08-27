package com.mydreams.android.adapters;

import android.graphics.drawable.Drawable;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.mydreams.android.R;

import java.util.List;

import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by mikhail on 25.05.16.
 */
public class MarksAdapter extends RecyclerView.Adapter<MarksAdapter.ViewHolder> {

    private List<Integer> marksPriceList;
    private List<Drawable> marksIconList;
    private View.OnClickListener onItemClickListener;

    public MarksAdapter(List<Integer> marksPriceList, List<Drawable> marksIconList, View.OnClickListener onItemClickListener) {
        this.marksPriceList = marksPriceList;
        this.marksIconList = marksIconList;
        this.onItemClickListener = onItemClickListener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.mark_item, parent, false);
        view.setOnClickListener(onItemClickListener);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        int countLaunches = marksPriceList.get(position);
        Drawable icon = marksIconList.get(position);
        holder.icMark.setBackground(icon);
        holder.countLaunches.setText(String.valueOf(countLaunches));
    }

    @Override
    public int getItemCount() {
        return marksPriceList.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        @Bind(R.id.ic_mark)
        ImageView icMark;
        @Bind(R.id.count_launches)
        TextView countLaunches;
        @Bind(R.id.ic_check)
        ImageView icCheck;

        public ViewHolder(View itemView) {
            super(itemView);
            ButterKnife.bind(this, itemView);
        }
    }
}
